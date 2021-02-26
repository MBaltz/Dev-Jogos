import java.lang.reflect.Method;

// Evitar ao máximo usar valores absolutos
// Como essa classe é uma exceção, algumas exceções podem ser feitas

class Popup {
  private Tile tile;
  private boolean deve_fechar = false;

  private int idx_torre = 0;
  private int idx_minerio_1 = 1;
  private int idx_minerio_2 = 2;
  private int idx_minerio_3 = 3;

  private float separacao_btn = 1.2;
  
  private float translate_off = 0.0;

  public Popup(Tile t) {
    this.tile = t;
  }

  public void desenhar() {
    fill(255);
    stroke(255);
    strokeWeight(4);
    noFill();

    textSize(32);
    textAlign(CENTER, CENTER);

    this.desenhar_btn_fechar();
    this.desenhar_carteira();

    if(this.tile.estrutura == null) {
      this.translate_off = 2 * (height/7);
      this.desenhar_menu_nova_estrutura();
      this.translate_off = 0;
      return;
    }

    if(this.tile.estrutura.tipo == Tipo_Estrutura.MINA) {
      this.popup_mina((Mina) this.tile.estrutura); return;
    }
    if(this.tile.estrutura.tipo == Tipo_Estrutura.TORRE) {
      this.popup_torre((Torre) this.tile.estrutura); return;
    }
    if(this.tile.estrutura.tipo == Tipo_Estrutura.BASE) {
      this.popup_base((Base) this.tile.estrutura); return;
    }
  }

  private void desenhar_menu_nova_estrutura() {
    pushMatrix();
    translate(0, this.translate_off);
    this.desenhar_btns();
    popMatrix();
  }


  private void desenhar_btn_fechar() {
    float tamanho = width / 16;
    float pos_x = width - tamanho - (width / 25);
    float pos_y = tamanho;

    line(pos_x, pos_y, pos_x + tamanho, pos_y + tamanho);
    line(pos_x + tamanho, pos_y, pos_x, pos_y + tamanho);
    rect(pos_x, pos_y, tamanho, tamanho);

    if(clicado_main) {
      float mx = x_clicado_main;
      float my = y_clicado_main;

      if(!(mx > pos_x && mx < pos_x + tamanho)) { return; }
      if(!(my > pos_y && my < pos_y + tamanho)) { return; }

      Entrada.limpar_clique();
      this.deve_fechar = true;
    }
  }


  private void desenhar_btns() {
    this.desenhar_btn_mina_torre(this.idx_torre, null,
      "Construir torre" +
      ": $" + String.format("%.2f", Torre.custo_construir)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_1, this.tile.minerio_1,
      "Construir mina de " + this.tile.minerio_1 +
      ": $" + String.format("%.2f", Mina.custo_construir*this.tile.minerio_1.valor)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_2, this.tile.minerio_2,
      "Construir mina de " + this.tile.minerio_2 +
      ": $" + String.format("%.2f", Mina.custo_construir*this.tile.minerio_2.valor)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_3, this.tile.minerio_3,
      "Construir mina de " + this.tile.minerio_3 +
      ": $" + String.format("%.2f", Mina.custo_construir*this.tile.minerio_3.valor)
    );
  }

  private boolean desenhar_btn_generico(int idx, String texto_btn) {
    float tamanho_x = width - 2*(width / 8);
    float tamanho_y = height / 8;
    float pos_x = (width / 8);
    float pos_y = (idx * this.separacao_btn) * tamanho_y;
    boolean clicou = false;

    rect(pos_x, pos_y, tamanho_x, tamanho_y);
    text(texto_btn, pos_x, pos_y, tamanho_x, tamanho_y);

    if(clicado_main) {
      float mx = x_clicado_main;
      float my = y_clicado_main - this.translate_off;

      // se não clicou no botao nem faz nada
      if(!(mx > pos_x && mx < pos_x + tamanho_x)) { return clicou; }
      if(!(my > pos_y && my < pos_y + tamanho_y)) { return clicou; }
      this.deve_fechar = true; // a menos que alguma função diga o contrario
      clicou = true;
      Entrada.limpar_clique();
    }


    return clicou;

  }

  private void desenhar_btn_mina_torre(int idx, Minerio minerio, String texto_btn) {
    // o botao sendo clicado, vamo ver qual ação que faz

    boolean eh_mina = minerio != null ? true : false;

    if(this.desenhar_btn_generico(idx, texto_btn)) {

      if(eh_mina) {
        this.construir_mina(minerio);
      } else {
        this.construir_torre();
      }
    }
  }

  public boolean pediu_pra_fechar() {
    return this.deve_fechar;
  }

  private void desenhar_carteira() {
    float largura_carteira = width / 3;
    float altura_carteira = width / 18;
    float x_carteira = largura_carteira/2 - altura_carteira/2;
    float y_carteira = height/8;
    noFill();
    rect(x_carteira, y_carteira, largura_carteira, altura_carteira);
    textAlign(CENTER, CENTER);
    text("No bolso: $" +
      String.format("%.2f", this.tile.mundo_ref.player.dinheiros_no_bolso),
      x_carteira, y_carteira, largura_carteira, altura_carteira
    );

  }

  public void construir_torre() {
    if(this.tile.mundo_ref.player.dinheiros_no_bolso >= Torre.custo_construir) {
      this.tile.set_torre();
      this.tile.mundo_ref.player.dinheiros_no_bolso -= Torre.custo_construir;
    } else {
      this.deve_fechar = false;
    }
  }

  public void construir_mina(Minerio minerio) {
    if(this.tile.mundo_ref.player.dinheiros_no_bolso >= Mina.custo_construir*minerio.valor) {
      this.tile.set_mina(minerio);
      this.tile.mundo_ref.player.dinheiros_no_bolso -= Mina.custo_construir*minerio.valor;
    } else {
      this.deve_fechar = false;
    }
  }

  private void popup_mina(Mina mina) {
    String texto_nivel = "Nivel atual: " + (mina.nivel+1); // +1, comeca em 0
    String texto_acumulado = "Dinheiros acumulado: $" +
      String.format("%.2f", mina.valor_acumulado);

    String texto_minerando = "Minerando: " + (mina.minerio) +
      ". Valor do minério: $" + String.format("%.2f", mina.minerio.valor);

    texto_nivel += "   Custo para melhorar: $" +
      String.format("%.2f", mina.custo_melhoramento());
    String texto_qualidade = "Melhorar qualidade de mineração. Atual: " +
      ((int)(mina.qualidade_mineracao*100)) + "%";
    
    pushMatrix();
    float x_texto = (width / 7);
    float y_texto_1 = (height / 3.5);
    float y_texto_2 = (height / 3.5) + (height / 16);
    float y_texto_3 = (height / 3.5) + 2*(height / 16);
    textAlign(LEFT);
    noFill();
    
    text(texto_nivel, x_texto, y_texto_1, width, 40);
    // rect(x_texto, y_texto_1, width, 40);
    
    text(texto_acumulado, x_texto, y_texto_2, width, 40);
    text(texto_minerando, x_texto, y_texto_3, width, 40);
    
    
    textAlign(CENTER, CENTER);
    popMatrix();
    
    pushMatrix();
    this.translate_off = (height/12);
    translate(0, this.translate_off);
    if(this.desenhar_btn_generico(3, texto_qualidade)) {
      this.melhorar_mina(mina);
    }
    
    if(this.desenhar_btn_generico(4, "Coletar dinheiros")) {
      this.coletar_da_mina(mina);
    }
    this.translate_off = 0.0;
    popMatrix();
  }


  public void melhorar_mina(Mina mina) {
    this.deve_fechar = false;
    if(this.tile.mundo_ref.player.dinheiros_no_bolso < mina.custo_melhoramento()) {
      return;
    }
    // Primeiro remove dinheiro pra depois att mine, senão vai remover outro valor
    this.tile.mundo_ref.player.dinheiros_no_bolso -= mina.custo_melhoramento();
    mina.melhorar_qualidade();
  }


  public void coletar_da_mina(Mina mina) {
    this.tile.mundo_ref.player.dinheiros_no_bolso += mina.valor_acumulado;
    mina.valor_acumulado = 0;
  }


  private void popup_torre(Torre torre) {

    String texto_nivel = "Nivel atual: " + (torre.nivel+1); // +1, comeca em 0
    String texto_custo = "Custo para melhorar: $" +
      String.format("%.2f", torre.custo_melhoramento());

    String texto_cadencia = "Melhorar cadência. Atual: " +
      String.format("%.2f", torre.cadencia) + "%";

    String texto_alcance = "Melhorar alcance. Atual: " +
      String.format("%.2f", torre.alcance) + "%";

    pushMatrix();
    float x_texto = (width / 7);
    float y_texto_1 = (height / 3.5);
    float y_texto_2 = (height / 3.5) + (height / 16);
    textAlign(LEFT);
    noFill();

    text(texto_nivel, x_texto, y_texto_1, width, 40);
    // rect(x_texto, y_texto_1, width, 40);

    text(texto_custo, x_texto, y_texto_2, width, 40);
    // rect(x_texto, y_texto_2, width, 40);


    textAlign(CENTER, CENTER);
    popMatrix();

    pushMatrix();
    this.translate_off = (height/12);
    translate(0, this.translate_off);
    if(this.desenhar_btn_generico(3, texto_cadencia)) {
      this.melhorar_torre(torre, true, false);
    }

    if(this.desenhar_btn_generico(4, texto_alcance)) {
      this.melhorar_torre(torre, false, true);
    }
    this.translate_off = 0.0;
    popMatrix();

  }

  public void melhorar_torre(Torre torre, Boolean melhorar_cadencia, Boolean melhorar_alcance) {
    this.deve_fechar = false;

    if(this.tile.mundo_ref.player.dinheiros_no_bolso < torre.custo_melhoramento()) {
      return;
    }
    // Primeiro remove dinheiro pra depois att torre, senão o dinheiro removido
    // será o do próximo upgrade (que não faz sentido)
    if(melhorar_cadencia) {
      this.tile.mundo_ref.player.dinheiros_no_bolso -= torre.custo_melhoramento();
      torre.melhorar_cadencia();
    }
    if(melhorar_alcance) {
      this.tile.mundo_ref.player.dinheiros_no_bolso -= torre.custo_melhoramento();
      torre.melhorar_alcance();
    }

  }


  private void popup_base(Base base) {

    float largura_cofre = width/3;
    float altura_cofre = width/18;
    float x_cofre = (largura_cofre-altura_cofre)/2 + largura_cofre + altura_cofre;
    float y_cofre = height/8;
    noFill();
    rect(x_cofre, y_cofre, largura_cofre, altura_cofre);
    textAlign(CENTER, CENTER);
    text("No cofre: $" +
      String.format("%.2f",this.tile.mundo_ref.base.valor_acumulado),
      x_cofre, y_cofre, largura_cofre, altura_cofre
    );


    float qtd = 100;
    float qtd2 = 1000;
    
    
    if(this.desenhar_btn_generico(2, "Botar $" + String.format("%.2f", qtd) + " no bolso")) {
      this.mover_dinheiro_cofre_bolso(qtd);
    }

    if(this.desenhar_btn_generico(3, "Botar $" + String.format("%.2f", qtd) + " no cofre")) {
      this.mover_dinheiro_bolso_cofre(qtd);
    }
    
    if(this.desenhar_btn_generico(4, "Botar $" + String.format("%.2f", qtd2) + " no bolso")) {
      this.mover_dinheiro_cofre_bolso(qtd2);
    }
    
    if(this.desenhar_btn_generico(5, "Botar $" + String.format("%.2f", qtd2) + " no cofre")) {
      this.mover_dinheiro_bolso_cofre(qtd2);
    }
    
  }

  public void mover_dinheiro_cofre_bolso(Float qtd) {

    double dinheiro_no_bolso = this.tile.mundo_ref.player.dinheiros_no_bolso;
    double dinheiro_no_cofre = this.tile.mundo_ref.base.valor_acumulado;

    if(dinheiro_no_cofre < qtd) {
      dinheiro_no_bolso += dinheiro_no_cofre;
      dinheiro_no_cofre = 0;
    } else {
      dinheiro_no_cofre -= qtd;
      dinheiro_no_bolso += qtd;
    }

    this.tile.mundo_ref.player.dinheiros_no_bolso = dinheiro_no_bolso;
    this.tile.mundo_ref.base.valor_acumulado = dinheiro_no_cofre;
    this.deve_fechar = false;
  }

  public void mover_dinheiro_bolso_cofre(Float qtd) {

    double dinheiro_no_bolso = this.tile.mundo_ref.player.dinheiros_no_bolso;
    double dinheiro_no_cofre = this.tile.mundo_ref.base.valor_acumulado;

    if(dinheiro_no_bolso < qtd) {
      dinheiro_no_cofre += dinheiro_no_bolso;
      dinheiro_no_bolso = 0;
    } else {
      dinheiro_no_bolso -= qtd;
      dinheiro_no_cofre += qtd;
    }
    
    this.tile.mundo_ref.player.dinheiros_no_bolso = dinheiro_no_bolso;
    this.tile.mundo_ref.base.valor_acumulado = dinheiro_no_cofre;
    this.deve_fechar = false;
  }
}

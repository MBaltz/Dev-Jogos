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

  private float translate_off;

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
      this.desenhar_menu_nova_estrutura();
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
    this.translate_off = 2 * (width/12);
    pushMatrix();
    translate(0, this.translate_off);
    this.desenhar_btns();
    popMatrix();
  }


  private void desenhar_btn_fechar() {
    float tamanho = width / 16;
    float pos_x = width - tamanho - (width / 32);
    float pos_y = tamanho;

    line(pos_x, pos_y, pos_x + tamanho, pos_y + tamanho);
    line(pos_x + tamanho, pos_y, pos_x, pos_y + tamanho);
    rect(pos_x, pos_y, tamanho, tamanho);

    if(Entrada.clicado()) {
      if(!(Entrada.clique_x > pos_x && Entrada.clique_x < pos_x + tamanho)) { return; }
      if(!(Entrada.clique_y > pos_y && Entrada.clique_y < pos_y + tamanho)) { return; }

      Entrada.limpar_clique();
      this.deve_fechar = true;
    }
  }


  private void desenhar_btns() {
    this.desenhar_btn_mina_torre(this.idx_torre, null,
      "Construir torre" +
      ": $" + String.format("%.2f", Mina.custo_construir)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_1, this.tile.minerio_1,
      "Construir mina de " + this.tile.minerio_1 +
      ": $" + String.format("%.2f", Mina.custo_construir)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_2, this.tile.minerio_2,
      "Construir mina de " + this.tile.minerio_2 +
      ": $" + String.format("%.2f", Mina.custo_construir)
    );
    this.desenhar_btn_mina_torre(this.idx_minerio_3, this.tile.minerio_3,
      "Construir mina de " + this.tile.minerio_3 +
      ": $" + String.format("%.2f", Mina.custo_construir)
    );
  }

  private void desenhar_btn_generico(int idx, String texto_btn, Method fn, Object[] param) {
    float tamanho_x = width - 2*(width / 8);
    float tamanho_y = height / 8;
    float pos_x = (width / 8);
    float pos_y = (idx * this.separacao_btn) * tamanho_y;

    rect(pos_x, pos_y, tamanho_x, tamanho_y);
    text(texto_btn, pos_x, pos_y, tamanho_x, tamanho_y);

    if(Entrada.clicado()) {
      float mx = Entrada.clique_x;
      float my = Entrada.clique_y - this.translate_off;

      // se não clicou no botao nem faz nada
      if(!(mx > pos_x && mx < pos_x + tamanho_x)) { return; }
      if(!(my > pos_y && my < pos_y + tamanho_y)) { return; }
      this.deve_fechar = true; // a menos que alguma função diga o contrario

      //executar a função passada
      try {
        if(param.length == 0) {
          fn.invoke(this);
        } else  {
          fn.invoke(this, param);
        }
      } catch(Exception ex) {ex.printStackTrace();}

      Entrada.limpar_clique();
    }

  }

  private void desenhar_btn_mina_torre(int idx, Minerio minerio, String texto_btn) {
    // o botao sendo clicado, vamo ver qual ação que faz
    try {
      if(minerio != null) {
        this.desenhar_btn_generico(idx, texto_btn,
          this.getClass().getMethod("construir_mina",
          new Class<?>[] {Minerio.class}), new Object[] {minerio}
        );
      } else {
        this.desenhar_btn_generico(idx, texto_btn,
          this.getClass().getMethod("construir_torre",
          new Class<?>[] {}), new Object[] {}
        );
      }
    } catch(Exception ex) {ex.printStackTrace();}
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
    if(this.tile.mundo_ref.player.dinheiros_no_bolso >= Mina.custo_construir) {
      this.tile.set_mina(minerio);
      this.tile.mundo_ref.player.dinheiros_no_bolso -= Mina.custo_construir;
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

    try {


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


      Method metodo = this.getClass().getMethod("melhorar_mina", new Class<?>[] {Mina.class});
      this.desenhar_btn_generico(3, texto_qualidade, metodo, new Object[] {mina});

      metodo = this.getClass().getMethod("coletar_da_mina", new Class<?>[] {Mina.class});
      this.desenhar_btn_generico(4, "Coletar dinheiros", metodo, new Object[] {mina});

    } catch(Exception ex) { ex.printStackTrace(); }
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

    try {

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


      Method metodo = this.getClass().getMethod("melhorar_torre",
        new Class<?>[] {Torre.class, Boolean.class, Boolean.class});

      this.desenhar_btn_generico(3, texto_cadencia, metodo, new Object[] {torre, true, false});
      this.desenhar_btn_generico(4, texto_alcance, metodo, new Object[] {torre, false, true});
    } catch(Exception ex) { ex.printStackTrace(); }
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

    try {

      // o fluxo é cofre -> bolso
      // então se a quantidade for negativa, na verdade é bolso -> cofre

      float qtd = 100;
      this.desenhar_btn_generico(2, "Botar $" + String.format("%.2f", qtd) +
        " no bolso", this.getClass().getMethod("mover_dinheiro",
        new Class<?>[] {Float.class}), new Object[] {qtd}
      );
      this.desenhar_btn_generico(3, "Botar $" + String.format("%.2f", qtd) +
        " no cofre", this.getClass().getMethod("mover_dinheiro",
        new Class<?>[] {Float.class}), new Object[] {-qtd}
      );
      qtd = 1000;
      this.desenhar_btn_generico(4, "Botar $" + String.format("%.2f", qtd) +
        " no bolso", this.getClass().getMethod("mover_dinheiro",
        new Class<?>[] {Float.class}), new Object[] {qtd}
      );
      this.desenhar_btn_generico(5, "Botar $" + String.format("%.2f", qtd) +
        " no cofre", this.getClass().getMethod("mover_dinheiro",
        new Class<?>[] {Float.class}), new Object[] {-qtd}
      );
    } catch(Exception ex) {ex.printStackTrace();}

  }

  public void mover_dinheiro(Float qtd) {

    if (this.tile.mundo_ref.base.valor_acumulado >= qtd) {
      this.tile.mundo_ref.player.dinheiros_no_bolso += qtd;
      this.tile.mundo_ref.base.valor_acumulado -= qtd;

      if(this.tile.mundo_ref.player.dinheiros_no_bolso <= 0) {
        this.tile.mundo_ref.player.dinheiros_no_bolso = 0;
      }
      if(this.tile.mundo_ref.base.valor_acumulado <= 0) {
        this.tile.mundo_ref.base.valor_acumulado = 0;
      }
    }
    this.deve_fechar = false;
  }
}

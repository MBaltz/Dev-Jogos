//evitar ao maximo usar valores absolutos
//como essa classe é uma exceção, algumas exceções podem ser feitas

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
    
    if(this.tile.estrutura == null) {
      this.desenhar_menu_nova_estrutura();
    } else {
      //TODO: popups de cada estrutura
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
    this.desenhar_btn_generico(this.idx_torre, null, "Construir torre");
    this.desenhar_btn_generico(this.idx_minerio_1, this.tile.minerio_1, "Construir mina 1");
    this.desenhar_btn_generico(this.idx_minerio_2, this.tile.minerio_2, "Construir mina 2");
    this.desenhar_btn_generico(this.idx_minerio_3, this.tile.minerio_3, "Construir mina 3");
  }


  private void desenhar_btn_generico(int idx, Minerio minerio, String texto_btn) {
    float tamanho_x = width - 2*(width / 8);
    float tamanho_y = width / 12;
    float pos_x = (width / 8);
    float pos_y = (idx * this.separacao_btn) * tamanho_y;
    
    rect(pos_x, pos_y, tamanho_x, tamanho_y);
    text(texto_btn, pos_x, pos_y, tamanho_x, tamanho_y);
     
    if(Entrada.clicado()) {
      float mx = Entrada.clique_x;
      float my = Entrada.clique_y - this.translate_off;
     
      if(!(mx > pos_x && mx < pos_x + tamanho_x)) { return; }
      if(!(my > pos_y && my < pos_y + tamanho_y)) { return; }

      if(minerio == null) {
        this.construir_torre();
      } else {
        this.construir_mina(minerio);
      }
      
      Entrada.limpar_clique();
      this.deve_fechar = true;
    }
  }

  public boolean pediu_pra_fechar() {
    return this.deve_fechar;
  }

  private void construir_torre() {
    //TODO: subtrair custo do player
    this.tile.set_torre();
  }
  
  private void construir_mina(Minerio minerio) {
    //TODO: subtrair custo do player
    //TODO: criar a mina
  }
}

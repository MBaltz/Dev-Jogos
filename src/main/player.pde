class Player {

  float x_local, y_local;
  float tamanho = 20;
  float velocidade = 120;

  
  PImage seta_img;
  float seta_largura_img;
  float seta_altura_img;
  float seta_margens;
  float seta_y_off;
  float seta_esq_x;
  float seta_dir_x;
  float seta_esq_x_real;

  Mundo mundo_ref;

  public Player(Mundo mundo_ref) {

    this.mundo_ref = mundo_ref;
    
    this.x_local = Tile.tamanho / 2;
    this.y_local = height / 2 + 70 - this.tamanho / 2;


    final String PPATH="assets/texturas/";
    final String FN="seta.png";

    this.seta_img = loadImage(PPATH+FN);
    this.seta_largura_img = width / 8;
    this.seta_altura_img = height / 8;
    this.seta_margens = width / 16;
    this.seta_y_off = height / 2 + height / 4;
    this.seta_esq_x = -3 * this.seta_margens;
    this.seta_dir_x = width - this.seta_largura_img - this.seta_margens;
    this.seta_esq_x_real = -this.seta_esq_x - this.seta_largura_img;
  }

  public void atualizar(float dt, float tamanho_x_mapa) {

    if(mousePressed == true) {
      float x = mouseX;
      float y = mouseY;

      //checa se clicou na seta esquerda
      if(x >= this.seta_esq_x_real
         && x <= this.seta_esq_x_real + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img
         && this.x_local > -tamanho_x_mapa/2) {
        this.x_local -= this.velocidade * dt;
      }

      //checa se clicou na seta direita
      if (x >= this.seta_dir_x
         && x <= this.seta_dir_x + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img
         && this.x_local < tamanho_x_mapa/2) {
        this.x_local += this.velocidade * dt;
      }
    }

  }
}

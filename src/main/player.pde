class Player {

  float x, y;
  float tamanho = 20;
  PImage seta_img;
  float seta_largura_img;
  float seta_altura_img;
  float seta_margens;
  float seta_y_off;
  float seta_esq_x;
  float seta_dir_x;
  float seta_esq_x_real;

  public Player() {
    this.x = Tile.tamanho / 2;
    this.y = height / 2 + 70 - this.tamanho / 2;


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

  public void atualizar(float dt) {

    if(mousePressed == true) {
      float x = mouseX;
      float y = mouseY;

      //checa se clicou na seta esquerda
      if(x >= this.seta_esq_x_real
         && x <= this.seta_esq_x_real + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img) {
        this.x -= 5;
      }

      //checa se clicou na seta direita
      if (x >= this.seta_dir_x
         && x <= this.seta_dir_x + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img) {
        this.x += 5;
      }
    }

  }
}

class Player {

  float x_local, y_local;
  float velocidade = 135;
  int direcao = 1;


  float seta_largura_img;
  float seta_altura_img;
  float seta_margens;
  float seta_y;
  float seta_esq_x;
  float seta_dir_x;
  float seta_esq_x_real;

  Mundo mundo_ref;
  double dinheiros_no_bolso;

  public Player(Mundo mundo_ref) {

    this.mundo_ref = mundo_ref;

    this.x_local = Tile.tamanho / 2;
    this.y_local = height / 2 + 70 - (Tile.tamanho/2);

    this.dinheiros_no_bolso = 999999; // mt por agora

    this.seta_largura_img = width / 8;
    this.seta_altura_img = height / 8;
    this.seta_margens = width / 16;
    this.seta_y = height / 2 + height / 4;
    this.seta_esq_x = -3 * this.seta_margens;
    this.seta_dir_x = width - this.seta_largura_img - this.seta_margens;
    this.seta_esq_x_real = -this.seta_esq_x - this.seta_largura_img;
  }

  public void atualizar(float dt, float tamanho_x_mapa) {

    if(keyPressed) {
      if(keyCode == LEFT && this.x_local > -tamanho_x_mapa/2){
        this.x_local -= this.velocidade * dt;
        this.direcao = -1;
      }

      if(keyCode == RIGHT && this.x_local < tamanho_x_mapa/2){
        this.x_local += this.velocidade * dt;
        this.direcao = 1;
      }

    }

    if(mousePressed == true) {
      float x = mouseX;
      float y = mouseY;

      //checa se clicou na seta esquerda
      if(x >= this.seta_esq_x_real
         && x <= this.seta_esq_x_real + this.seta_largura_img
         && y >= this.seta_y
         && y < this.seta_y + this.seta_altura_img
         && this.x_local > -tamanho_x_mapa/2) {
        this.x_local -= this.velocidade * dt;
        this.direcao = -1;
      }

      //checa se clicou na seta direita
      if (x >= this.seta_dir_x
         && x <= this.seta_dir_x + this.seta_largura_img
         && y >= this.seta_y
         && y < this.seta_y + this.seta_altura_img
         && this.x_local < tamanho_x_mapa/2) {
        this.x_local += this.velocidade * dt;
        this.direcao = 1;
      }
    }

  }
}

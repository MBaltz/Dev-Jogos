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

  float alvo_x;


  boolean mouse_pressed;

  public Player() {
    this.x = Tile.tamanho / 2;
    this.y = height / 2 + 70 - this.tamanho / 2;

    this.alvo_x = this.x;
    
    this.seta_img = loadImage("../assets/seta.png");
 
    this.seta_largura_img = width / 8;
    this.seta_altura_img = height / 8;
    this.seta_margens = width / 16;
    this.seta_y_off = height / 2 + height / 4;


    this.seta_esq_x = -3 * this.seta_margens;
    this.seta_dir_x = width - this.seta_largura_img - this.seta_margens;
    this.seta_esq_x_real = -this.seta_esq_x - this.seta_largura_img;

    this.mouse_pressed = false;
  }
  
  public void atualizar(float dt) {

    if(this.mouse_pressed == true) {
      //checa se clicou na seta esquerda
      float x = mouseX;
      float y = mouseY;
      if(x >= this.seta_esq_x_real
         && x <= this.seta_esq_x_real + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img) {
        this.x -= 5;
        return;
      }

      //checa se clicou na seta direita
      if(x >= this.seta_dir_x
         && x <= this.seta_dir_x + this.seta_largura_img
         && y >= this.seta_y_off
         && y < this.seta_y_off + this.seta_altura_img) {
        this.x += 5;
        return;
      }
    
    }
       
  }

  public void desenhar(float camera_x) {

    this.desenhar_setas();
    noFill();
    stroke(255, 0, 0);
    ellipse(this.x - camera_x, this.y, this.tamanho, this.tamanho);

    
    this.mouse_pressed = mousePressed;
  }

  private void desenhar_setas() {

    pushMatrix(); // tudo entre isso e o popmatrix vai ser descartado
    scale(-1, 1); // pra rodar a imagem em 180º no x
    image(this.seta_img, this.seta_esq_x, this.seta_y_off, this.seta_largura_img, this.seta_altura_img); //desenha a imagem
    popMatrix(); // descarta o scale e mas a seta fica renderizada
    
    image(this.seta_img, this.seta_dir_x, this.seta_y_off, this.seta_largura_img, this.seta_altura_img);
  }


  public void clicar(float x, float y) {

   
    
  }

}

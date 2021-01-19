class Tile {
  static final float tamanho = 40; // tamanho em pixel do quadrado (provisorio)
  int x; //posição do tile a respeito do mundo
  float r, g, b; // cores provisorias
  Estrutura estrutura;

  public Tile(int x) {
    this.x = x;
    this.r = random(0, 255);
    this.g = random(0, 255);
    this.b = random(0, 255);
    this.estrutura = null;
  }


  //TODO: add metodo de add estrutura
  
  public void desenhar(float camera_x) {
    float x  = this.x * this.tamanho - camera_x;
    float y =  height/2 + 70;
    if((x + this.tamanho < 0 || x > width) || (y + this.tamanho < 0 || y > height)) { return; }
    
    //println("tile " + this.x + " desenhada");
    //codigo provisorio pra desenhar o chão
    fill(this.r, this.g, this.b);
    strokeWeight(0);
    rect(this.x * this.tamanho - camera_x, height/2 + 70, this.tamanho, this.tamanho);
    noFill();

    // se não tem estrutura aqui, não desenha ela
    if(this.estrutura != null) {
      this.estrutura.desenhar(camera_x);
    }
    
  }
  
}

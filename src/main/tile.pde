// Quadradinho/Tijolo do jogo (voxel 2d)
class Tile {
  static final float tamanho = 40; // tamanho em pixel do quadrado (provisorio)
  int num_tile; //posição do tile a respeito do mundo
  float r, g, b; // cores provisorias
  Estrutura estrutura;

  float x, y;

  public Tile(int i) {
    this.num_tile = i; // Posição x
    this.estrutura = null; // Caso a tile esteja ocupada
    this.r = random(0, 255);
    this.g = random(0, 255);
    this.b = random(0, 255);
    
    this.y =  height/2 + 70; // tamanho em pixel do quadrado (provisorio)
  }


  public Base set_base() {
    Base b = new Base();
    this.add_estrutura(b);
    return b;
  }


  public void add_estrutura(Estrutura e) {
    this.estrutura = e;
  }

  public void desenhar(float camera_x) {
    this.x  = this.num_tile * this.tamanho - camera_x; // Calcula posição do tile no eixo x


    if((this.x + this.tamanho < 0 || this.x > width) || (this.y + this.tamanho < 0 || this.y > height)) { return; }

    // println("tile " + this.x + " desenhada");
    //codigo provisorio pra desenhar o chão
    fill(this.r, this.g, this.b);
    strokeWeight(0);
    rect(this.x, this.y, this.tamanho, this.tamanho);
    noFill();

    // se não tem estrutura aqui, não desenha ela
    if(this.estrutura != null) {
      // Lugar daquela estrutura
      this.estrutura.x_off = this.x;
      this.estrutura.y_off = this.y;
      this.estrutura.desenhar(camera_x);
    }

  }

  public void clicar(float x, float y) {} //TODO

}

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
}

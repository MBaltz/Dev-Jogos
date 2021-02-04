// Quadradinho/Tijolo do jogo (voxel 2d)
class Tile {
  static final float tamanho = 40; // tamanho em pixel do quadrado (provisorio)
  int num_tile; //posição do tile a respeito do mundo
  float r, g, b; // cores provisorias
  Estrutura estrutura;

  //Variaveis separadas ao inves de um array, pra fixar ser 3
  public final Minerio minerio_1;
  public final Minerio minerio_2;
  public final Minerio minerio_3;

  float x, y;

  private Popup popup;

  public Tile(int i) {
    this.num_tile = i; // Posição x
    this.estrutura = null; // Caso a tile esteja ocupada
    this.r = random(0, 255);
    this.g = random(0, 255);
    this.b = random(0, 255);

    ArrayList<Minerio> minerios = new ArrayList();

    while(minerios.size() != 3) {
      Minerio possibilidade = Minerio.escolher_minerio();
      if(!minerios.contains(possibilidade)) {
        minerios.add(possibilidade);
      }
    }

    this.minerio_1 = minerios.get(0);
    this.minerio_2 = minerios.get(1);
    this.minerio_3 = minerios.get(2);

    this.y =  height/2 + 70; // tamanho em pixel do quadrado (provisorio)

    this.popup = null;
  }


  public Base set_base() {
    Base b = new Base();
    this.add_estrutura(b);
    return b;
  }

  public void add_estrutura(Estrutura e) {
    this.estrutura = e;
  }

  @Override 
  public String toString() {
    String ret = "{Tile: " + this.num_tile;
    ret += ", estrutura: " + (this.estrutura != null ? this.estrutura.tipo.toString() : "nenhuma");
    ret += ", minerio_1: " + this.minerio_1.toString();
    ret += ", minerio_2: " + this.minerio_2.toString();
    ret += ", minerio_3: " + this.minerio_3.toString();
    ret += " }\n";
    return ret;
  }

  public void atualizar(float dt) {

    if(Entrada.instancia().clicado()) {

      float clique_x = Entrada.instancia().clique_x;
      float clique_y = Entrada.instancia().clique_y;

      if(clique_x > this.x && clique_x < this.x + Tile.tamanho && clique_y > this.y && clique_y < this.y + Tile.tamanho) {
        Entrada.instancia().limpar_clique();
        this.popup = new Popup(this);
      }
    }
  }


  public boolean em_popup() {
    return this.popup != null;
  }

  public void desenhar_popup() {}


}

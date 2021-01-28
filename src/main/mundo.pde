// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;

  public Mundo(int num_tiles) {
    this.player   = new Player();
    this.inimigos = new ArrayList<Inimigo>();
    this.tiles    = new ArrayList<Tile>();

    // Tiles:      0=base
    // [-3, -2, -1, (0), 1, 2, 3, 4]
    for(int i = -num_tiles/2; i < num_tiles/2; i++) {
      if(i == 0) {
        Tile t = new Tile(i);
        this.base = t.set_base(); // Cria a base no meio dos tiles
        this.tiles.add(t);
      } else {
        this.tiles.add(new Tile(i));
      }
    }

  }

  public void atualizar() {}
  public void desenhar(float camera_x) {

    //desenha o piso
    for (int i = 0; i < this.tiles.size(); i++) {
      this.tiles.get(i).desenhar(camera_x);
    }


  }
}

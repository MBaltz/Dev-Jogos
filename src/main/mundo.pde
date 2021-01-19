class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;

  public Mundo(int num_tiles) {
    this.base     = new Base();
    this.player   = new Player();
    this.inimigos = new ArrayList<Inimigo>();
    this.tiles    = new ArrayList<Tile>();


    for(int i = 0; i < num_tiles; i++) {
      this.tiles.add(new Tile(i));
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

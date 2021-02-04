// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Torre> torres;
  ArrayList<Projetil> projeteis;

  public Mundo(int num_tiles) {
    this.player   = new Player();
    this.inimigos = new ArrayList<Inimigo>();
    this.tiles    = new ArrayList<Tile>();
    this.torres    = new ArrayList<Torre>();
    this.projeteis    = new ArrayList<Projetil>();


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


    // pra test
    Inimigo i1 = new Inimigo(-190);
    this.inimigos.add(i1);
    Torre t1 = new Torre(-50);
    this.torres.add(t1);


  }

  public void atualizar(float dt) {
    this.player.atualizar(dt);

    for(Inimigo i : inimigos) {
      if(!i.morto) {
        i.atualizar(dt, torres);
      }
    }

    for(Torre t : torres) {
      if(!t.morreu) {
        t.atualizar(dt, inimigos, projeteis);
      }
    }

    for(Projetil p : projeteis) {
      if(p.ativo) {
        p.atualizar(dt);
      }
    }
  }


}

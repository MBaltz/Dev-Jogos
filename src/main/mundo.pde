// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Torre> torres;
  ArrayList<Projetil> projeteis;
  float tamanho_x_mapa; // Tamanho do mundo no eixo x

  public Mundo(int num_tiles) {
    this.player   = new Player();
    this.inimigos = new ArrayList<Inimigo>();
    this.tiles    = new ArrayList<Tile>();
    this.torres    = new ArrayList<Torre>();
    this.projeteis    = new ArrayList<Projetil>();
    this.tamanho_x_mapa = num_tiles*Tile.tamanho; // p/ calcular borda do mapa


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
    Inimigo i2 = new Inimigo(40);
    this.inimigos.add(i2);
    // Cria torre centralizada
    Torre t1 = new Torre(Tile.tamanho*-2+Tile.tamanho/2-12.5);
    this.torres.add(t1);
    // Sumindo do mapa test
    Projetil p = new Projetil(0, 200, 100, 200);
    this.projeteis.add(p);
  }

  public void atualizar(float dt) {

    for(Tile t : this.tiles) {
      t.atualizar(dt);
    }

    this.player.atualizar(dt, tamanho_x_mapa);

    for(Inimigo i : inimigos) {
      if(!i.morto) {
        i.atualizar(dt, torres);
      }
    }

    //TODO: mover essa atualização pra atualização de estrutura do tile
    for(Torre t : torres) {
      if(!t.morreu) {
        t.atualizar(dt, inimigos, projeteis);
      }
    }

    for(Projetil p : projeteis) {
      if(p.ativo) {
        p.atualizar(dt, inimigos, tamanho_x_mapa);
      }
    }
  }


}

// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Projetil> projeteis;
  float tamanho_x_mapa; // Tamanho do mundo no eixo x

  float spawn_time = 0;
  int num_spawns = 0;
  

  public Mundo(int num_tiles) {
    this.player   = new Player(this); // o player toma conhecimento do mundo
    this.inimigos = new ArrayList<Inimigo>();
    this.tiles    = new ArrayList<Tile>();
    this.projeteis    = new ArrayList<Projetil>();
    this.tamanho_x_mapa = num_tiles*Tile.tamanho; // p/ calcular borda do mapa


    // Tiles:      0=base
    // [-3, -2, -1, (0), 1, 2, 3, 4]
    for(int i = -num_tiles/2; i < num_tiles/2; i++) {
      Tile t = new Tile(i, this);
      
      if(i == 0) {
        this.base = t.set_base(); // Cria a base no meio dos tiles
      }

      int pos_torres = 3;
      if (i == -pos_torres || i == pos_torres) { // duas torres de gratis
        t.set_torre(); // a torre toma conhecimento do mundo
      }

      int pos_minas = 2;
      if (i == -pos_minas || i == pos_minas) { // duas minas de gratis
        t.set_mina(Minerio.PEDRA);
      }
      this.tiles.add(t);
    }
  }


  
  public void atualizar(float dt) {

    this.spawn_time += dt;

    for(Tile t : this.tiles) {
      t.atualizar(dt);
    }

    this.player.atualizar(dt, tamanho_x_mapa);

    for(Inimigo i : inimigos) {
      if(!i.morto) {
        i.atualizar(dt);
      }
    }

    for(Projetil p : projeteis) {
      if(p.ativo) {
        p.atualizar(dt, inimigos, tamanho_x_mapa);
      }
    }

    this.spawn();
  }

  private void spawn() {

    //lembrando q spawn_time é em segundos
    if(this.spawn_time > 2.5) {
      this.spawn_time = 0;
      this.num_spawns++;
      this.inimigos.add(new Inimigo(this, 400));
    }
  }

  
}

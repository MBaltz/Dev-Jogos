// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Torre> torres; // TODO: tentar tirar daqui
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
      Tile t = new Tile(i);
      
      if(i == 0) {
        this.base = t.set_base(); // Cria a base no meio dos tiles
      }

      int pos_torres = 3;
      if (i == -pos_torres || i == pos_torres) { // duas torres de gratis
        this.torres.add(t.set_torre(this.projeteis, this.inimigos));
      }

      this.tiles.add(t);
    }


    float inimigo_pos = 350;
    for(int i = 0; i < 10; i++) {
      this.inimigos.add(new Inimigo(-inimigo_pos));
      this.inimigos.add(new Inimigo(inimigo_pos));
      inimigo_pos += 40;
    }

  }


  
  public void atualizar(float dt) {

    for(Tile t : this.tiles) {
      Estrutura estrutura_destruida = t.atualizar(dt);

      if(estrutura_destruida != null) {
        //se foi removida a estrutura de tile, então nao deve existir outra referencia, ent garbage collector trabalha
        if(estrutura_destruida.tipo == Tipo_Estrutura.TORRE) { this.torres.remove((Torre) estrutura_destruida); }
      }
      
    }

    this.player.atualizar(dt, tamanho_x_mapa);

    for(Inimigo i : inimigos) {
      if(!i.morto) {
        i.atualizar(dt, torres);
      }
    }

    for(Projetil p : projeteis) {
      if(p.ativo) {
        p.atualizar(dt, inimigos, tamanho_x_mapa);
      }
    }
  }


}

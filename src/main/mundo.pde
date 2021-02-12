// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Projetil> projeteis;
  float tamanho_x_mapa; // Tamanho do mundo no eixo x

  float segundos_em_um_dia;
  float segundos_dia_atual;
  int dia;
  int num_ini_ultima_orda;


  public Mundo(int num_tiles) {
                        // o player toma conhecimento do mundo
    this.player         = new Player(this);
    this.inimigos       = new ArrayList<Inimigo>();
    this.tiles          = new ArrayList<Tile>();
    this.projeteis      = new ArrayList<Projetil>();

    // para calcular borda do mapa
    this.tamanho_x_mapa = num_tiles*Tile.tamanho;

    this.dia = 0;
    this.segundos_em_um_dia = 30;
    this.segundos_dia_atual = 0;
    this.num_ini_ultima_orda = 3;

    // Tiles:      0=base
    // [-3, -2, -1, (0), 1, 2, 3, 4]
    for(int i = -num_tiles/2; i < num_tiles/2; i++) {
      Tile t = new Tile(i, this);

      if(i == 0) {
        this.base = t.set_base(); // Cria a base no meio dos tiles
      }

      int pos_torres = 3;
      if (i == -pos_torres || i == pos_torres) { // duas torres de grátis
        t.set_torre(); // a torre toma conhecimento do mundo
      }

      int pos_minas = 2;
      if (i == -pos_minas || i == pos_minas) { // duas minas de grátis
        t.set_mina(Minerio.PEDRA);
      }
      this.tiles.add(t);
    }
  }



  public void atualizar(float dt) {

    for(Tile t : this.tiles) {
      t.atualizar(dt);
    }

    this.player.atualizar(dt, this.tamanho_x_mapa);

    for(Inimigo i : this.inimigos) {
      if(!i.morto) {
        i.atualizar(dt);
      }
    }

    for(Projetil p : this.projeteis) {
      if(p.ativo) {
        p.atualizar(dt, this.inimigos, this.tamanho_x_mapa);
      }
    }

    if(this.segundos_dia_atual >= this.segundos_em_um_dia) {
      this.dia += 1; // Oto lindo e ensolarado dia
      this.segundos_em_um_dia += 1; // O dia fica mais longo 1 segundos
      this.segundos_dia_atual = 0; // Amanhece de novo
      if(this.dia % 2 == 1) { // Spawna inimigo se o dia for ímpar
        this.num_ini_ultima_orda = prox_primo(num_ini_ultima_orda);
        this.spawn(num_ini_ultima_orda); // Spawna um num primo de inimigos
        println("Novo dia!! dia: " + this.dia + ", num_ini: " + this.num_ini_ultima_orda);
      } else {
        println("Novo dia!! dia: " + this.dia + ", num_ini: Sem inimigos hoje :,]");
      }
    } else {
      this.segundos_dia_atual += dt;
    }
  }

  private void spawn(int quant_ini) {
    int espaco_inimigos = 60; // Distância entre um inimigo e o próximo
    int quant_ini_esq = 0; // Para spawnar sem usar tempo
    int quant_ini_dir = 0; // Spawna todos de uma vez, com dst. entre um e outro
    for(int i = 0; i < quant_ini; i++) {
      if(random(1) > 0.485) { // Probabilidade de spawnar na direita
        // Spawna inimigo na direita
        this.inimigos.add(new Inimigo(this,
          (this.tamanho_x_mapa/2)+(quant_ini_dir*espaco_inimigos))
        );
        quant_ini_dir += 1;
      } else {
        // Spawna inimigo na esquerda
        this.inimigos.add(new Inimigo(this,
          -(this.tamanho_x_mapa/2)-(quant_ini_esq*espaco_inimigos))
        );
        quant_ini_esq += 1;
      }
    }
  }

  // Pega o próximo primo a partir de um número
  private int prox_primo(int n) {
    for(int i = n+1; i < 9999999; i+=1) { // +=1, quando k == 2 entra no break
      for(int k = 2; k < int(sqrt(i))+1; k++)
        if(i%k == 0) break;
        else if(k == int(sqrt(i))) return i;// Retorna primo
    }
    return 9999999; // Se o player chegar nesse momento, meus parabéns, viu!
  }

}

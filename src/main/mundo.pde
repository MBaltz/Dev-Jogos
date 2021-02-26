// Mundo: Praticamente ess eé o jogo
// (contém todas as tiles, a base, o player, inimigo, ...)
class Mundo {

  Base base;
  Player player;
  ArrayList<Inimigo> inimigos;
  ArrayList<Tile> tiles;
  ArrayList<Projetil> projeteis;
  float seg_limpar_arrays;
  float dt_somador_limpar_arrays;

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

    this.seg_limpar_arrays = 5.0;
    this.dt_somador_limpar_arrays = 0.0;

    // para calcular borda do mapa
    this.tamanho_x_mapa = num_tiles*Tile.tamanho;

    this.dia = 0;
    this.segundos_em_um_dia = 20;
    this.segundos_dia_atual = 0;
    this.num_ini_ultima_orda = 3;

    int pos_torre = 3; // Posição da torre gratuita que será gerada
    if(random(1) > 0.5) {pos_torre *= -1;}
    int pos_mina = 2;
    if(random(1) > 0.5) {pos_mina *= -1;}

    // Tiles:      0=base
    // [-3, -2, -1, (0), 1, 2, 3, 4]
    for(int i = -num_tiles/2; i < num_tiles/2; i++) {
      Tile t = new Tile(i, this);

      if(i == 0) {
        this.base = t.set_base(); // Cria a base no meio dos tiles
      }

      // Cria uma torre (escolha de lado é aleatória)
      if (i == pos_torre) { // torre de gratis
        t.set_torre(); // a torre toma conhecimento do mundo
      }
      
      // Cria uma torre (escolha de lado é aleatória)
      if (i == pos_mina) { // torre de gratis
        t.set_mina(Minerio.PEDRA); // a torre toma conhecimento do mundo
      }

      this.tiles.add(t);
    }
  }



  public void atualizar(float dt) {

    // Se chegou a hora de lipar arrays, limpa então :D
    if(this.dt_somador_limpar_arrays > this.seg_limpar_arrays) {
      this.limpar_arrays();
      this.dt_somador_limpar_arrays = 0;
    }
    dt_somador_limpar_arrays += dt;

    for(Tile t : this.tiles) {
      t.atualizar(dt);
    }

    this.player.atualizar(dt, this.tamanho_x_mapa);

    for(Inimigo i : this.inimigos) {
      if(i.decomposicao > 0) {
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
      this.segundos_em_um_dia += 3; // O dia fica mais longo x segundos
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
    int espaco_inimigos = (int) (Tile.tamanho * 1.2); // Distância entre um inimigo e o próximo
    int quant_ini_esq = 0; // Para spawnar sem usar tempo
    int quant_ini_dir = 0; // Spawna todos de uma vez, com dst. entre um e outro
    for(int i = 0; i < quant_ini; i++) {
      if(random(1) > 0.51) { // Probabilidade de spawnar na direita
        // Spawna inimigo na direita
        this.inimigos.add(new Inimigo(this,
          (this.tamanho_x_mapa/2)+(quant_ini_dir*espaco_inimigos))
        );
        quant_ini_dir += 1;
      } else {
        // Spawna inimigo na esquerda
        this.inimigos.add(new Inimigo(this,
          -(this.tamanho_x_mapa/2)-(quant_ini_esq*espaco_inimigos)-Tile.tamanho)
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


  // Limpa arrays (remove elementos que não serão mais utilizados)
  public void limpar_arrays() {
    // Remove Estruturas decompostas
    for(int i = this.tiles.size()-1; i >= 0; i--) { // Começa de trás pra frente
      if(this.tiles.get(i).estrutura != null && this.tiles.get(i).estrutura.decomposicao <= 0) {
        this.tiles.get(i).estrutura = null;
      }
    }
    // Remove Inimigos decompostos
    for(int i = this.inimigos.size()-1; i >= 0; i--) { // Começa de trás pra frente
      if(this.inimigos.get(i).decomposicao <= 0) {
        inimigos.remove(i);
      }
    }
    // Remove Projéteis já usados
    for(int i = this.projeteis.size()-1; i >= 0; i--) { // Começa de trás pra frente
      if(!this.projeteis.get(i).ativo) {
        projeteis.remove(i);
      }
    }
  }


}

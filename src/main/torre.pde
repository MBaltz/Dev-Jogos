class Torre extends Estrutura {

  float vida, cadencia, alcance, dt_soma_cadencia;
  int nivel; // Níveis de desenvolvimento da torre
  // Quando a torre morre, ela não precisa necessariamente sumir de vez
  int idx_tile;
  ArrayList<Projetil> projeteis;
  ArrayList<Inimigo> inimigos;

  public Torre(float x_off_inicial, Mundo mundo_ref) {
    this.tipo = Tipo_Estrutura.TORRE;

    this.projeteis = mundo_ref.projeteis;
    this.inimigos = mundo_ref.inimigos;

    this.idx_tile = (int) x_off_inicial;
    this.x_off  = x_off_inicial * Tile.tamanho;
    this.y_off = height/2 + 20;
    this.vida = 50;
    this.cadencia = 1; // x disparos por segundo
    this.dt_soma_cadencia = 0; // Auxiliador na realização da cadência
    this.nivel = 0;
    this.alcance = 250; // Alcance de inimigos em pixels
  }

  public void melhorar_cadencia() { this.cadencia += 0.1; this.nivel++; }
  public void melhorar_alcance() { this.alcance += 5; this.nivel++; }
  public float custo_melhoramento() {  return pow(2, this.nivel) * 100; }

  public void atualizar(float dt) {
    // Atualiza a torre de acordo com os inimigos por perto
    // E também acaba afetando os projéteis, já que a torre pode atirar num inimigo
    this.dt_soma_cadencia += dt;
    if(this.dt_soma_cadencia >= 1/this.cadencia) { // Cadência de disparo
      this.dt_soma_cadencia = 0; // Reseta somador
      // Inicializa a variável de inimigo mais próximo da torre
      Inimigo ini_mais_perto = new Inimigo(null, 0); ini_mais_perto.morto = true;
      float dist_ini_perto = 9999999; // Lááá longe
      // Pega o inimigo mais perto da torre
      for(Inimigo i : this.inimigos) {
        float dist_i = abs(this.x_off - i.x);
        if(!i.morto && dist_i <= this.alcance && dist_i < dist_ini_perto) {
          ini_mais_perto = i;
          dist_ini_perto = dist_i;
        }
      }
      // Só atira se tiver algum inimigo próximo da torre
      if(!ini_mais_perto.morto) {
        // Torre atira no inimigo mais perto
        Projetil p = new Projetil(this.x_off + Tile.tamanho/2, this.y_off, ini_mais_perto.x + Tile.tamanho/2, ini_mais_perto.y);
        this.projeteis.add(p); // Mete bala no bicho
      }
    }
    if(this.morreu && this.decomposicao > 0) {
      this.decomposicao -= 0.062;
    }
  }

  // O inimigo que dá dano na torre
  public void levar_dano(float dano) {
    this.vida -= dano;
    if(this.vida <= 0) {
      this.morreu = true;
    }
  }

}

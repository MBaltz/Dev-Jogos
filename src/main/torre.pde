class Torre extends Estrutura {

  float vida, cadencia, alcance, dt_soma_cadencia;
  int nivel; // Níveis de desenvolvimento da torre
  // Quando a torre morre, ela não precisa necessariamente sumir de vez
  boolean morreu = false;

  public Torre(float x_off_inicial) {
    this.tipo = Tipo_Estrutura.TORRE;

    this.x_off = x_off_inicial;
    this.y_off = height/2 + 20;
    this.vida = 50;
    this.cadencia = 1; // x disparos por segundo
    this.dt_soma_cadencia = 0; // Auxiliador na realização da cadência
    this.nivel = 0;
    this.alcance = 100; // Alcance de inimigos em pixels
  }

  // Overload (Não da pra usar o método da classe abstrata nesse caso)
  public void atualizar(float dt) {}

  // Atualiza a torre de acordo com os inimigos por perto
  // E também acaba afetando os projéteis, já que a torre pode atirar num inimigo
  public void atualizar(float dt, ArrayList<Inimigo> inimigos, ArrayList<Projetil> projeteis) {
    this.dt_soma_cadencia += dt;
    if(this.dt_soma_cadencia >= 1/this.cadencia) { // Cadência de disparo
      this.dt_soma_cadencia = 0; // Reseta somador
      // Inicializa a variável de inimigo mais próximo da torre
      Inimigo ini_mais_perto = new Inimigo(0); ini_mais_perto.morto = true;
      float dist_ini_perto = 9999999; // Lááá longe
      // Pega o inimigo mais perto da torre
      for(Inimigo i : inimigos) {
        float dist_i = abs(this.x_off - i.x);
        if(!i.morto && dist_i <= this.alcance && dist_i < dist_ini_perto) {
          ini_mais_perto = i;
          dist_ini_perto = dist_i;
        }
      }
      // Só atira se tiver algum inimigo próximo da torre
      if(!ini_mais_perto.morto) {
        // Torre atira no inimigo mais perto
        Projetil p = new Projetil(this.x_off, this.y_off, ini_mais_perto.x, ini_mais_perto.y);
        projeteis.add(p); // Mete bala no bicho
      }
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

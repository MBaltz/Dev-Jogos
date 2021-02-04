class Torre extends Estrutura {

  float vida, cadencia, alcance;
  int nivel; // Níveis de desenvolvimento da torre
  // Quando a torre morre, ela não precisa necessariamente sumir de vez
  boolean morreu = false;

  public Torre(float x_off_inicial) {
    this.tipo = Tipo_Estrutura.TORRE;

    this.x_off = x_off_inicial;
    this.y_off = height/2 + 20;
    this.vida = 50;
    this.cadencia = 1; // TODO: Pensar em como usar a cadência
    this.nivel = 0;
    this.alcance = 100; // Alcance de inimigos em pixels
  }

  // Overload (Não da pra usar o método da classe abstrata nesse caso)
  public void atualizar(float dt) {}
  // TODO: O correto seria pegar o inimigo mais próximo: ler proximos comments
  //  Atualmente, a torre está atirando em N inimigos (basta estar na sua
  //  área de alcance). E isso tem que ser resolvido da seguinte forma:
  //  Pegar o inimigo mais próximo daquela torre, e atirar apenas nele.
  //  Se quiser, eu faço isso. ass Baltz →««««ø»»»»←

  // Atualiza a torre de acordo com os inimigos por perto
  // E também acaba afetando os projéteis, já que a torre pode atirar num inimigo
  public void atualizar(float dt, ArrayList<Inimigo> inimigos, ArrayList<Projetil> projeteis) {
    for(Inimigo i : inimigos) {
      // Se o inimigo tiver proximo da torre
      if(!i.morto && abs(this.x_off - i.x) <= this.alcance) {
        // Torre atira no inimigo
        Projetil p = new Projetil(this.x_off, this.y_off, i.x, i.y*1.036);
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

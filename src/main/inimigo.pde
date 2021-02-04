class Inimigo {

  float x, y, vida, velocidade, dano;
  // Quando o inimigo está atacando, ele está parado e dando dano
  boolean atacando;
  boolean morto; // Ele não precisa necessariamente sumir do nada

  public Inimigo(float x_inicial) {
    this.x = x_inicial;
    this.y = height/2 + 50; // Provisório

    this.vida = 12.5;
    this.dano = 0.75;
    this.velocidade = 9;
    this.atacando = false;
    this.morto = false;
  }


  // Utiliza as torres para verificar se está na hora de atacar
  public void atualizar(float dt, ArrayList<Torre> torres) {
    this.deve_atacar(torres);
    if(!this.atacando || !this.morto) { // Caso ele possa andar
      float passo = dt * this.velocidade;
      if(this.x > 0) {passo *= -1;} // base em x=0, inimigo pode vim de + ou - x
      this.x += passo; // Aprocima o inimigo do centro do mundo (base)
    }
  }

  // Ação do inimigo ao chegar perto de uma torre (atacar)
  private void deve_atacar(ArrayList<Torre> torres) {
    this.atacando = false; // Caso a torre esteja derrubada, ele volte ao normal
    for(Torre t : torres) {
      // Se chegou perto d+ de alguma torre viva
      // TODO: Esse valor de distância tem que ser metada da largura de um tile
      if(!t.morreu && abs(this.x - t.x_off) <= 21) {
        this.atacando = true; // Para ficar paradinho enquanto ataca
        t.levar_dano(this.dano); // Dá o dano na torre t
      }
    }
  }

}


//

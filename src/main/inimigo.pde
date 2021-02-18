class Inimigo {

  float x, y, vida, velocidade, dano;
  // Quando o inimigo está atacando, ele está parado e dando dano
  boolean atacando;
  boolean morto; // Ele não precisa necessariamente sumir do nada

  Mundo mundo_ref;

  public Inimigo(Mundo mundo_ref, float x_inicial) {

    this.mundo_ref = mundo_ref;
    
    this.x = x_inicial;
    this.y = height / 2 + 70 - (Tile.tamanho/2);
    this.vida = 5;
    this.dano = 0.55;
    this.velocidade = 10.5;
    this.atacando = false;
    this.morto = false;
  }


  // Utiliza as torres para verificar se está na hora de atacar
  public void atualizar(float dt) {
    this.deve_atacar();
    if(!this.atacando && !this.morto) { // Caso ele possa andar
      float passo = dt * this.velocidade;
      if(this.x > 0) {passo *= -1;} // base em x=0, inimigo pode vim de + ou - x
      this.x += passo; // Aprocima o inimigo do centro do mundo (base)
    }
  }


  // Ação do inimigo ao chegar perto de uma torre (atacar)
  private void deve_atacar() {
    this.atacando = false; // Caso a torre esteja derrubada, ele volte ao normal
    for(Tile tile : this.mundo_ref.tiles) {
      Estrutura estrutura = tile.estrutura;
      if(estrutura == null || estrutura.tipo != Tipo_Estrutura.TORRE) { continue; }
      Torre t = (Torre) estrutura;
      // Se chegou perto d+ de alguma torre viva
      if(!t.morreu && abs(this.x - t.x_off) <= Tile.tamanho/2) {
        this.atacando = true; // Para ficar paradinho enquanto ataca
        t.levar_dano(this.dano); // Dá o dano na torre t
      }
    }
  }

  // TODO: Torre também tem esse método, cabe uma classe abstrata CoisaVida??
  // O inimigo que dá dano na torre
  public void levar_dano(float dano) {
    this.vida -= dano;
    if(this.vida <= 0) {
      this.morto = true;
    }
  }


}


//

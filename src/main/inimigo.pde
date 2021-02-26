class Inimigo {

  float x, y, vida, velocidade, dano, decomposicao, cadencia_ataque, dt_soma_cadencia, vida_max;
  // Quando o inimigo está atacando, ele está parado e dando dano
  boolean atacando;
  boolean morto; // Ele não precisa necessariamente sumir do nada

  Mundo mundo_ref;

  public Inimigo(Mundo mundo_ref, float x_inicial) {

    this.mundo_ref = mundo_ref;

    this.x = x_inicial;
    this.y = height / 2 + 70 - (Tile.tamanho/2);
    this.vida = 8;
    this.vida_max = 8;
    this.dano = 1;
    this.cadencia_ataque = 2; // 1seg/cadencia
    this.dt_soma_cadencia = 0;
    this.velocidade = 17.0;
    this.atacando = false;
    this.morto = false;
    this.decomposicao = 1.0; // Para ir sumindo aos poucos (* alpha)
  }


  // Utiliza as torres para verificar se está na hora de atacar
  public void atualizar(float dt) {
    this.dt_soma_cadencia += dt;
    if(this.dt_soma_cadencia >= 1/this.cadencia_ataque) {
      this.deve_atacar(); // Verifica se deve atacar ou parar de atacar
      this.dt_soma_cadencia -= 1/this.cadencia_ataque; // Diminui somados
    }
    if(!this.atacando && !this.morto) { // Caso ele possa andar
      float passo = dt * this.velocidade;
      if(this.x > 0) {passo *= -1;} // base em x=0, inimigo pode vim de + ou - x
      this.x += passo; // Aprocima o inimigo do centro do mundo (base)
    } else if(this.morto && this.decomposicao > 0) {
      this.decomposicao -= 0.065; // Vai sumindo
    }
  }


  // Ação do inimigo ao chegar perto de uma torre (atacar)
  private void deve_atacar() {
    this.atacando = false; // Caso a torre esteja derrubada, ele volte ao normal
    
    // atacando a base
    if(abs(this.x) < Tile.tamanho / 4) {
      println("atacando base");
      //TODO: escolher valor melhor pro dano da base

      float escala_dinheiro_vida = 10;
      
      double vida_do_cofre = this.mundo_ref.base.valor_acumulado / escala_dinheiro_vida;
      vida_do_cofre -= this.dano;
      if(vida_do_cofre < 0) {
        this.mundo_ref.base.morreu = true;
      }

      this.mundo_ref.base.valor_acumulado = vida_do_cofre * escala_dinheiro_vida;
      return; // se atacou a base, não precisa atacar mais nada em volta
    }
    
    for(Tile tile : this.mundo_ref.tiles) {
      Estrutura estrutura = tile.estrutura;
      if(estrutura == null || estrutura.tipo != Tipo_Estrutura.TORRE) { continue; }
      Torre t = (Torre) estrutura;
      // Se chegou perto d+ de alguma torre viva
      if(!t.morreu && abs(this.x - t.x) <= Tile.tamanho/2) {
        this.atacando = true; // Para ficar paradinho enquanto ataca
        t.levar_dano(this.dano); // Dá o dano na torre t
      }
    }
  }

  // O inimigo que dá dano na torre
  public void levar_dano(float dano) {
    this.vida -= dano;
    if(this.vida <= 0) {
      this.morto = true;
    }
  }


}


//

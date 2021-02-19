
/*
Classe que representa qualquer tipo de projétil disparado por qualquer
entidade no jogo (seja inimigo ou torre de defesa)

Como entrada par ao construtor, tem-se a posição de partida do projétil e
a posição do alvo.
*/
class Projetil {
  boolean ativo;
  float x, y, angulo, velocidade, dano;
  // Para otimizar o processo remoção do vetor
  int tamanho;

  public Projetil(float inicio_x, float inicio_y, float alvo_x, float alvo_y) {
    // Posição do projétil
    this.x = inicio_x;
    this.y = inicio_y;
    this.velocidade = 95.0;
    this.dano = 1.5;

    // Cálculo do ângulo que o projétil irá seguir
    // EVIDENCIAR QUE É (Y, X), E NÃO (X, Y)!!!!!!
    this.angulo = atan2(alvo_y-inicio_y, alvo_x-inicio_x);

    // Tamanho do traço/elipse
    this.tamanho = 16;

    // Esse atributo é para realizar indicar que o dado projétil já
    // está inválido e pode ser apagado
    this.ativo = true;
  }

  public void atualizar(float dt, ArrayList<Inimigo> inimigos, float tamanho_x_mapa) {
    acertou_inimigo(inimigos); // Ao acertar, this.ativo = false
    if(this.ativo) {
      this.x = this.x + cos(this.angulo) * this.velocidade * dt;
      this.y = this.y + sin(this.angulo) * this.velocidade * dt;
      // Se bater nas bordas do mapa ou chão, ele desativa o projétil
      if(this.y > height/2+70+this.tamanho || this.y < 0) {
        this.ativo = false;
      } else if (this.x < -tamanho_x_mapa/2 || this.x > tamanho_x_mapa/2) {
        this.ativo = false;
      }
    }
  }


  // Calcula se o projétil acertou algum inimigo
  private void acertou_inimigo(ArrayList<Inimigo> inimigos) {
    for(Inimigo i : inimigos) {
      if(!i.morto) {
        // O motivo por ser '- Tile.tamanho/2' é um enigma
        if(abs(this.x - i.x - Tile.tamanho/2) < Tile.tamanho/4) {
          i.levar_dano(this.dano);
          this.ativo = false; // Descarta projétil
        }
      }
    }
  }


}

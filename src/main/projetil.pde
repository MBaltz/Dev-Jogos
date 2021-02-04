
/*
Classe que representa qualquer tipo de projétil disparado por qualquer
entidade no jogo (seja inimigo ou torre de defesa)

Como entrada par ao construtor, tem-se a posição de partida do projétil e
a posição do alvo.
*/
class Projetil {

  // TODO: pensar e implementar varredura de vetores (para n remover a todo momento)
  // Desse modo, no Mundo, pode-se implementar uma verificação para
  // varredura de coisas desativadas a cada tantos frames.
  // if(frameRate%150) {mundo.varrer()}
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
    acertou_inimigo(inimigos);
    if(this.ativo) {
      this.x = this.x + cos(this.angulo) * this.velocidade * dt;
      this.y = this.y + sin(this.angulo) * this.velocidade * dt;
      // Se bater nas bordas do mapa ou chão, ele desativa o projetil
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

      // TODO: O impacto do projétil tem que ser calculado do centro do ini.
      //    e não da quina (0, 0). (resolver isso colocando os tamanhos dos
      //    objetos diretamente nas suas classes. ex: ini.tamanho_x)
      //    Isso deve ser feito pra praticamente tudo que se mova ou interaja
      //    (inimigo, torre, projetil, player, base)
      //    Assim resolve também  problema de identificar o quão longe o clique
      //    da pessoa naquele objeto, está, pois da pra calcular o "centro de
      //    massa" daquele objeto.

      if(!i.morto && abs(this.x - i.x) < 5) {
        i.levar_dano(this.dano);
        this.ativo = false; // Projétil discartado
      }
    }
  }


}


/*

Classe que representa qualquer tipo de projétil disparado por qualquer
entidade no jogo (seja inimigo ou torre de defesa)

Como entrada par ao construtor, tem-se a posição de partida do projétil e
a posição do alvo.

Forma de uso:
Projetil p = new Projetil(mouseX+camera_x, mouseY, alvo_x+camera_x, alvo_y);

*/
class Projetil {

  // TODO: pensar e implementar varredura de vetores (para n remover a todo momento)
  // Desse modo, no Mundo, pode-se implementar uma verificação para
  // varredura de coisas desativadas a cada tantos frames.
  // if(frameRate%150) {mundo.varrer()}
  boolean ativo;

  float x, y, angulo, velocidade;
  // Para otimizar o processo remoção do vetor
  int tamanho;

  public Projetil(float inicio_x, float inicio_y, float alvo_x, float alvo_y) {
    // Posição do projétil
    this.x = inicio_x;
    this.y = inicio_y;
    this.velocidade = 1.0;

    // Cálculo do ângulo que o projétil irá seguir
    // EVIDENCIAR QUE É (Y, X), E NÃO (X, Y)!!!!!!
    this.angulo = atan2(alvo_y-inicio_y, alvo_x-inicio_x);

    // Tamanho do traço/elipse
    this.tamanho = 20;

    // Esse atributo é para realizar indicar que o dado projétil já
    // está inválido e pode ser apagado
    this.ativo = true;
  }

  public void atualizar() {
    this.x = this.x + cos(this.angulo) * this.velocidade;
    this.y = this.y + sin(this.angulo) * this.velocidade;
    // Se bater na borda superior ou inferior, ele desativa o projetil
    if(this.y > height/2+70+this.tamanho || this.y < 0) {
      this.ativo = false;
    }
    // TODO: Fazer verificação de quando o projétil sai do mapa pelas laterais
    // else if (this.x < -limite_x/2 || this.x > limite_x/2) {
    //   this.ativo = false;
    // }

  }
}

class Mina extends Estrutura {

  float vida;
  int nivel;
  int idx_tile;

  Minerio minerio;
  double valor_acumulado;

  public Mina(float x_off_inicial, Minerio minerio) {
    this.tipo = Tipo_Estrutura.MINA;

    this.minerio = minerio;
    this.idx_tile = (int) x_off_inicial;
    this.x_off  = x_off_inicial * Tile.tamanho;
    this.y_off = height/2 + 20;
    this.vida = 50;
    this.nivel = 0;
    this.valor_acumulado = 0;
  }

  public void atualizar(float dt) {}
}

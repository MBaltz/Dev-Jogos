class Mina extends Estrutura {

  float vida;
  int nivel;
  int idx_tile;

  Minerio minerio;
  double valor_acumulado;
  float qualidade_mineracao;
  float dt_acumulado = 0;

  public Mina(float x_off_inicial, Minerio minerio) {
    this.tipo = Tipo_Estrutura.MINA;

    this.minerio = minerio;
    this.idx_tile = (int) x_off_inicial;
    this.x_off  = x_off_inicial * Tile.tamanho;
    this.y_off = height/2 + 20;
    this.vida = 50;
    this.nivel = 0;
    this.valor_acumulado = 0;
    this.qualidade_mineracao = 0.1;
    this.dt_acumulado = 0;
  }

  public void atualizar(float dt) {
    this.dt_acumulado += dt;
    // se passou 1 segundo, coleta qualidade_mineracao% do valor do que está sendo minerado
    if(this.dt_acumulado > 1) {
      this.dt_acumulado = 0;
      this.valor_acumulado += this.qualidade_mineracao * this.minerio.valor;
    }
  }

  public void melhorar_qualidade() {
    this.qualidade_mineracao += 0.1;
    this.nivel++;
  }

  public float custo_melhoramento() {
    return pow(2, this.nivel) * 100;
  }
  
}

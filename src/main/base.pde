class Base extends Estrutura {

  public double valor_acumulado;
  boolean morreu;

  public Base() {
    this.tipo = Tipo_Estrutura.BASE;
    this.morreu = false;
  }

  public void atualizar(float dt) {}
  
}

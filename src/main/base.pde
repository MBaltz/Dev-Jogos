class Base extends Estrutura {
  public void atualizar() {}
  public void desenhar(float camera_x) {

    fill(180, 170, 170);
    strokeWeight(0);
    rect(this.x_off, this.y_off, 50, 50);
    noFill();
  }
}

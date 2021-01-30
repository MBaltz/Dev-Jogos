class Base extends Estrutura {

  public void atualizar() {}
  public void desenhar(float camera_x) {


    //provisorio
    fill(180, 170, 170);
    strokeWeight(0);
    float tamanho = 50;
    rect(this.x_off + Tile.tamanho / 4, this.y_off - tamanho, Tile.tamanho/2, tamanho);
    noFill();
  }
}

class Desenhador {
  float camera_x;
  Mundo mundo_clone;

  float seta_x1, seta_x2, seta_y, seta_largura, seta_altura;

  private boolean tem_popup;

  public void desenhar(Mundo mundo, Camera camera_obj) {

    this.camera_x = camera_obj.get_pos();
    // TODO:
    // a ideia é que mundo clone seja objeto-copia de mundo, e não uma
    // referência, assim pode mandar pra outra thread sem problemas mas já que
    // não tem como mandar pra outras thread, pelo menos o acesso pela thread
    // de atualizar não fica concorrido com essa de desenho, já que ficam dois
    // objetos distintos na memória (mas isso pode causar um problema de
    // memória, por isso vamo ficando com a referência do mesmo número por agora)
    this.mundo_clone = mundo;
    this.tem_popup = false;

    this.desenhar_mundo(this.mundo_clone);
  }

  public boolean tem_popup() {
    return this.tem_popup;
  }

  private void desenhar_mundo(Mundo mundo) {
    this.desenhar_background();
    textSize(26);
    this.desenhar_carteira(mundo.player);
    this.desenhar_dia();

    // Desenha o piso, sabendo se o tile tá com um popup aberto
    for (Tile tile : mundo.tiles) {
      if (this.desenhar_tile(tile)) { // retorna se alguem ta em popup, não precisa nem renderizar nenhuma outra tile
        this.tem_popup = true; //pra poder avisar a entrada
        return;
      }
    }

    // Tudo bem ter desenhado as tiles, são só elas mesmo
    // Desenha os inimigos
    // Acaba copiando o arraylist (para evitar problema com a thread)
    ArrayList<Inimigo> copia_inimigos = new ArrayList<Inimigo>(mundo.inimigos);
    for (Inimigo i : copia_inimigos) {
      // Se não estiver morto e estiver dentro do cenário, desenha
      if (!i.morto
        && (i.x > -this.mundo_clone.tamanho_x_mapa/2-Tile.tamanho
        && i.x < this.mundo_clone.tamanho_x_mapa/2)
        ) {
        this.desenhar_inimigo(i);
      }
      // TODO: Se o inimigo morrer, fazer ele não sumir do nada
    }

    // Desenha os Projeteis
    // Acaba copiando o arraylist (para evitar problema com a thread)
    ArrayList<Projetil> copia_projeteis = new ArrayList<Projetil>(mundo.projeteis);
    for (Projetil p : copia_projeteis) {
      if (p.ativo) {
        this.desenhar_projetil(p);
      }
    }

    //desenha o player
    this.desenhar_player(mundo.player);
  }

  private void desenhar_background() {
    //TODO: usar o tempo do dia pra escolher o background, fazer um lerp entre eles?


    //tint(255, 127);
    PImage textura = TextureLoader.textura_bg_sol(this.mundo_clone.segundos_dia_atual, this.mundo_clone.segundos_em_um_dia);
    textura.resize(0, (int) (height/2.0 + 70.0));
    image(textura, 0 - this.camera_x - width/2, 0);

    textura = TextureLoader.textura_bg(this.mundo_clone.segundos_dia_atual, this.mundo_clone.segundos_em_um_dia);
    textura.resize(0, (int) (height/2.0 + 70.0));
    int desenho = 1;
    while (true) {
      float nx = (desenho * textura.width);
      image(textura, nx - this.camera_x - width/2, 0);
      image(textura, -nx - this.camera_x - width/2, 0);
      desenho++;
      if (nx > this.mundo_clone.tamanho_x_mapa/2 || -nx < this.mundo_clone.tamanho_x_mapa/2) {
        break;
      }
    }

    //tint(255, 255);
  }

  private boolean desenhar_tile(Tile tile) {

    if (tile.em_popup()) {
      background(0);
      tile.desenhar_popup(); // como aqui é uma coisa a parte, acho que tudo bem isso ficar lá
      return true; //precisa nem olhar a estrutura
    }

    float tile_x  = tile.x - this.camera_x; // Calcula posição do tile no eixo x
    tile.x_com_camera  = tile.x - this.camera_x; // Calcula posição do tile no eixo x

    if ((tile_x + tile.tamanho < 0 || tile_x > width)
      || (tile.y + tile.tamanho < 0 || tile.y > height)) {
      return false; // retorna dizendo que nao tem popup
    }


    image(TextureLoader.textura_tile(), tile_x, tile.y, Tile.tamanho, Tile.tamanho);

    // se não tem estrutura aqui, não desenha ela
    if (tile.estrutura != null) {
      this.desenhar_estrutura(tile.estrutura, tile_x, tile.y);
    }
    return false; //não tem popup
  }

  private void desenhar_inimigo(Inimigo inimigo) {
    float inimigo_x = inimigo.x - this.camera_x;
    float inimigo_y = inimigo.y - (Tile.tamanho/2);
    image(TextureLoader.textura_inimigo(), inimigo_x, inimigo_y, Tile.tamanho, Tile.tamanho);
  }

  private void desenhar_player(Player player) {
    //TODO: verificar se tá na tela

    this.desenhar_setas_player(player);

    float player_x = player.x_local - this.camera_x - (Tile.tamanho/2);
    float player_y = player.y_local - (Tile.tamanho/2);
    image(TextureLoader.textura_player(), player_x, player_y, Tile.tamanho, Tile.tamanho);
  }

  private void desenhar_carteira(Player player) {
    pushMatrix();
    translate(width/2, height/2);
    float largura_carteira = width / 6.3;
    float altura_carteira = width / 27;
    float x_carteira = -largura_carteira/2;
    float y_carteira = height/5;
    noFill();
    rect(x_carteira, y_carteira, largura_carteira, altura_carteira);
    textAlign(CENTER, CENTER);
    text("No bolso: $" + String.format("%.2f", player.dinheiros_no_bolso),
      x_carteira, y_carteira, largura_carteira, altura_carteira
      );
    popMatrix();
  }

  // Mostra na tela o dia que se passa  naquele momento
  private void desenhar_dia() {
    pushMatrix();
    translate(width/2, height/2);
    float largura_carteira = width / 10;
    float altura_carteira = width / 27;
    float x_carteira = -largura_carteira/2;
    float y_carteira = -height/4;
    //noFill();
    fill(0);
    rect(x_carteira, y_carteira, largura_carteira, altura_carteira);
    textAlign(CENTER, CENTER);
    fill(255);
    text("DIA: " + this.mundo_clone.dia,
      x_carteira, y_carteira, largura_carteira, altura_carteira
      );
    popMatrix();
  }

  private void desenhar_setas_player(Player player) {
    pushMatrix(); // tudo entre isso e o popmatrix vai ser descartado
    scale(-1, 1); // pra rodar a imagem em 180º no x
    //desenha a imagem
    image(TextureLoader.textura_seta_player(), player.seta_esq_x, player.seta_y_off,
      player.seta_largura_img, player.seta_altura_img
      );
    popMatrix(); // descarta o scale mas a seta já desenhada fica renderizada
    image(TextureLoader.textura_seta_player(), player.seta_dir_x, player.seta_y_off,
      player.seta_largura_img, player.seta_altura_img
      );

    this.seta_largura = player.seta_largura_img;
    this.seta_altura = player.seta_altura_img;

    this.seta_y = player.seta_y_off;

    this.seta_x1 = player.seta_esq_x + 2* this.seta_largura;
    this.seta_x2 = player.seta_dir_x;
  }

  public boolean mouse_na_regiao_controles() {
    boolean retorno = false;
    float x = mouseX;
    float y = mouseY;

    // x e y estão na seta da esqueda de controle de movimento do player?
    retorno |= (x > this.seta_x1 && x < this.seta_x1 + this.seta_largura)
      && (y > this.seta_y && y < this.seta_y + this.seta_altura);

    // x e y estão na seta da direita de controle de movimento do player?
    retorno |= (x > this.seta_x2 && x < this.seta_x2 + this.seta_largura)
      && (y > this.seta_y && y < this.seta_y + this.seta_altura);

    return retorno;
  }

  private boolean desenhar_estrutura(Estrutura estrutura, float x, float y) {
    //TODO: verificar se ta dentro da tela (mesmo que a tile já tenha feito isso?)

    if (estrutura.tipo == Tipo_Estrutura.BASE) {
      return this.desenhar_base((Base) estrutura, x, y);
    }
    if (estrutura.tipo == Tipo_Estrutura.MINA) {
      return this.desenhar_mina((Mina) estrutura, x, y);
    }
    if (estrutura.tipo == Tipo_Estrutura.TORRE) {
      return this.desenhar_torre((Torre) estrutura, x, y);
    }
    return true;
  }

  private boolean desenhar_base(Base base, float x, float y) {
    // Estruturas tem 2 tiles de altura
    image(TextureLoader.textura_base(), x, y - 2*Tile.tamanho, Tile.tamanho, 2*Tile.tamanho);
    return false;
  }

  private boolean desenhar_mina(Mina mina, float x, float y) {
    if (mina.morreu) {
      return false;
    }

    image(TextureLoader.textura_mina(mina.nivel), x, y - 2*Tile.tamanho, Tile.tamanho, 2*Tile.tamanho);
    return false;
  }

  private boolean desenhar_torre(Torre torre, float x, float y) {

    if (torre.morreu) {
      return false;
    }

    image(TextureLoader.textura_torre(torre.nivel), x, y - 2*Tile.tamanho, Tile.tamanho, 2*Tile.tamanho);
    return false;
  }

  private void desenhar_projetil(Projetil projetil) {
    stroke(0, 0, 255);
    fill(255, 185, 200);
    float ponta_x = projetil.x - projetil.tamanho * cos(projetil.angulo);
    float ponta_y = projetil.y - projetil.tamanho * sin(projetil.angulo);
    // line(projetil.x - this.camera_x, projetil.y, ponta_x - this.camera_x, ponta_y);
    ellipse(projetil.x - this.camera_x, projetil.y, 4, 4);
  }
}



//

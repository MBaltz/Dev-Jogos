class Desenhador {
  float camera_x;
  Mundo mundo_clone;

  float seta_x1, seta_x2, seta_y, seta_largura, seta_altura;

  private boolean tem_popup;

  public void desenhar(Mundo mundo_clone, Camera camera_obj) {

    this.camera_x = camera_obj.get_pos();
    this.mundo_clone = mundo_clone;
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
      if(i.decomposicao > 0
        && (i.x > -this.mundo_clone.tamanho_x_mapa/2-Tile.tamanho
        && i.x < this.mundo_clone.tamanho_x_mapa/2)
        ) {
        this.desenhar_inimigo(i);
      }
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
      // faz com que desenhe um background fora dos limites do mapa, pra caso o backgroud seja pequeno não fique uma area de fora
      if (nx > this.mundo_clone.tamanho_x_mapa/2 || nx < -(this.mundo_clone.tamanho_x_mapa/2 + textura.width)) {
        break;
      }
    }
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
    tint(255, 255*inimigo.decomposicao);
    image(TextureLoader.textura_inimigo(), inimigo_x, inimigo_y, Tile.tamanho, Tile.tamanho);
    tint(255, 255);

    // desenhando barrinha de vida
    pushMatrix();
    strokeWeight(1);
    fill(255, 0, 0);
    rect(inimigo_x, inimigo_y - (Tile.tamanho / 9), Tile.tamanho * (inimigo.vida / inimigo.vida_max), Tile.tamanho / 9);
    popMatrix();


    
  }

  private void desenhar_player(Player player) {
    // O player é desenhado mesmo quando não está na tela
    //  (é só um objeto, então não tem problema)
    //  (Talvez seja até melhor não verificar)

    this.desenhar_setas_player(player);

    float player_x = player.x_local - this.camera_x - (Tile.tamanho/2);
    float player_y = player.y_local - (Tile.tamanho/2);

    // Baseado na direção que ele anda, reflete no eixo y


    PImage textura;
    
    if(player.andando) {
      textura = TextureLoader.textura_player_andando();
    } else {
      textura = TextureLoader.textura_player_parado();
    }
    
    pushMatrix();
    // se a direção for -1, tudo a respeito do x é invertido, então pra ir um tile pra direita, se tem q substrair um tile
    scale(player.direcao, 1);
    image(textura, (player.direcao * player_x) + (player.direcao == -1 ? -Tile.tamanho : 0), player_y, Tile.tamanho, Tile.tamanho);
    popMatrix();

  }

  private void desenhar_carteira(Player player) {
    pushMatrix();
    translate(width/2, height/2);
    float largura_carteira = width / 6.3;
    float altura_carteira = width / 27;
    float x_carteira = -largura_carteira/2;
    float y_carteira = height/3.2;
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
    float y_carteira = height/5.5;
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
    image(TextureLoader.textura_seta_player(), player.seta_esq_x, player.seta_y,
      player.seta_largura_img, player.seta_altura_img
      );
    popMatrix(); // descarta o scale mas a seta já desenhada fica renderizada
    image(TextureLoader.textura_seta_player(), player.seta_dir_x, player.seta_y,
      player.seta_largura_img, player.seta_altura_img
      );

    this.seta_largura = player.seta_largura_img;
    this.seta_altura = player.seta_altura_img;

    this.seta_y = player.seta_y;

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

    if (torre.decomposicao <= 0) {
      return false;
    }

    float torre_x = x;
    float torre_y = y - 2*Tile.tamanho;
    
    tint(255, 255*torre.decomposicao);
    image(TextureLoader.textura_torre(torre.nivel), x, y - 2*Tile.tamanho, Tile.tamanho, 2*Tile.tamanho);
    tint(255, 255);

    // desenhando barrinha de vida
    pushMatrix();
    strokeWeight(1);
    fill(0, 255, 0);
    rect(torre_x, torre_y - (Tile.tamanho / 9), Tile.tamanho * (torre.vida / torre.vida_max), Tile.tamanho / 9);
    popMatrix();
    
    return false;
  }

  private void desenhar_projetil(Projetil projetil) {
    stroke(0, 0, 255);
    fill(255, 185, 200);
    ellipse(projetil.x - this.camera_x, projetil.y, 4, 4);
  }
}



//

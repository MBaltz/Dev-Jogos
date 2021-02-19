Mundo mundo;
Desenhador desenhador;
Camera camera_obj;
int fps = 30;
int num_tiles = 30;

boolean jogo_carregado = false;
String msg_carregamento = "";

//TODO: usar uma escala dos tamanhos pra mudar os tamanhos de acordo com a resolução

void setup() {
  frameRate(fps);
  orientation(LANDSCAPE); // modo paisagem no celular
  //fullScreen(); // tela cheia
  size(1170, 540);
  thread("carregar_jogo");
}


void carregar_jogo() {

  msg_carregamento = "Criando mundo...";
  mundo = new Mundo(num_tiles); // cria um mundo com o numero de tiles
  msg_carregamento = "Mundo criado.";


  msg_carregamento = "Criando renderizador...";
  desenhador = new Desenhador();
  msg_carregamento = "Renderizador criado.";


  msg_carregamento = "Criando camera...";
  camera_obj = new Camera(-width/2.0); // centraliza a camera no tile do meio
  msg_carregamento = "Camera criada.";


  msg_carregamento = "Criando Handler de entrada...";
  // Nunca mais precisa instanciar de novo (Classe Estática)
  //  (singleton não funciona por causa da linguagem)
  Entrada.desenhador_ref = desenhador;
  Entrada.camera_ref = camera_obj;
  Entrada.tamanho_x_mapa = mundo.tamanho_x_mapa;
  Entrada.largura_tela = width;
  msg_carregamento = "Handler de entrada criado.";


  msg_carregamento = "Carregando texturas...";
  TextureLoader.carregar_texturas(new TextureLoaderHelper());
  msg_carregamento = "Texturas carregadas.";


  msg_carregamento = "Tudo ok";
  jogo_carregado = true;
  thread("atualizar");
}

void atualizar() {
  float prev = 0, atual = 0;
  while(true) {

    // Alguém pediu pra fechar o jogo?
    if(Entrada.pediu_pra_fechar) {
      exit();
    }

    // Fazer com que o fps não deixe a jogabilidade mais rápida ou lenta
    atual = millis(); // Retorna o tempo em milisegundos o jogo está aberto
    float dt = (atual - prev) / 1000.0; // Passa pra segundos (/1000)
    mundo.atualizar(dt); // atualiza o mundo com um passo em dt segundos
    delay(1000/fps); // fps=30: delay(33,333)
    prev = atual;
  }
}

void draw() {
  background(0);

  if(jogo_carregado) {
    // desenha levando em consideração a posição da camera
    desenhador.desenhar(mundo, camera_obj);
    TextureLoader.atualizar();
  }
  else {
    desenhar_tela_carregamento();
  }
  mostrar_fps();
}

void mostrar_fps() {
    pushMatrix();
    fill(190);
    stroke(255);
    textSize(12);
    text("FPS:"+int(frameRate), 20, 12);
    popMatrix();
}

void desenhar_tela_carregamento() {
  background(0);
  textAlign(CENTER);
  delay(200);
  text(msg_carregamento, width/2, height/2);
}

void mouseDragged() { // apertou e arrastou pra mover a camera
  if(jogo_carregado) {
    float diff = mouseX - pmouseX; // direção do arrasto
    Entrada.mover(diff); // atualiza a camera
  }
}

void mouseReleased() {
  if(jogo_carregado) {
    // melhorar esse sistema de entrada, por algum motivo as vezes não funciona
    // mas nada que atrapalhe muito a jogabilidade, provavel que seja só uma besteirinha
    Entrada.clicar(mouseX, mouseY);
  }
}




//

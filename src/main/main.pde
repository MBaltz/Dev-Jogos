Mundo mundo;
Desenhador desenhador;
Camera camera_obj;
int fps = 60;
int num_tiles = 28;

boolean jogo_carregado = false;
String msg_carregamento = "";

boolean clicado_main  = false;
float x_clicado_main = 0.0;
float y_clicado_main = 0.0;

//TODO: usar uma escala dos tamanhos pra mudar os tamanhos de acordo com a resolução

void setup() {
  frameRate(fps);
  orientation(LANDSCAPE); // modo paisagem no celular
  // fullScreen(); // tela cheia
  size(1170, 540);
  textFont(createFont("Steps-Mono.otf", 20));
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
    
    if(mundo.game_over) {
      break;
    }

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
  
  if(mundo.game_over) {
    desenhar_tela_game_over();
    return;
  }

  if(jogo_carregado) {
    // desenha levando em consideração a posição da camera

    try {
      Mundo mundo_clonado = (Mundo) mundo.clone();
      desenhador.desenhar(mundo_clonado, camera_obj);
    } catch(Exception ex) {
      desenhador.desenhar(mundo, camera_obj);
    }
    
    TextureLoader.atualizar();

    if(clicado_main) {
      Entrada.clicar(x_clicado_main, y_clicado_main);
      x_clicado_main = 0.0;
      y_clicado_main = 0.0;
      clicado_main = false;
    }

  }
  else {
    desenhar_tela_carregamento();
  }
  mostrar_fps();
}

void mostrar_fps() {
    pushMatrix();
    fill(255);
    stroke(255);
    textSize(18);
    text("FPS:"+int(frameRate), 32, 15);
    popMatrix();
}

void desenhar_tela_carregamento() {
  background(0);
  textSize(36);
  textAlign(CENTER);
  delay(200);
  text(msg_carregamento, width/2, height/2);
}

void desenhar_tela_game_over() {
  background(0);
  textSize(36);
  textAlign(CENTER);
  delay(200);
  text("Merreu/faliu", width/2, height/2); //TODO: melhorar tela de game over
}


void mouseDragged() { // apertou e arrastou pra mover a camera
  if(jogo_carregado) {
    float diff = mouseX - pmouseX; // direção do arrasto
    Entrada.mover(diff); // atualiza a camera
  }
}

void mouseReleased() {
  if(jogo_carregado) {
    // já foi melhorado, usar a classe estatica de entrada não funciona tão bem pra cliques
    // quanto variaveis globais assim, de toda forma, para cliques, é preferivel usar essas
    // variaveis globais.
    // com a classe estatica não funciona muito bem por motivos de thread provavelmente
    // isso levou a uma refatoração do popup que nem precisaria, mas foi até bom, enxugou
    // o codigo e melhorou a legibilidade
    clicado_main = true;
    x_clicado_main = mouseX;
    y_clicado_main = mouseY;
  }
}

//

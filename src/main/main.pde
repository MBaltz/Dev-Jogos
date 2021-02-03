Mundo mundo;
Desenhador desenhador;
Camera camera_obj;
Entrada entrada_obj;
int fps = 30;
int num_tiles = 100;

void setup() {
  frameRate(fps);
  
  mundo = new Mundo(num_tiles); // cria um mundo com o numero de tiles
  desenhador = new Desenhador();
  camera_obj = new Camera(-width/2.0); // centraliza a camera no tile do meio
  entrada_obj = new Entrada(); //Nunca mais precisa, singleton não funciona por causa da linguagem
  entrada_obj.setar_desenhador(desenhador);
  entrada_obj.setar_camera(camera_obj);
  
  orientation(LANDSCAPE); // modo paisagem no celular
  //fullScreen(); // tela cheia
  size(1130, 720);
  thread("atualizar");
}

void atualizar() {
  float prev = 0, atual = 0;
  while(true) {

    //alguem pediu pra fechar o jogo?
    if(Entrada.pediu_pra_fechar) {
      exit();
    }
    
    atual = millis();
    float dt = (atual - prev) / 1000.0;
    mundo.atualizar(dt); // atualiza o mundo com um passo em dt segundos
    delay(1000/fps);
    prev = atual;
  }
}

void draw() {
  background(0);
  desenhador.desenhar(mundo, camera_obj); // desenha levando em consideração a posição da camera
}

void mouseDragged() { // apertou e arrastou pra mover a camera
  float diff = mouseX - pmouseX; // direção do arrasto
  //TODO: só atualizar se não chegou nos limites do mapa
  Entrada.instancia().mover(diff); // atualiza a camera
}

void mouseClicked() {
  Entrada.instancia().clicar();
}

Mundo mundo;
float camera_x;

int fps = 30;

void setup() {
  frameRate(fps);
  int num_tiles = 100; // num de tiles q vai ter no mundo
  mundo = new Mundo(num_tiles); // cria um mundo com o numero de tiles
  camera_x = -width/2; // centraliza a camera no tile do meio
  orientation(LANDSCAPE); // modo paisagem no celular
  //fullScreen(); // tela cheia
  size(1130, 720);
  thread("atualizar");
}

void atualizar() {
  float prev = 0, atual = 0;
  while(true) {
    atual = millis();
    float dt = (atual - prev) / 1000.0;
    mundo.atualizar(dt); // atualiza o mundo
    delay(1000/fps);
    prev = atual;
  }
}

void draw() {
  background(0);
  mundo.desenhar(camera_x); // desenha levando em consideração a posição da camera
}

void mouseDragged() { // apertou e arrastou pra mover a camera
  float diff = mouseX - pmouseX; // direção do arrasto
  //TODO: só atualizar se não chegou nos limites do mapa
  camera_x -= diff; // atualiza a camera
}


void mousePressed() {
  mundo.clicar(mouseX, mouseY);
}

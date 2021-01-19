Mundo mundo;
float camera_x;

void setup() {
  int num_tiles = 100; // num de tiles q vai ter no mundo
  mundo = new Mundo(num_tiles); // cria um mundo com o numero de tiles
  camera_x = (Tile.tamanho * num_tiles) / 2; // centraliza a camera no tile do meio
  orientation(LANDSCAPE); // modo paisagem no celular
  fullScreen(); // tela cheia
}

void draw() {
  background(0);
  mundo.desenhar(camera_x); // desenha levando em consideração a posição da camera
  mundo.atualizar(); // atualiza o mundo
}

void mouseDragged() { // apertou e arrastou pra mover a camera
  float diff = mouseX - pmouseX; // direção do arrasto
  //TODO: só atualizar se não chegou nos limites do mapa
  camera_x -= diff; // atualiza a camera
}

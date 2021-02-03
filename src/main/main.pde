Mundo mundo;
Desenhador desenhador;
Camera camera_obj;
Entrada entrada_obj;
int fps = 30;
int num_tiles = 100;

boolean jogo_carregado = false;
String msg_carregamento = "";

void setup() {
  frameRate(fps);
  orientation(LANDSCAPE); // modo paisagem no celular
  fullScreen(); // tela cheia
  //size(1130, 720);
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
  entrada_obj = new Entrada(); //Nunca mais precisa, singleton não funciona por causa da linguagem
  entrada_obj.setar_desenhador(desenhador);
  entrada_obj.setar_camera(camera_obj);
  msg_carregamento = "Handler de entrada criado.";

  
  msg_carregamento = "Tudo ok";
  jogo_carregado = true;
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

  if(jogo_carregado) {
    desenhador.desenhar(mundo, camera_obj); // desenha levando em consideração a posição da camera
  }
  else {
    desenhar_tela_carregamento();
  }
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
    //TODO: só atualizar se não chegou nos limites do mapa
    Entrada.instancia().mover(diff); // atualiza a camera
  }
}

void mouseClicked() {
  if(jogo_carregado) {
    Entrada.instancia().clicar();
  }
}





// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}

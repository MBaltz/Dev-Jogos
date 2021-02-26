class TexturePack {

  
  public ArrayList<PImage> texturas_player_andando;
  public PImage textura_player_parado;
  
  public ArrayList<PImage> texturas_inimigos;
  public PImage textura_seta_player;
  
  public PImage textura_base;
  public PImage textura_tile;
  public ArrayList<PImage> texturas_minas;
  public ArrayList<PImage> texturas_torres;

  public ArrayList<PImage> texturas_bg_sol;
  public ArrayList<PImage> texturas_bg;

  
  public TexturePack() {
    this.texturas_player_andando = new ArrayList<PImage>();
    this.texturas_inimigos = new ArrayList<PImage>();
    this.texturas_minas = new ArrayList<PImage>();
    this.texturas_torres = new ArrayList<PImage>();
    this.texturas_bg_sol  = new ArrayList<PImage>();
    this.texturas_bg  = new ArrayList<PImage>();
  }
}

class TextureLoaderHelper {

  final String TEXTURA_PATH = "assets/texturas/";
  private TexturePack conjunto_texturas;
  
  public TextureLoaderHelper() {
    this.conjunto_texturas = new TexturePack();
  }
  
  public TexturePack carregar_texturas() {
    this.carregar_texturas_player();
    this.carregar_texturas_inimigos();
    this.carregar_texturas_seta_player();
    this.carregar_texturas_base();
    this.carregar_texturas_mina();
    this.carregar_texturas_torre();
    this.carregar_texturas_tile();
    this.carregar_texturas_bg();
    return this.conjunto_texturas;
  }

  private void carregar_texturas_player() {
    
    final String PLAYER_PARADO = "Personagem_Parado.png";
    this.conjunto_texturas.textura_player_parado = loadImage(TEXTURA_PATH + PLAYER_PARADO);

    for(int i = 3; i <= 6; i++) {
      String PLAYER_ANDANDO = "Personagem_0" + i + ".png";
      this.conjunto_texturas.texturas_player_andando.add(loadImage(TEXTURA_PATH + PLAYER_ANDANDO));
    }

    
  }

  private void carregar_texturas_inimigos() {
    //Cria uma imagem provisoria
    final String INIMIGO = "Inimigo.png";
    this.conjunto_texturas.texturas_inimigos.add(loadImage(TEXTURA_PATH + INIMIGO));
  }

  private void carregar_texturas_seta_player() {
    final String SETA = "seta.png";
    this.conjunto_texturas.textura_seta_player = loadImage(TEXTURA_PATH + SETA);
  }

  private void carregar_texturas_base() {
    //Cria uma imagem provisoria
    String BASE = "Cofre.png";
    this.conjunto_texturas.textura_base = loadImage(TEXTURA_PATH + BASE);
  }

  private void carregar_texturas_mina() {
    for(int i = 1; i < 4; i++) {
      String MINA = "Mina_" + i + "_0.png";
      this.conjunto_texturas.texturas_minas.add(loadImage(TEXTURA_PATH + MINA));
    }
  }
  
  private void carregar_texturas_torre() {
    for(int i = 1; i < 4; i++) {
      String TORRE = "Torre_" + i + "_0.png";
      this.conjunto_texturas.texturas_torres.add(loadImage(TEXTURA_PATH + TORRE));
    }
  }

  private void carregar_texturas_tile() {
    final String TILE = "plataforma.png";
    this.conjunto_texturas.textura_tile = loadImage(TEXTURA_PATH + TILE);
  }

  private void carregar_texturas_bg() {

    for(int i = 1; i < 8; i++) {
      String textura_idx = String.format("%02d", i);
      String BG_SOL = "bg_dia_" + textura_idx + ".png";
      String BG_SEM_SOL = "bg_dia_" + textura_idx + "_x.png";

      this.conjunto_texturas.texturas_bg_sol.add(loadImage(TEXTURA_PATH + BG_SOL));
      this.conjunto_texturas.texturas_bg.add(loadImage(TEXTURA_PATH + BG_SEM_SOL));
    }
  }
}


static class TextureLoader {

  public static int ticks_texturas;
  public static int ticks_acc;
  public static TexturePack texturas;
  
  public static void carregar_texturas(TextureLoaderHelper tmp) {
    texturas = tmp.carregar_texturas();
  }

  // Pra dar uma impressão de animação
  public static void atualizar() {
    ticks_acc++;

    if(ticks_acc > 3) {
      ticks_acc = 0;
      ticks_texturas = (ticks_texturas + 1) % 255;
    }
    
  }

  public static PImage textura_player_parado() {
    return texturas.textura_player_parado;
  }

  public static PImage textura_player_andando() {
    return texturas.texturas_player_andando.get(ticks_texturas % texturas.texturas_player_andando.size());
  }

  // por enquanto inimigo só tem 1 tipo
  public static PImage textura_inimigo() {
    return texturas.texturas_inimigos.get(ticks_texturas % texturas.texturas_inimigos.size());
  }

  public static PImage textura_seta_player() {
    return texturas.textura_seta_player;
  }

  public static PImage textura_base() {
    return texturas.textura_base;
  }

  public static PImage textura_mina(int nivel) {
    return texturas.texturas_minas.get(nivel < 3 ? nivel : 2);
  }
  
  public static PImage textura_torre(int nivel) {
    return texturas.texturas_torres.get(nivel < 3 ? nivel : 2);
  }

  public static PImage textura_tile() {
    return texturas.textura_tile;
  }

  public static PImage textura_bg(float dt_atual, float dt_max) {
    return texturas.texturas_bg.get(TextureLoader.idx_textura(dt_atual, dt_max));
  }

  public static PImage textura_bg_sol(float dt_atual, float dt_max) {
    return texturas.texturas_bg_sol.get(TextureLoader.idx_textura(dt_atual, dt_max));
  }

  public static int idx_textura(float dt_atual, float dt_max) {

    int num_texturas = texturas.texturas_bg.size();
    float intervalo = dt_max / num_texturas;

    for(int i = 0; i < num_texturas; i++) {
      if(dt_atual >= (i*intervalo) && dt_atual <= ((i+1) * intervalo)) {
        return i;
      }
    }
    
    return 0;
  }

}

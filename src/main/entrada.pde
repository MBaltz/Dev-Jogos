/*
Classe que administra o input do clique
  - Para uma melhor organização, no entanto, não da pra colocar tudo nela
*/
static class Entrada {

  static boolean clicado = false;
  static Desenhador desenhador_ref;
  static Camera camera_ref;
  static boolean pediu_pra_fechar = false;
  static float clique_x;
  static float clique_y;

  // Para limitar o movimento da câmera dado o tamanho do mapa
  static float tamanho_x_mapa;
  static float largura_tela;

  // Mover mover camera
  public static void mover(float dx) {
    if(Entrada.desenhador_ref.mouse_na_regiao_controles() || Entrada.desenhador_ref.tem_popup()) {
      return;
    }
    // Não move a câmera além das bordas do mapa (limita às bordas da tela)
    if(Entrada.camera_ref.x-dx > Entrada.tamanho_x_mapa/2 - Entrada.largura_tela ||
      Entrada.camera_ref.x-dx < -Entrada.tamanho_x_mapa/2)
    {
      return;
    }
    Entrada.camera_ref.mover(dx);
  }

  public static void clicar(float x, float y) {
    Entrada.clicado = true;
    Entrada.clique_x = x;
    Entrada.clique_y = y;
  }

  public static void limpar_clique() {
    Entrada.clicado = false;
  }

  public static boolean clicado() {
    return Entrada.clicado;
  }

  public static boolean tem_popup() {
    return Entrada.desenhador_ref.tem_popup();
  }
}

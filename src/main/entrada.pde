/*
Classe que administra o input do clique
  (Para uma melhor organização, no entanto, não da pra colocar tudo nela, pela
  limitação que a linguagem coloca por ser estática)
*/
static class Entrada {

  private static int num_instancias = 0;
  static Entrada instancia;
  boolean clicado = false;
  Desenhador desenhador_ref;
  Camera camera_ref;
  static boolean pediu_pra_fechar = false;

  public Entrada() {

    if(Entrada.num_instancias >= 2) {
      System.err.println("Tentou criar mais de uma instancia de entrada");
      System.err.println("Use: Entrada.instancia() para pegar um objeto de Entrada");
      Entrada.pediu_pra_fechar = true;
    }

    num_instancias++;
    // Para utilizar os métodos como estáticos
    // No main: Entrada.instancia.metodo(), ao invés de Estrutura.metodo()
    // Dessa maneira, o método pode utilizar o this.
    this.instancia = this;
  }

  public static Entrada instancia() {
    return instancia;
  }

  public void setar_desenhador(Desenhador desenhador_ref) {
    this.desenhador_ref = desenhador_ref;
  }

  public void setar_camera(Camera camera_ref) {
    this.camera_ref = camera_ref;
  }

  // Mover mover camera
  public void mover(float dx) {
    if(this.desenhador_ref.mouse_na_regiao_controles()) {
      return;
    }
    this.camera_ref.mover(dx);
  }

  public void clicar() {
    this.clicado = true;
  }

  public void limpar_clique() {
    this.clicado = false;
  }

  public boolean clicado() {
    return this.clicado;
  }
}

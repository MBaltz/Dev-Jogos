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

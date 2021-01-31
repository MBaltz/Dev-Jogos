//

public enum Tipo_Estrutura {
  BASE,
  MINA,
  TORRE,
}
abstract class Estrutura {

  public float x_off;
  public float y_off;
  public Tipo_Estrutura tipo;

  public abstract void atualizar(float dt);
}

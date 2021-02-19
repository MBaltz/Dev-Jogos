public enum Tipo_Estrutura {
  BASE,
  MINA,
  TORRE,
}

// Classe abstrata que faz a representação de uma estrutura
abstract class Estrutura {
  public float x;
  public float y;
  public static final float custo_construir = 1000;
  public Tipo_Estrutura tipo;
  public boolean morreu = false;
  public float decomposicao = 1.0;

  public abstract void atualizar(float dt);
}

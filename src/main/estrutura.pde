public enum Tipo_Estrutura {
  BASE,
  MINA,
  TORRE,
}

// Classe abstrata que faz a representação de uma estrutura
abstract class Estrutura {

  // TODO: Vamos mesmo usar 'x_off', 'y_off'? Ou melhor seguir o padrão 'x', 'y'?
  public float x_off;
  public float y_off;
  // TODO: Deixar esse valor dinâmico de acordo com o tipo de estrutura
  public static final float custo_construir = 1000;
  public Tipo_Estrutura tipo;
  public boolean morreu = false;
  public abstract void atualizar(float dt);
}

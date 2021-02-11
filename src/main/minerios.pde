import java.util.Random;
import java.util.Map;

public enum Minerio {

  //ENUM, Texto, valor, probabilidade % de aparecer no tile (tem q somar 100)
  PEDRA("Pedra",     1.0, 60),
  CARVAO("Carvão",   1.2, 20),
  ESTANHO("Estanho", 1.1, 10),
  FERRO("Ferro",     1.5, 8),
  COBRE("Cobre",     2.0, 2);


  private static final Map<String, Minerio> NOMES = new HashMap();
  private static final Map<Float, Minerio> VALORES =  new HashMap();
  

  static {
    for (Minerio m : values()) {
      NOMES.put(m.nome, m);
      VALORES.put(m.valor, m);
    }
  }

  
  public final String nome;
  public final float valor;
  public final float probabilidade;
  private static Random rnd = new Random();
  
  private Minerio(String nome, float valor, float probabilidade) {
    this.nome = nome;
    this.valor = valor;
    this.probabilidade = probabilidade;
  }
  
  public static Minerio pegar_minero_por_nome(String nome) {
    return NOMES.get(nome);
  }

  
  @Override 
  public String toString() { 
    return this.nome; 
  }

  public static Minerio escolher_minerio() {

    Minerio retorno = null;
    int idx_possibilidades = values().length;
    int escolha = rnd.nextInt(101); //pega um numero de 0 a 100
    int prob_anterior = 0;

    for(int idx = 0; idx < idx_possibilidades; idx++) {
      int prob_atual = (int) values()[idx].probabilidade + prob_anterior;

      if((escolha <= prob_atual) && (escolha >= prob_anterior)) {
        retorno = values()[idx];
        return retorno;
      }
      prob_anterior = prob_atual;
    }
    println("ruim");
    return retorno; // ué
  }

  
}

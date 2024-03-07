package backend.model;
import java.util.Objects;

public class instituto(){
    private int id;
    private String nome;
    private String acronimo;

    public instituto(){

    }
    public instituto(int id, String nome, String acronimo){
        this.id = id;
        this.nome = nome;
        this.acronimo = acronimo;
    }
    
    public int getid(){
        return id;
    }

    public String getnome(){
        return nome;
    }

    public String setnome(String nome){
        this.nome = nome;
    }

    public String getacronimo(){
        return acronimo;
    }
    public String setacronimo(String acronimo){
        this.acronimo = acronimo;
    }
}


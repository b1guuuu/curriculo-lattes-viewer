# inicializa o pacote
import dao
import utils.graph_manager as gm

try:
    if __name__ == "__main__":
        gm.gerar_grafo_vertice_instituto()
except Exception as e:
    print(e)
    raise
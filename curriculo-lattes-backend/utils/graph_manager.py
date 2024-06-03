import networkx as nx
from dao.autoria_dao import AutoriaDao
from dao.graph_dao import GraphDao
from dao.instituto_dao import InstitutoDao
from dao.pesquisador_dao import PesquisadorDao
from dao.trabalho_dao import TrabalhoDao
import matplotlib.pyplot as plt

def gerar_grafo_vertice_instituto():
    graph = nx.Graph()
    graph_dao = GraphDao()
    instituto_dao = InstitutoDao()
    institutos = instituto_dao.get_all()
    
    for instituto in institutos:
        graph.add_node(instituto.acronimo)
        print(instituto.acronimo)
        relacoes = graph_dao.get_by_instituto(instituto.id)
        if len(relacoes) > 0:
            for relacao in relacoes:
                print(f'-{relacao}')
                if instituto.acronimo != relacao[0]:
                    graph.add_edge(instituto.acronimo, relacao[0])
    
    print(graph.edges)
    pos = nx.spring_layout(graph)
    nx.draw_networkx_nodes(graph, pos)
    nx.draw_networkx_labels(graph, pos)
    nx.draw_networkx_edges(graph, pos, arrows=False)
    nx.draw_networkx_edge_labels(graph, pos)
    plt.show()
        
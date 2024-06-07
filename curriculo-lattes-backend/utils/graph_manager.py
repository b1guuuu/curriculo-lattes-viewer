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
        relacoes = graph_dao.get_by_instituto(instituto.id)
        if len(relacoes) > 0:
            for relacao in relacoes:
                if instituto.acronimo != relacao[0]:
                    if (instituto.acronimo, relacao[0]) in graph.edges():
                        att_dic = graph.get_edge_data(instituto.acronimo, relacao[0])
                        graph.remove_edge(instituto.acronimo, relacao[0])
                        graph.add_edge(instituto.acronimo, relacao[0], label=att_dic['label']+1)
                    else:
                        graph.add_edge(instituto.acronimo, relacao[0], label=1)
    pos = nx.circular_layout(graph)
    plt.figure(figsize=[16,9])
    nx.draw(
        graph,
        pos,
        edge_color='black',
        width=1,
        linewidths=1,
        node_size=1000,
        node_color='pink',
        alpha=0.9,
        labels={node: node for node in graph.nodes()}
    )
    labels = {}
    for edge in graph.edges():
        att_dic = graph.get_edge_data(edge[0], edge[1])
        labels[edge] = att_dic['label']
    print(labels)
    nx.draw_networkx_edge_labels(
        graph,
        pos,
        edge_labels={edge: labels[edge] for edge in graph.edges()}
    )
    plt.axis('off')
    plt.savefig('Graph_instituto.png', format='PNG')
    plt.show()

def gerar_grafo_vertice_pesquisador():
    graph = nx.Graph()
    graph_dao = GraphDao()
    pesquisador_dao = PesquisadorDao()
    pesquisadores = pesquisador_dao.get_all()
    
    for pesquisador in pesquisadores:
        graph.add_node(pesquisador.nome)
        relacoes = graph_dao.get_by_pesquisador(pesquisador.id)
        if len(relacoes) > 0:
            for relacao in relacoes:
                if pesquisador.nome != relacao[0]:
                    if (pesquisador.nome, relacao[0]) in graph.edges():
                        att_dic = graph.get_edge_data(pesquisador.nome, relacao[0])
                        graph.remove_edge(pesquisador.nome, relacao[0])
                        graph.add_edge(pesquisador.nome, relacao[0], label=att_dic['label']+1)
                    else:
                        graph.add_edge(pesquisador.nome, relacao[0], label=1)
    
    pos = nx.circular_layout(graph)
    plt.figure(figsize=[500,10])
    nx.draw(
        graph,
        pos,
        edge_color='black',
        width=1,
        linewidths=1,
        node_size=1000,
        node_color='pink',
        alpha=0.9,
        labels={node: node for node in graph.nodes()},
    )
    labels = {}
    for edge in graph.edges():
        att_dic = graph.get_edge_data(edge[0], edge[1])
        labels[edge] = att_dic['label']
    print(labels)
    nx.draw_networkx_edge_labels(
        graph,
        pos,
        edge_labels={edge: labels[edge] for edge in graph.edges()}
    )
    plt.axis('off')
    plt.savefig('Graph_pesquisador.png', format='PNG')
    plt.show()
        
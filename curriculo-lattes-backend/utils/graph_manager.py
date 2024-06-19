import networkx as nx
from dao.autoria_dao import AutoriaDao
from dao.graph_dao import GraphDao
from dao.instituto_dao import InstitutoDao
from dao.pesquisador_dao import PesquisadorDao
from dao.trabalho_dao import TrabalhoDao
import matplotlib.pyplot as plt

class GraphManager:

    def get_edge_color(self, regras, valor):
        for regra in regras:
            if regra['fim'] == -1:
               return regra['cor']
            elif regra['inicio'] <= valor and valor <= regra['fim'] :
               return regra['cor']
        return 'black'

    def gerar_grafo_vertice_instituto(self, ids=[], pesquisadores=[], regras=[], tipo_producao=''):
        graph = nx.Graph()
        graph_dao = GraphDao()
        instituto_dao = InstitutoDao()
        institutos = instituto_dao.get_group(ids)
        
        for instituto in institutos:
            if instituto.acronimo not in graph.nodes:
                graph.add_node(instituto.acronimo)
            relacoes = graph_dao.get_by_instituto(instituto.id, pesquisadores=pesquisadores, tipo_producao=tipo_producao)
            if len(relacoes) > 0:
                for relacao in relacoes:
                    if instituto.acronimo != relacao[0]:
                        if (instituto.acronimo, relacao[0]) in graph.edges():
                            att_dic = graph.get_edge_data(instituto.acronimo, relacao[0])
                            graph.remove_edge(instituto.acronimo, relacao[0])
                            graph.add_edge(instituto.acronimo, relacao[0], label=att_dic['label']+1, cor=self.get_edge_color(regras=regras, valor=att_dic['label']+1))
                        else:
                            graph.add_edge(instituto.acronimo, relacao[0], label=1, cor=self.get_edge_color(regras=regras, valor=1))
        
        cores = nx.get_edge_attributes(graph, 'cor').values()
        weights = nx.get_edge_attributes(graph, 'label').values()

        pos = nx.circular_layout(graph)
        plt.figure(figsize=[16,10])
        nx.draw(
            graph,
            pos,
            edge_color=cores,
            width=list(weights),
            node_size=1000,
            node_color='pink',
            alpha=0.9,
            labels={node: node for node in graph.nodes()},
        )
        labels = {}
        for edge in graph.edges():
            att_dic = graph.get_edge_data(edge[0], edge[1])
            labels[edge] = att_dic['label']
        
        nx.draw_networkx_edge_labels(
            graph,
            pos,
            edge_labels={edge: labels[edge] for edge in graph.edges()}
        )
        plt.axis('off')
        plt.savefig('Graph.png', format='PNG', dpi=200)
        graph.clear()
        nx._clear_cache(graph)
        plt.clf()


    def gerar_grafo_vertice_pesquisador(self, institutos=[], ids=[], regras=[], tipo_producao=''):
        graph = nx.Graph()
        graph_dao = GraphDao()
        pesquisador_dao = PesquisadorDao()
        pesquisadores = pesquisador_dao.get_group(ids)
        
        for pesquisador in pesquisadores:
            if pesquisador.nome not in graph.nodes:
                graph.add_node(pesquisador.nome)
            relacoes = graph_dao.get_by_pesquisador(pesquisador.id, institutos=institutos, tipo_producao=tipo_producao)
            if len(relacoes) > 0:
                for relacao in relacoes:
                    if pesquisador.nome != relacao[0]:
                        if (pesquisador.nome, relacao[0]) in graph.edges():
                            att_dic = graph.get_edge_data(pesquisador.nome, relacao[0])
                            graph.remove_edge(pesquisador.nome, relacao[0])
                            graph.add_edge(pesquisador.nome, relacao[0], label=att_dic['label']+1, cor=self.get_edge_color(regras=regras, valor=att_dic['label']+1))
                        else:
                            graph.add_edge(pesquisador.nome, relacao[0], label=1, cor=self.get_edge_color(regras=regras, valor=1))
        
        cores = nx.get_edge_attributes(graph, 'cor').values()
        weights = nx.get_edge_attributes(graph, 'label').values()

        pos = nx.circular_layout(graph)
        plt.figure(figsize=[16,9])
        nx.draw(
            graph,
            pos,
            edge_color=cores,
            width=list(weights),
            node_size=1000,
            node_color='pink',
            alpha=0.9,
            labels={node: node for node in graph.nodes()},
        )
        labels = {}
        for edge in graph.edges():
            att_dic = graph.get_edge_data(edge[0], edge[1])
            labels[edge] = att_dic['label']
            
        nx.draw_networkx_edge_labels(
            graph,
            pos,
            edge_labels={edge: labels[edge] for edge in graph.edges()}
        )

        plt.axis('off')
        plt.savefig('Graph.png', format='PNG', dpi=200)
        graph.clear()
        nx._clear_cache(graph)
        plt.clf()
            
    def gerar_grafo_sem_repeticoes_vertice_instituto(self, institutos=[], pesquisadores=[], regras=[], tipo_producao=''):
        graph = nx.Graph()
        graph_dao = GraphDao()
        trabalho_dao = TrabalhoDao()
        trabalhos = trabalho_dao.get_by_pesquisadores_institutos_tipo(pesquisadores=pesquisadores, institutos=institutos, tipo_producao=tipo_producao)

        for trabalho in trabalhos:
            relacoes = graph_dao.get_trabalho_relacoes_distinct_instituto(trabalho.id)
            
            for i in range(len(relacoes)):
                relacao_i = relacoes[i]
                if relacao_i['instituto_id'] in institutos:
                    if relacao_i['instituto_acronimo'] not in graph.nodes:
                        graph.add_node(relacao_i['instituto_acronimo'])
                    if i+1 < len(relacoes):
                        for j in range(i+1, len(relacoes)):
                            relacao_j = relacoes[j]
                            if relacao_i['instituto_acronimo'] != relacao_j['instituto_acronimo']:
                                if(relacao_i['instituto_acronimo'], relacao_j['instituto_acronimo']) in graph.edges:
                                    edge_att_dic = graph.get_edge_data(relacao_i['instituto_acronimo'], relacao_j['instituto_acronimo'])
                                    graph.remove_edge(relacao_i['instituto_acronimo'], relacao_j['instituto_acronimo'])
                                    graph.add_edge(relacao_i['instituto_acronimo'], relacao_j['instituto_acronimo'], label=edge_att_dic['label']+1, cor=self.get_edge_color(regras=regras, valor=edge_att_dic['label']+1))
                                else:
                                    graph.add_edge(relacao_i['instituto_acronimo'], relacao_j['instituto_acronimo'], label=1, cor=self.get_edge_color(regras=regras, valor=1))
        cores = nx.get_edge_attributes(graph, 'cor').values()
        weights = nx.get_edge_attributes(graph, 'label').values()

        pos = nx.circular_layout(graph)
        plt.figure(figsize=[16,10])
        nx.draw(
            graph,
            pos,
            edge_color=cores,
            width=list(weights),
            node_size=1000,
            node_color='pink',
            alpha=0.9,
            labels={node: node for node in graph.nodes()},
        )
        labels = {}
        for edge in graph.edges():
            att_dic = graph.get_edge_data(edge[0], edge[1])
            labels[edge] = att_dic['label']
        
        nx.draw_networkx_edge_labels(
            graph,
            pos,
            edge_labels={edge: labels[edge] for edge in graph.edges()}
        )
        plt.axis('off')
        plt.savefig('Graph.png', format='PNG', dpi=200)
        graph.clear()
        nx._clear_cache(graph)
        plt.clf()

    def gerar_grafo_sem_repeticoes_vertice_pesquisador(self, institutos=[], pesquisadores=[], regras=[], tipo_producao=''):
        graph = nx.Graph()
        graph_dao = GraphDao()
        trabalho_dao = TrabalhoDao()
        trabalhos = trabalho_dao.get_by_pesquisadores_institutos_tipo(pesquisadores=pesquisadores, institutos=institutos, tipo_producao=tipo_producao)

        for trabalho in trabalhos:
            relacoes = graph_dao.get_trabalho_relacoes_distinct_pesquisador(trabalho.id)
            
            for i in range(len(relacoes)):
                relacao_i = relacoes[i]
                if relacao_i['pesquisador_id'] in pesquisadores:
                    if relacao_i['pesquisador_nome'] not in graph.nodes:
                        graph.add_node(relacao_i['pesquisador_nome'])
                    if i+1 < len(relacoes):
                        for j in range(i+1, len(relacoes)):
                            relacao_j = relacoes[j]
                            if relacao_i['pesquisador_nome'] != relacao_j['pesquisador_nome']:
                                if(relacao_i['pesquisador_nome'], relacao_j['pesquisador_nome']) in graph.edges:
                                    edge_att_dic = graph.get_edge_data(relacao_i['pesquisador_nome'], relacao_j['pesquisador_nome'])
                                    graph.remove_edge(relacao_i['pesquisador_nome'], relacao_j['pesquisador_nome'])
                                    graph.add_edge(relacao_i['pesquisador_nome'], relacao_j['pesquisador_nome'], label=edge_att_dic['label']+1, cor=self.get_edge_color(regras=regras, valor=edge_att_dic['label']+1))
                                else:
                                    graph.add_edge(relacao_i['pesquisador_nome'], relacao_j['pesquisador_nome'], label=1, cor=self.get_edge_color(regras=regras, valor=1))
        cores = nx.get_edge_attributes(graph, 'cor').values()
        weights = nx.get_edge_attributes(graph, 'label').values()

        pos = nx.circular_layout(graph)
        plt.figure(figsize=[16,10])
        nx.draw(
            graph,
            pos,
            edge_color=cores,
            width=list(weights),
            node_size=1000,
            node_color='pink',
            alpha=0.9,
            labels={node: node for node in graph.nodes()},
        )
        labels = {}
        for edge in graph.edges():
            att_dic = graph.get_edge_data(edge[0], edge[1])
            labels[edge] = att_dic['label']
        
        nx.draw_networkx_edge_labels(
            graph,
            pos,
            edge_labels={edge: labels[edge] for edge in graph.edges()}
        )
        plt.axis('off')
        plt.savefig('Graph.png', format='PNG', dpi=200)
        graph.clear()
        nx._clear_cache(graph)
        plt.clf()
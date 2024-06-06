from dao.pesquisador_dao import PesquisadorDao
from dao.trabalho_dao import TrabalhoDao
from dao.autoria_dao import AutoriaDao
class TrabalhoManager:
    def __init__(self):
        self.pesquisador_dao = PesquisadorDao()
        self.trabalho_dao = TrabalhoDao()
        self.autoria_dao = AutoriaDao()

    def get_artigos(self, xml_dictionary=None):
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        artigos = []
        try:
            artigos = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['ARTIGOS-PUBLICADOS']['ARTIGO-PUBLICADO']
        except:
            print('Não há artigos publicados pelo pesquisador')
            artigos = []
        
        if(type(artigos) != type([])):
            return [artigos]
        else:
            return artigos
    
    def get_capitulos(self, xml_dictionary=None):
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        capitulos = []
        try:
            capitulos = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['LIVROS-E-CAPITULOS']['CAPITULOS-DE-LIVROS-PUBLICADOS']['CAPITULO-DE-LIVRO-PUBLICADO']
        except:
            print('Não há capítulos publicados pelo pesquisador')
            capitulos = []
        if(type(capitulos) != type([])):
            return [capitulos]
        else:
            return capitulos
    
    def get_livros(self, xml_dictionary=None):
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        livros = []
        try:
            livros = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['LIVROS-E-CAPITULOS']['LIVROS-PUBLICADOS-OU-ORGANIZADOS']['LIVRO-PUBLICADO-OU-ORGANIZADO']
        except:
            print('Não há livros publicados pelo pesquisador')
            livros = []
        if(type(livros) != type([])):
            return [livros]
        else:
            return livros
    
    def get_dados_basicos(self, xml_dictionary=None, tipo=''):
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        titulo = ''
        ano = -1

        if tipo == 'ARTIGO':
            titulo = xml_dictionary['DADOS-BASICOS-DO-ARTIGO']['@TITULO-DO-ARTIGO'].lower().title()
            ano = xml_dictionary['DADOS-BASICOS-DO-ARTIGO']['@ANO-DO-ARTIGO']
        elif tipo == 'CAPITULO':
            titulo = xml_dictionary['DADOS-BASICOS-DO-CAPITULO']['@TITULO-DO-CAPITULO-DO-LIVRO'].lower().title()
            ano = xml_dictionary['DADOS-BASICOS-DO-CAPITULO']['@ANO']
        elif tipo == 'LIVRO':
            titulo = xml_dictionary['DADOS-BASICOS-DO-LIVRO']['@TITULO-DO-LIVRO'].lower().title()
            ano = xml_dictionary['DADOS-BASICOS-DO-LIVRO']['@ANO']
        else:
            raise Exception('Tipo não suportado')

        return {
            'titulo': titulo,
            'ano': ano
        }

    def get_autor(self, xml_dictionary=None):
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        nome = xml_dictionary['@NOME-COMPLETO-DO-AUTOR'].replace('\'', '\\\'').lower().title()
        nome_referencia = xml_dictionary['@NOME-PARA-CITACAO'].split(';')[0].lower().title()
        ordem = xml_dictionary['@ORDEM-DE-AUTORIA']
        return {
            'nome' : nome,
            'nome_referencia': nome_referencia,
            'ordem': ordem
        }

    def create_trabalhos_tipo(self, xml_dictionary=None, tipo=None):
        tipo_salvar = ''
        if xml_dictionary == None : 
            raise Exception('Necessário dicionário xml')
        trabalhos = []
        if tipo == 'ARTIGO':
            trabalhos = self.get_artigos(xml_dictionary)
            tipo_salvar = 'ARTIGO'
        elif tipo == 'CAPITULO':
            trabalhos = self.get_capitulos(xml_dictionary)
            tipo_salvar = 'LIVRO'
        elif tipo == 'LIVRO':
            trabalhos = self.get_livros(xml_dictionary)
            tipo_salvar = 'LIVRO'
        else:
            raise Exception('Tipo não suportado')
        
        for trabalho in trabalhos:
            dados_basicos = self.get_dados_basicos(trabalho, tipo)
            trabalho_existe = self.trabalho_dao.get_by_columns(dados_basicos['titulo'], dados_basicos['ano'], tipo_salvar)
            id_trabalho = -1
            if len(trabalho_existe) > 0:
                id_trabalho = trabalho_existe[0].id
            else:
                self.trabalho_dao.create(dados_basicos['titulo'], dados_basicos['ano'], tipo_salvar)
                id_trabalho = self.trabalho_dao.get_last_inserted_id()

            autores = trabalho['AUTORES']
            if(type(autores) != type([])):
                autores = [autores]
            for autor in autores:
                dados_basicos_autor = self.get_autor(autor)
                autor_cadastrado = self.pesquisador_dao.get_by_nome_ou_referecia(dados_basicos_autor['nome'],dados_basicos_autor['nome_referencia'])
                autor_nao_cadastrado = self.autoria_dao.get_autor_nao_cadastrado_by_nome(dados_basicos_autor['nome'])

                try:
                    if len(autor_cadastrado) > 0:
                        self.ajuste_autorias(autor_nao_cadastrado, autor_cadastrado[0].id)
                        self.autoria_dao.create_autor_cadastrado(autor_cadastrado[0].id, id_trabalho, dados_basicos_autor['ordem'])
                    else:
                        self.autoria_dao.create_autor_nao_cadastrado(id_trabalho, dados_basicos_autor['ordem'], dados_basicos_autor['nome'], dados_basicos_autor['nome_referencia'])
                except:
                    print('Autor já inserido')

    def ajuste_autorias(self, autorias=None, id_autor=None):
        for autor in autorias:
            self.autoria_dao.delete_autor_nao_cadastrado(autor['idTrabalho'], autor['ordem'])
            self.autoria_dao.create_autor_cadastrado(id_autor,autor['idTrabalho'], autor['ordem'])



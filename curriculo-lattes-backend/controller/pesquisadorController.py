import json
from flask import request
from flask_cors import cross_origin
from flask_api import status
from dao.pesquisador_dao import PesquisadorDao
from dao.trabalho_dao import TrabalhoDao
from dao.nome_citacao_dao import NomeCitacaoDao
from model.pesquisador import Pesquisador
from utils.xml_manager import XmlManager
from flask import Blueprint

pesquisador_blueprint = Blueprint('pesquisador_blueprint', __name__)
pesquisador_dao = PesquisadorDao()
trabalho_dao = TrabalhoDao()
nome_citacao_dao = NomeCitacaoDao()

# Função para chamar a lista
@pesquisador_blueprint.route('/listar', methods=['GET'])
@cross_origin()
def get_all():
    pesquisadores = pesquisador_dao.get_all()
    return json.dumps([ob.__dict__ for ob in pesquisadores])

# Função para inserir os dados
@pesquisador_blueprint.route('/inserir/<codigo>/<id_instituto>', methods=['POST'])
@cross_origin()
def create(codigo, id_instituto):
    xml_file_name = f'{codigo}.xml'
    xml_manager = XmlManager()
    xml_names = xml_manager.get_all_xml_names()
    if xml_file_name in xml_names:
        xml_dictionary = xml_manager.read_xml_in_base_directory(xml_file_name)
        pesquisador_id = codigo
        pesquisador_nome = xml_dictionary['CURRICULO-VITAE']['DADOS-GERAIS']['@NOME-COMPLETO']
        #pesquisador_dao.create(pesquisador_id, pesquisador_nome, id_instituto)

        trabalhos = []
        artigos = []
        try:
            artigos = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['ARTIGOS-PUBLICADOS']['ARTIGO-PUBLICADO']
        except:
            print('Não há artigos publicados pelo pesquisador')
            artigos = []

        capitulos = []
        try:
            capitulos = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['LIVROS-E-CAPITULOS']['CAPITULOS-DE-LIVROS-PUBLICADOS']['CAPITULO-DE-LIVRO-PUBLICADO']
        except:
            print('Não há capítulos publicados pelo pesquisador')
            capitulos = []
        
        livros = []
        try:
            livros = xml_dictionary['CURRICULO-VITAE']['PRODUCAO-BIBLIOGRAFICA']['LIVROS-E-CAPITULOS']['LIVROS-PUBLICADOS-OU-ORGANIZADOS']['LIVRO-PUBLICADO-OU-ORGANIZADO']
        except:
            print('Não há livros publicados pelo pesquisador')
            livros = []

        for artigo in artigos:
            titulo = artigo['DADOS-BASICOS-DO-ARTIGO']['@TITULO-DO-ARTIGO']
            ano = artigo['DADOS-BASICOS-DO-ARTIGO']['@ANO-DO-ARTIGO']
            tipo = 'ARTIGO'
            print('Inserindo artigo ' + titulo)
            trabalho_dao.create(titulo, ano, tipo, pesquisador_id)

            artigo_id = trabalho_dao.get_last_inserted_id()
            for autor in artigo['AUTORES']:
                nome_citacao = autor['@NOME-PARA-CITACAO']
                nome_citacao_dao.create(nome_citacao, artigo_id)

        for capitulo in capitulos:
            titulo = capitulo['DADOS-BASICOS-DO-CAPITULO']['@TITULO-DO-CAPITULO-DO-LIVRO']
            ano = capitulo['DADOS-BASICOS-DO-CAPITULO']['@ANO']
            tipo = 'LIVRO'
            print('Inserindo capitulo ' + titulo)
            trabalho_dao.create(titulo, ano, tipo, pesquisador_id)

            capitulo_id = trabalho_dao.get_last_inserted_id()
            for autor in capitulo['AUTORES']:
                nome_citacao = autor['@NOME-PARA-CITACAO']
                nome_citacao_dao.create(nome_citacao, capitulo_id)

        for livro in livros:
            titulo = livro['DADOS-BASICOS-DO-LIVRO']['@TITULO-DO-LIVRO']
            ano = livro['DADOS-BASICOS-DO-LIVRO']['@ANO']
            tipo = 'LIVRO'
            print('Inserindo livro ' + titulo)
            trabalho_dao.create(titulo, ano, tipo, pesquisador_id)

            livro_id = trabalho_dao.get_last_inserted_id()
            for autor in livro['AUTORES']:
                nome_citacao = autor['@NOME-PARA-CITACAO']
                nome_citacao_dao.create(nome_citacao, capitulo_id)
        
        return 'Pesquisador cadastrado com sucesso', status.HTTP_201_CREATED
    else:
        return f'Não há arquivo com o código {codigo}', status.HTTP_404_NOT_FOUND

# Função para Deletar de acordo com o id
@pesquisador_blueprint.route('/deletar/<id>', methods=['DELETE'])
@cross_origin()
def delete(id):
    pesquisador_dao.delete(id)
    return json.dumps("Deletado com sucesso")

@pesquisador_blueprint.route('/filtrar/', methods=['GET'])
@cross_origin()
def filter():
    nomePesquisador = request.args.get('nomePesquisador')
    nomeInstituto = request.args.get('nomeInstituto')
    orderBy = request.args.get('orderBy')
    sort = request.args.get('sort')
    posicaoInicial = request.args.get('posicaoInicial')
    quantidadeItens = request.args.get('quantidadeItens')
    pesquisadores = pesquisador_dao.filter(nomePesquisador, nomeInstituto, orderBy, sort, posicaoInicial, quantidadeItens)
    return json.dumps([ob.__dict__ for ob in pesquisadores])


@pesquisador_blueprint.route('/arquivo/<codigo>', methods=['GET'])
@cross_origin()
def buscarArquivo(codigo):
    xml_file_name = f'{codigo}.xml'
    print(xml_file_name)
    xml_manager = XmlManager()
    xml_names = xml_manager.get_all_xml_names()
    if xml_file_name in xml_names:
        xml_dictionary = xml_manager.read_xml_in_base_directory(xml_file_name)
        pesquisador_nome = xml_dictionary['CURRICULO-VITAE']['DADOS-GERAIS']['@NOME-COMPLETO']
        return {'nome': pesquisador_nome}, status.HTTP_200_OK
    else:
        return f'Não há arquivo com o código {codigo}', status.HTTP_404_NOT_FOUND

@pesquisador_blueprint.route('/contar/', methods=['GET'])
@cross_origin()
def count():
    nomePesquisador = request.args.get('nomePesquisador')
    nomeInstituto = request.args.get('nomeInstituto')
    totalPesquisadores = pesquisador_dao.count(nomePesquisador, nomeInstituto)
    return {'totalPesquisadores': totalPesquisadores}

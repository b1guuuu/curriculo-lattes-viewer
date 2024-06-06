import json
from flask import request
from flask_cors import cross_origin
from flask_api import status
from dao.pesquisador_dao import PesquisadorDao
from dao.autoria_dao import AutoriaDao
from model.pesquisador import Pesquisador
from utils.xml_manager import XmlManager
from utils.trabalho_manager import TrabalhoManager
from flask import Blueprint
from mysql.connector.errors import IntegrityError

pesquisador_blueprint = Blueprint('pesquisador_blueprint', __name__)
pesquisador_dao = PesquisadorDao()
autoria_dao = AutoriaDao()

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
        pesquisador_nome = xml_dictionary['CURRICULO-VITAE']['DADOS-GERAIS']['@NOME-COMPLETO'].lower().title()
        pesquisador_nome_referencia = xml_dictionary['CURRICULO-VITAE']['DADOS-GERAIS']['@NOME-EM-CITACOES-BIBLIOGRAFICAS'].split(';')[0].lower().title()

        try:
            pesquisador_dao.create(pesquisador_id, pesquisador_nome, pesquisador_nome_referencia, id_instituto)
        except IntegrityError:
            return f'Já existe um pesquisador com código {codigo}', status.HTTP_400_BAD_REQUEST
        except:
            return 'Erro ao inserir pesquisador', status.HTTP_500_INTERNAL_SERVER_ERROR
        
        trabalho_manager = TrabalhoManager()

        trabalho_manager.create_trabalhos_tipo(xml_dictionary, 'ARTIGO')
        try:
            print('')
        except Exception as e:
            print(e)
            return 'Erro ao inserir artigos',status.HTTP_500_INTERNAL_SERVER_ERROR
        try:
            trabalho_manager.create_trabalhos_tipo(xml_dictionary, 'CAPITULO')
        except:
            return 'Erro ao inserir capitulos',status.HTTP_500_INTERNAL_SERVER_ERROR
        try:
            trabalho_manager.create_trabalhos_tipo(xml_dictionary, 'LIVRO')
        except:
            return 'Erro ao inserir livros',status.HTTP_500_INTERNAL_SERVER_ERROR

        return f'Pesquisador cadastrado com sucesso', status.HTTP_201_CREATED
    else:
        return f'Não há arquivo com o código {codigo}', status.HTTP_404_NOT_FOUND

# Função para Deletar de acordo com o id
@pesquisador_blueprint.route('/deletar/<id>', methods=['DELETE'])
@cross_origin()
def delete(id):
    try:
        autoria_dao.delete_trabalhos_pesquisador(id)
        pesquisador_dao.delete(id)
        return f'Pesquisador deletado com sucesso', status.HTTP_204_NO_CONTENT
    except:
        return 'Erro ao excluir pesquisador',status.HTTP_500_INTERNAL_SERVER_ERROR


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

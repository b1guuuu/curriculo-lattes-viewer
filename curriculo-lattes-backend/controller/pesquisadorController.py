import json
from flask import request
from flask_cors import cross_origin
from flask_api import status
from dao.pesquisador_dao import PesquisadorDao
from model.pesquisador import Pesquisador
from utils.xml_manager import XmlManager
from flask import Blueprint

pesquisador_blueprint = Blueprint('pesquisador_blueprint', __name__)
pesquisador_dao = PesquisadorDao()

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
    print(xml_file_name)
    xml_manager = XmlManager()
    xml_names = xml_manager.get_all_xml_names()
    if xml_file_name in xml_names:
        xml_dictionary = xml_manager.read_xml_in_base_directory(xml_file_name)
        pesquisador_id = xml_dictionary['CURRICULO-VITAE']['@NUMERO-IDENTIFICADOR']
        pesquisador_nome = xml_dictionary['CURRICULO-VITAE']['DADOS-GERAIS']['@NOME-COMPLETO']
        print(pesquisador_id)
        print(pesquisador_nome)
        print(id_instituto)
        pesquisador_dao.create(pesquisador_id, pesquisador_nome, id_instituto)
        return 'Pesquisador cadastrado com sucesso', status.HTTP_201_CREATED
    else:
        return f'Não há arquivo com o código {codigo}', status.HTTP_404_NOT_FOUND
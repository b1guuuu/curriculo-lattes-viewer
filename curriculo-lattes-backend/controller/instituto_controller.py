import json
from flask import request
from flask_cors import cross_origin
from dao.instituto_dao import InstitutoDao
from model.instituto import Instituto
from flask import Blueprint

instituto_blueprint = Blueprint('instituto_blueprint', __name__)
instituto_dao = InstitutoDao()

# Função para chamar a lista
@instituto_blueprint.route('/listar', methods=['GET'])
@cross_origin()
def get_all():
    institutos = instituto_dao.get_all()
    return json.dumps([ob.__dict__ for ob in institutos])

# Função para inserir os dados
@instituto_blueprint.route('/inserir/<nome>/<acronimo>', methods=['POST'])
@cross_origin()
def create(nome, acronimo):
    instituto_dao.create(nome, acronimo)
    return json.dumps("Inserido com sucesso")

# Função para Deletar de acordo com o id
@instituto_blueprint.route('/deletar/<id>', methods=['DELETE'])
@cross_origin()
def delete(id):
    instituto_dao.delete(id)
    return json.dumps("Deletado com sucesso")

@instituto_blueprint.route('/atualizar/<id>/<nome>/<acronimo>', methods=['PUT'])
@cross_origin()
def update(id, nome, acronimo):
    instituto_dao.update(id, nome, acronimo)
    return json.dumps("Atualizado com sucesso")

@instituto_blueprint.route('/filtrar/', methods=['GET'])
@cross_origin()
def filter():
    nome = request.args.get('nome')
    acronimo = request.args.get('acronimo')
    orderBy = request.args.get('orderBy')
    sort = request.args.get('sort')
    posicaoInicial = request.args.get('posicaoInicial')
    quantidadeItens = request.args.get('quantidadeItens')
    institutos = instituto_dao.filter(nome, acronimo, orderBy, sort, posicaoInicial, quantidadeItens)
    return json.dumps([ob.__dict__ for ob in institutos])

@instituto_blueprint.route('/contar/', methods=['GET'])
@cross_origin()
def count():
    nome = request.args.get('nome')
    acronimo = request.args.get('acronimo')
    totalInstitutos = instituto_dao.count(nome, acronimo)
    return {'totalInstitutos': totalInstitutos}
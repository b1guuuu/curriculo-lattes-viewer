import json
from flask import request
from flask_cors import cross_origin
from dao.instituto_dao import InstitutoDao
from model.instituto import Instituto
from base_controller import app

instituto_dao = InstitutoDao()

# Função para chamar a lista
@app.route('/instituto/listar', methods=['GET'])
@cross_origin()
def get_all():
    institutos_mysql = instituto_dao.getAll()
    return json.dumps([ob.__dict__ for ob in institutos_mysql])

# Função para inserir os dados
@app.route('/instituto/inserir/<nome>/<acronimo>', methods=['POST'])
@cross_origin()
def create(nome, acronimo):
    instituto_dao.create(nome, acronimo)
    return json.dumps("Inserido com sucesso")

# Função para Deletar de acordo com o id
@app.route('/instituto/deletar/<id>', methods=['DELETE'])
@cross_origin()
def delete(id):
    instituto_dao.delete(id)
    return json.dumps("Deletado com sucesso")

@app.route('/instituto/atualizar/<id>/<nome>/<acronimo>', methods=['PUT'])
@cross_origin()
def update(id, nome, acronimo):
    instituto_dao.update(id, nome, acronimo)
    return json.dumps("Atualizado com sucesso")

@app.route('/instituto/filtrar/', methods=['GET'])
@cross_origin()
def filter():
    nome = request.args.get('nome')
    acronimo = request.args.get('acronimo')
    orderBy = request.args.get('orderBy')
    sort = request.args.get('sort')
    institutos_mysql = instituto_dao.filter(nome, acronimo, orderBy, sort)
    return json.dumps([ob.__dict__ for ob in institutos_mysql])

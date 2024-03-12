import json
from flask import Flask
from flask_cors import CORS, cross_origin
from model.institutoModel import *

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


# Função para chamar a lista
@app.route('/instituto/listar', methods=['GET']) # utilize esse caminho para
@cross_origin()
def json_list():
    return json.dumps(BuscarInstituto())

# Função para incerir os dados
@app.route('/instituto/inserir/<nome>/<acronimo>', methods=['POST']) # utilize esse caminho para
@cross_origin()
def inserir(nome, acronimo):
    CreateInstituto(nome, acronimo)
    return json.dumps("Inserido com sucesso")

# Função para Deletar de acordo com o id
@app.route('/instituto/deletar/<id>', methods=['DELETE']) # utilize esse caminho para
@cross_origin()
def deletar(id):
    DeletarInstituto(id)
    return json.dumps("Deletado com sucesso")

app.run()
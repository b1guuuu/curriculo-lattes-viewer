import json
from flask import Flask
from model.institutoModel import *


app = Flask(__name__)


# Função para chamar a lista
@app.route('/listar') # utilize esse caminho para
def json_list():
    return json.dumps(BuscarInstituto())

# Função para incerir os dados
@app.route('/inserir/<nome>/<acronimo>') # utilize esse caminho para
def inserir(nome, acronimo):
    CreateInstituto(nome, acronimo)
    return json.dumps("Inserido com sucesso")

# Função para Deletar de acordo com o id
@app.route('/deletar/<id>') # utilize esse caminho para
def deletar(id):
    DeletarInstituto(id)
    return json.dumps("Deletado com sucesso")

app.run()
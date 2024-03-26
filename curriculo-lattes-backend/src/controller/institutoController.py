import json
from src.model.institutoModel import instituto_model
from routes import apps

# Função para chamar a lista
class instituto_Controller:
    @apps.route('/instituto/listar', methods=['GET']) # utilize esse caminho para
    @cross_origin()
    def json_list():
        return json.dumps(BuscarInstituto())

    # Função para incerir os dados
    @apps.route('/instituto/inserir/<nome>/<acronimo>', methods=['POST']) # utilize esse caminho para
    @cross_origin()
    def inserir(nome, acronimo):
        CreateInstituto(nome, acronimo)
        return json.dumps("Inserido com sucesso")

    # Função para Deletar de acordo com o id
    @apps.route('/instituto/deletar/<id>', methods=['DELETE']) # utilize esse caminho para
    @cross_origin()
    def deletar(id):
        DeletarInstituto(id)
        return json.dumps("Deletado com sucesso")

    @apps.route('/instituto/atualizar/<id>/<nome>/<acronimo>', methods=['PUT']) # utilize esse caminho para
    @cross_origin()
    def atualizar(id, nome, acronimo):
        UpdateInstituto(id, nome, acronimo)
        return json.dumps("Atualizado com sucesso")


    @apps.route('/instituto/filtrar/', methods=['GET']) # utilize esse caminho para
    @cross_origin()
    def filtrar():
        nome = request.args.get('nome')
        acronimo = request.args.get('acronimo')
        orderBy = request.args.get('orderBy')
        sort = request.args.get('sort')
        return json.dumps(FilterInstituto(nome, acronimo, orderBy, sort))
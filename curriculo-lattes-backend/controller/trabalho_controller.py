import json
from flask import Blueprint
from flask import request
from flask_cors import cross_origin


from dao.trabalho_dao import TrabalhoDao

trabalho_blueprint = Blueprint('trabalho_blueprint', __name__)
trabalho_dao = TrabalhoDao()

@trabalho_blueprint.route('/listar', methods=['GET'])
@cross_origin()
def get_all():
    trabalhos = trabalho_dao.get_all()
    return json.dumps([ob.__dict__ for ob in trabalhos])

@trabalho_blueprint.route('/filtrar', methods=['GET'])
@cross_origin()
def get_all_citacoes():
    try:
        ano_inicio = request.args.get('anoInicio')
        ano_fim = request.args.get('anoFim')
        id_instituto = request.args.get('idInstituto')
        id_pesquisador = request.args.get('idPesquisador')
        tipo = request.args.get('tipo')
        order_by = request.args.get('orderBy')
        sort = request.args.get('sort')
        posicao_inicial = request.args.get('posicaoInicial')
        quantidade_itens = request.args.get('quantidadeItens')
        trabalhos = trabalho_dao.filter(ano_inicio, ano_fim, id_instituto, id_pesquisador, tipo, order_by, sort, posicao_inicial, quantidade_itens)
        return trabalhos
    except Exception as e:
        print('exception')
        print(e)
        return json.dumps([])
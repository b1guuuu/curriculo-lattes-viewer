import json
from flask import Blueprint
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
        print('filtrar')
        trabalhos = trabalho_dao.filter()
        return trabalhos
    except Exception as e:
        print('exception')
        print(e)
        return json.dumps([])
import json
import os
import sys
from flask import request
from flask import Blueprint
from flask import send_file
from flask_cors import cross_origin
from flask_api import status
from utils.graph_manager import GraphManager

grafo_blueprint = Blueprint('grafo_blueprint', __name__)

@grafo_blueprint.route('/', methods=['POST'])
@cross_origin()
def gerarGrafo():
    options = request.json
    print(options)
    if options == None:
        return 'Não foi enviado um corpo JSON correto', status.HTTP_400_BAD_REQUEST
    
    graph_manager = GraphManager()

    if options['vertice'] == 'Instituto':
        graph_manager.gerar_grafo_vertice_instituto(
            ids=options['institutos'],
            pesquisadores=options['pesquisadores'],
            regras=options['regras'],
            tipo_producao=options['tipoProducao'].upper()
        )
    else:
        graph_manager.gerar_grafo_vertice_pesquisador(
            institutos=options['institutos'],
            ids=options['pesquisadores'],
            regras=options['regras'],
            tipo_producao=options['tipoProducao'].upper()
        )
    
    if 'env' in os.path.dirname(os.path.abspath(sys.argv[0])):
        return send_file(os.path.join('/home/igor/HD/Documents/FeMASS/Disciplinas/ds1/curriculo-lattes-viewer/curriculo-lattes-backend/', 'Graph.png'))
    else:
        return send_file(os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), 'Graph.png'))
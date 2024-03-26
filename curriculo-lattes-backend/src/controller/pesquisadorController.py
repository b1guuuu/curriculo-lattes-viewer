from model.pesquisadorModel import pesquisador_model
from routes import apps
from flask import Response
import os
import xml.etree.ElementTree as ET
import json

class pesquisador_Controler():
    
    @apps.route('/pesquisador/pesquisar/<id>') # utilize esse caminho para
    @cross_origin()
    def lerCurriculo(id=None):
        diretorio_xml = 'Curriculos_XML'
        # loop para ler todos os xml
        diretorio_Do_XML_Completo=(f'{os.getcwd()}\\{diretorio_xml}\\')
        listRang = os.listdir('Curriculos_XML')
        return Response(json.dumps(id))

        # for curriculo_xml in listRang:
            
        #     if curriculo_xml.endswith('.xml'):
        #         caminho_arquivo_xml = os.path.join(diretorio_xml, curriculo_xml)

        #         tree = ET.parse(caminho_arquivo_xml)
        #         root = tree.getroot()

        #         for elemento in root:
        #             return json.dumps(elemento.tag)
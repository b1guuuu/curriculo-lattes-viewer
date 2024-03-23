import os
import xml.etree.ElementTree as ET
import json
from flask import Flask
from flask import request
from flask_cors import CORS, cross_origin
#from model.PesquisadorModel import *

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


def LerCurriculo():
    diretorio_xml = './Curriculos_XML'
    cont = 0
    # loop para ler todos os xml
    for curriculo_xml in os.listdir(diretorio_xml):
        if curriculo_xml.endswith('.xml'):
            caminho_arquivo_xml = os.path.join(diretorio_xml, curriculo_xml)

            tree = ET.parse(caminho_arquivo_xml)
            root = tree.getroot()

            for elemento in root:
                print(elemento.tag)



LerCurriculo()
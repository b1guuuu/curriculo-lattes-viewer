# inicializa o pacote
from flask import Flask
from flask_cors import CORS

from controller.instituto_controller import instituto_blueprint
from controller.pesquisador_controller import pesquisador_blueprint
from controller.trabalho_controller import trabalho_blueprint

app = Flask(__name__)
app.register_blueprint(instituto_blueprint, url_prefix='/instituto')
app.register_blueprint(pesquisador_blueprint, url_prefix='/pesquisador')
app.register_blueprint(trabalho_blueprint, url_prefix='/trabalho')
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

try:
    if __name__ == "__main__":
        app.run()
except Exception as e:
    print(e)
    raise
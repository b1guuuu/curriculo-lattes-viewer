# inicializa o pacote
from controller.instituto_controller import instituto_blueprint
from controller.pesquisadorController import pesquisador_blueprint
from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
app.register_blueprint(instituto_blueprint, url_prefix='/instituto')
app.register_blueprint(pesquisador_blueprint, url_prefix='/pesquisador')
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

if __name__ == "__main__":
    app.run()
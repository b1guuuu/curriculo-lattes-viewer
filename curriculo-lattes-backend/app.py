# inicializa o pacote
from flask import Flask, request, Response
from flask_cors import CORS

from controller.instituto_controller import instituto_blueprint
from controller.pesquisador_controller import pesquisador_blueprint
from controller.trabalho_controller import trabalho_blueprint
from controller.grafo_controller import grafo_blueprint

app = Flask(__name__)
app.register_blueprint(instituto_blueprint, url_prefix='/instituto')
app.register_blueprint(pesquisador_blueprint, url_prefix='/pesquisador')
app.register_blueprint(trabalho_blueprint, url_prefix='/trabalho')
app.register_blueprint(grafo_blueprint, url_prefix='/grafo')
CORS(app)

@app.before_request
def handle_preflight():
    if request.method == "OPTIONS":
        res = Response()
        res.headers['X-Content-Type-Options'] = '*'
        return res

try:
    if __name__ == "__main__":
        app.run()
except Exception as e:
    print(e)
    raise
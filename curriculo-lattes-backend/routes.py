from flask import Flask
from flask import request
from flask_cors import CORS, cross_origin

apps = Flask(__name__)
apps.run()
cors = CORS(apps)
apps.config['CORS_HEADERS'] = 'Content-Type'

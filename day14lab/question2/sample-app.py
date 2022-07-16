import redis
from flask import Flask

app = Flask(app)
cache = redis.Redis(host='redis', port=6379)

def hello():
	return 'Hello World: this is a test docker page'
	
if app == "_main_":
	app.run(host="0.0.0.0", debug=True)
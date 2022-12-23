from flask import Flask, request
import subprocess
import logging
app = Flask(__name__)
@app.route('/')
def my_app():
    logging.basicConfig(filename="log", encoding='utf-8', level=logging.DEBUG)
    logging.info("Hello, world")
    return request
if __name__ == '__main__':
    app.run()

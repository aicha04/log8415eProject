from flask import Flask, request
import logging
app = Flask(__name__)
@app.route('/')
def my_app():
    logging.basicConfig(filename="/home/admin/log.txt", encoding='utf-8', level=logging.DEBUG)
    logging.info(request)
    return "hello"
if __name__ == '__main__':
    app.run()

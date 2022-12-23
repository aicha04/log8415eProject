from flask import Flask, request
import subprocess
app = Flask(__name__)
@app.route('/')
def my_app():
    print(request)
if __name__ == '__main__':
    app.run()

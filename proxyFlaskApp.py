from flask import Flask, request
import logging
# import MySQLdb
app = Flask(__name__)
@app.route('/')
def my_app():
    logging.basicConfig(filename="/home/admin/log.txt", encoding='utf-8', level=logging.DEBUG)
    logging.info(request)
    # db = MySQLdb.connect(host="172.31.28.42", user="user",password="password", database="sakila")
    # cursor = db.cursor()
    # query=request.get_json()['query']
    # logging.info(query)
    # cursor.execute(query)
    # result = jsonify(data=cursor.fetchall())
    # logging.info(result)

    return f"hello"
if __name__ == '__main__':
    app.run()

from flask import Flask, request, jsonify
import logging
import MySQLdb
from flask_mysqldb import MySQL

app = Flask(__name__)
mysql = MySQL(app)
@app.route('/')
def my_app():
    logging.basicConfig(filename="/home/admin/log.txt", encoding='utf-8', level=logging.DEBUG)
    logging.info(request)
    db = MySQLdb.connect(host="172.31.5.98", user="user",password="password", database="sakila")
    cursor = db.cursor()
    query=request.get_json()['query']
    cursor.execute(query)
    result = jsonify(data=cursor.fetchall())
    logging.info("here2:", result)

    return result
if __name__ == '__main__':
    app.run()

from flask import Flask, request, jsonify
import logging
import MySQLdb
app = Flask(__name__)
@app.route('/')
def my_app():
    logging.basicConfig(filename="/home/admin/log.txt", encoding='utf-8', level=logging.DEBUG)
    logging.info(request)
    db = MySQLdb.connect(host="localhost", user="user",password="password", database="sakila")
    cursor = db.cursor()
    query=request.get_json()['query']
    logging.info(query)
    cursor.execute(query)
    result = jsonify(data=cursor.fetchall())
    
    logging.info(result)

    return "hello"
if __name__ == '__main__':
    app.run()

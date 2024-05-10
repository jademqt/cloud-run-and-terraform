from flask import Flask, render_template, request, jsonify
import os
import mysql.connector
from dotenv import load_dotenv
from flask_cors import CORS

load_dotenv()

app = Flask(__name__)
CORS(app)

def connect_db():
    return mysql.connector.connect(
        host=os.getenv("INSTANCE_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME"),
        port=os.getenv("DB_PORT")
    )

@app.route('/')
def index():
    return render_template('index.html')

# Route pour obtenir les relevés de CO2
@app.route('/co2', methods=['GET'])
def get_co2():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM co2_measurements")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

# Route pour obtenir les relevés de PM2.5
@app.route('/pm25', methods=['GET'])
def get_pm25():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM pm25_measurements")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

# Route pour obtenir les relevés d'ozone
@app.route('/ozone', methods=['GET'])
def get_ozone():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM ozone_measurements")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

# Endpoint pour ajouter un relevé de PM2.5
@app.route('/add_pm25', methods=['POST'])
def add_pm25():
    if request.method == 'POST':
        data = request.json
        conn = connect_db()
        cur = conn.cursor()
        cur.execute("INSERT INTO pm25_measurements (location, date, pm25_level) VALUES (%s, %s, %s)", (data['location'], data['date'], data['pm25_level']))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "PM2.5 data added successfully"}), 200

# Endpoint pour ajouter un relevé d'ozone
@app.route('/add_ozone', methods=['POST'])
def add_ozone():
    if request.method == 'POST':
        data = request.json
        conn = connect_db()
        cur = conn.cursor()
        cur.execute("INSERT INTO ozone_measurements (location, date, ozone_level) VALUES (%s, %s, %s)", (data['location'], data['date'], data['ozone_level']))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Ozone data added successfully"}), 200

@app.route('/add_co2', methods=['POST'])
def add_co2():
    if request.method == 'POST':
        data = request.json
        conn = connect_db()
        cur = conn.cursor()
        cur.execute("INSERT INTO co2_measurements (location, date, co2_level) VALUES (%s, %s, %s)", (data['location'], data['date'], data['co2_level']))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "CO2 data added successfully"}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

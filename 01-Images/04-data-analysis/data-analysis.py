from flask import Flask, jsonify
import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

def connect_db():
    return mysql.connector.connect(
        host=os.getenv("INSTANCE_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME"),
        port=os.getenv("DB_PORT")
    )

def calculate_average_by_location(table_name, column_name):
    conn = connect_db()
    cursor = conn.cursor()

    # Exécuter la requête SQL pour calculer la moyenne par localisation
    query = f"SELECT location, AVG({column_name}) FROM {table_name} GROUP BY location"
    cursor.execute(query)
    averages = cursor.fetchall()

    # Fermer la connexion
    cursor.close()
    conn.close()

    return averages


@app.route('/average/co2')
def average_co2():
    averages = calculate_average_by_location("co2_measurements", "co2_level")
    data = {location: average for location, average in averages}
    print (jsonify(data))

@app.route('/average/pm25')
def average_pm25():
    averages = calculate_average_by_location("pm25_measurements", "pm25_level")
    data = {location: average for location, average in averages}
    print (jsonify(data))

@app.route('/average/ozone')
def average_ozone():
    averages = calculate_average_by_location("ozone_measurements", "ozone_level")
    data = {location: average for location, average in averages}
    print (jsonify(data))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8090)

import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

# Fonction pour se connecter à la base de données
def connect_db():
    return mysql.connector.connect(
        host=os.getenv("INSTANCE_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME"),
        port=os.getenv("DB_PORT")
    )

# Fonction pour vérifier et supprimer les valeurs aberrantes dans une table donnée
def remove_aberrant_values(table_name, column_name, threshold_min, threshold_max):
    conn = connect_db()
    cursor = conn.cursor()

    # Supprimer les valeurs inférieures à threshold_min
    cursor.execute(f"DELETE FROM {table_name} WHERE {column_name} < %s", (threshold_min,))
    deleted_min_count = cursor.rowcount
    print(f"Removed {deleted_min_count} values below threshold {threshold_min} from {table_name}")

    # Supprimer les valeurs supérieures à threshold_max
    cursor.execute(f"DELETE FROM {table_name} WHERE {column_name} > %s", (threshold_max,))
    deleted_max_count = cursor.rowcount
    print(f"Removed {deleted_max_count} values above threshold {threshold_max} from {table_name}")

    # Valider les modifications
    conn.commit()

    cursor.close()
    conn.close()


# Appel de la fonction pour supprimer les valeurs aberrantes dans chaque table
remove_aberrant_values("co2_measurements", "co2_level", float(os.getenv("CO2_MIN")), float(os.getenv("CO2_MAX")))  
remove_aberrant_values("pm25_measurements", "pm25_level", float(os.getenv("PEM25_MIN")), float(os.getenv("PEM25_MAX"))) 
remove_aberrant_values("ozone_measurements", "ozone_level", float(os.getenv("OZONE_MIN")), float(os.getenv("OZONE_MAX"))) 

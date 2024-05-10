import requests
import random
from dotenv import load_dotenv
import os

load_dotenv()

# URL des endpoints pour ajouter des relevés
CR_URL = os.getenv("CR_URL")
CO2_URL = f"{CR_URL}/add_co2"
PM25_URL = f"{CR_URL}/add_pm25"
OZONE_URL = f"{CR_URL}/add_ozone"

# Liste des localisations possibles
LOCATIONS = ["Centre-ville", "Parc urbain", "Zone industrielle"]

# Fonction pour générer des valeurs aléatoires avec parfois des valeurs aberrantes
def generate_random_value(mean, std_dev, max_aberration):
    value = random.gauss(mean, std_dev)
    if random.random() < 0.1:  # 10% de chance d'avoir une valeur aberrante
        value += random.uniform(-max_aberration, max_aberration)
    return max(0, value)

# Fonction pour générer une localisation aléatoire parmi la liste des localisations possibles
def generate_random_location():
    return random.choice(LOCATIONS)

if __name__ == "__main__":
    # Données des relevés à ajouter
    co2_data = {
        "location": generate_random_location(),
        "date": "2024-04-07",
        "co2_level": generate_random_value(400, 50, 100)  # Moyenne: 400, Écart-type: 50, Aberration maximale: 100
    }

    pm25_data = {
        "location": generate_random_location(),
        "date": "2024-04-07",
        "pm25_level": generate_random_value(10, 5, 10)  # Moyenne: 10, Écart-type: 5, Aberration maximale: 10
    }

    ozone_data = {
        "location": generate_random_location(),
        "date": "2024-04-07",
        "ozone_level": generate_random_value(80, 20, 50)  # Moyenne: 80, Écart-type: 20, Aberration maximale: 50
    }

    # Envoi de la requête POST pour ajouter le relevé de CO2
    response = requests.post(CO2_URL, json=co2_data)
    print("CO2 Data Added:", response.json())

    # Envoi de la requête POST pour ajouter le relevé de PM2.5
    response = requests.post(PM25_URL, json=pm25_data)
    print("PM2.5 Data Added:", response.json())

    # Envoi de la requête POST pour ajouter le relevé d'ozone
    response = requests.post(OZONE_URL, json=ozone_data)
    print("Ozone Data Added:", response.json())

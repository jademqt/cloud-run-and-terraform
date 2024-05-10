## Présentation de chacun des dossiers

### 02- data-collector (Image Docker)
API Rest, Python Flask :
+ `/` : Affiche une page HTML qui récupère les données de la base de données en appelant les routes (`GET`) de cette application Flask.
+ `GET` - renvoie en format `JSON` les données :
    - `/co2` : récupère les données de la table `co2_measurements` pour pouvoir les afficher dans la page html.
    - `/pm25` : récupère les données de la table `pm25_measurements` (particules fines) pour pouvoir les afficher dans la page html.
    - `/ozone` : récupère les données de la table `ozone_measurements` pour pouvoir les afficher dans la page html.
+ `POST` - envoie en format `JSON` les données :
    - `/add_pm25` : ajoute une entrée à la table `pm25_measurements` (entrée générée aléatoirement cf. dossier 03) 
    - `/add_co2` : ajoute une entrée à la table `co2_measurements` (entrée générée aléatoirement cf. dossier 03) 
    - `/add_ozone` : ajoute une entrée à la table `ozone_measurements` (entrée générée aléatoirement cf. dossier 03) 

### 03- create-data (Image Docker)
Script Python qui génère aléatoirement des données et les insère dans la base grâce aux endpoints de l'API Rest définie dans le dossier 02. 

Ce scipt permet de simuler des capteurs placés à 3 endroits dans une ville :
+ "Centre-ville"
+ "Parc urbain"
+ "Zone industrielle"

Pour rappel les valeurs ne sont pas réalistes.

### 04- data-analysis (Image Docker)

API Rest, Python Flask, qui a pour but d'analyser les données récoltées : 
+ `/average/co2` : renvoie un JSON de la moyenne de tous les relevés de CO2 de chaque localisation.  
+ `/average/pm25` : renvoie un JSON de la moyenne de tous les relevés de pm25 de chaque localisation.
+ `/average/ozone` : renvoie un JSON de la moyenne de tous les relevés d'ozone de chaque localisation.

### 05- data-cleanup (Image Docker)
Script Python qui vient supprimer toutes les lignes où les valeurs semblent non réalistes (capteurs défaillants par exemple), pour ne pas fausser l'étude des relevés. 

## Commandes utiles pour tester localement le code
### Environnement virtuel Python 
Création d'un environnement virtuel :
```bash
python3 -m venv venv
```
Activation de cet environnement :
```bash
. venv/bin/activate
```
Installations des paquets nécessaires :

```bash
pip install -r requirements.txt
```

### Build et run des images localement

```bash
docker build -t {nom_image}:{tag} .
docker run -p {port_hôte}:{port_conteneur} {nom_image}:{tag}
```
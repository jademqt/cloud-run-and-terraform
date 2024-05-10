Cloud SQL Proxy [un exemple d'utilisation de sidecar](https://cloud.google.com/blog/products/serverless/cloud-run-now-supports-multi-container-deployments?hl=en). Voir la [documentation GitHub officielle.](https://github.com/GoogleCloudPlatform/cloud-sql-proxy/tree/main/examples/multi-container/ruby).

Le Cloud SQL Auth Proxy offre une sécurité renforcée pour les connexions à votre base de données Cloud SQL, chiffrant automatiquement le trafic avec TLS 1.3 et un cryptage AES 256 bits, sans nécessiter de gestion manuelle des certificats SSL. Il simplifie également l'authentification en utilisant les autorisations IAM pour contrôler l'accès aux instances Cloud SQL, éliminant ainsi le besoin d'adresses IP statiques. De plus, il prend en charge l'authentification de la base de données IAM avec rafraîchissement automatique des jetons d'accès OAuth 2.0 en option. Enfin, le proxy utilise la connectivité IP existante et doit être placé sur une ressource ayant accès au même réseau VPC que l'instance pour se connecter via une IP privée.

### 1. Créer une base MySQL
### 2. Création du conteneur d'entrée qui doit se connecter au proxy en utilisant l'adresse 127.0.0.1:3306 (adresse du sidecar)

documentation [connexion au proxy](https://cloud.google.com/sql/docs/postgres/connect-auth-proxy#expandable-1)

### 3. Build du conteneur d'entrée
Les env sont : 
+ YOUR_PROJECT_ID
+ DB_USER
+ DB_PASS
+ DB_NAME
+ INSTANCE_CONNECTION_NAME 

### 4. SideCar
```bash
image: gcr.io/cloud-sql-connectors/cloud-sql-proxy:latest
   # Ensure the port number on the --port argument matches the value of
             # the DB_PORT env var on the my-app container.
             - "--port=5432"
             - "<INSTANCE_CONNECTION_NAME>"
```

## 01- db-and-vpc-creation
La commande suivante permet de créer l'instance Cloud SQL, le VPC et le connecteur. 

```bash
/.create-db-and-vpc.sh 
```

Une fois l'instance MySQL présente dans le projet GCP nous créons :
+ Une base 
+ Des tables
+ Des entrées dans ces tables

```bash
mysql -h {ip_instance_cloud_sql} -u {user} -p {nom_base_de_donnees} < create_db.sql 
```

Le mot mot de passe de l'instance Cloud SQL vous sera demandé.
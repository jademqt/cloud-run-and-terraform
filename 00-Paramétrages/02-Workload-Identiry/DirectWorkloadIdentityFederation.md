# Mise en place de l'authentification sans JSON
GCP recommande d'utiliser la méthode "Direct Workload Identity Federation" pour s'authentifier à son compte GCP pendant une GitHub action.
Documentation : [ici](https://github.com/google-github-actions/auth?tab=readme-ov-file#setup)

Les noms suivants que vous retrouverez dans les parties suivantes sont à remplacer :
+ $ID_PROJECT
+ $GITHUB_REPO_NAME
+ $IAM_POOL_NAME
+ $IAM_POOL_DISPLAY_NAME
+ $IAM_POOL_ID
+ $IAM_POOL_PROVIDER_NAME
+ $IAM_POOL_PROVIDER_DISPLAY_NAME

 ## 1. Création d'une Workload Identity Pool
Cela créé une pool dans "IAM & Admin > Workload Identiy Federation" :
 ```bash
gcloud iam workload-identity-pools create "$IAM_POOL_NAME" \
  --project=$ID_PROJECT \
  --location="global" \
  --display-name="$IAM_POOL_DISPLAY_NAME"
 ```

 On récupère l'id de la pool ($IAM_POOL_ID) avec la commande :
  ```bash 
gcloud iam workload-identity-pools describe "$IAM_POOL_NAME" \
  --project=$ID_PROJECT \
  --location="global" \
  --format="value(name)"

  # Valeur de retour ($IAM_POOL_ID): 
  projects/$ID_PROJECT_NUMBER/locations/global/workloadIdentityPools/$IAM_POOL_NAME
  ```


## 2. Création d'un Workload Identity Provider

Il est important de mettre le flag `--attribute-condition` pour restreindre l'accès. 

Cf. ce [site](https://medium.com/@bbeesley/notes-on-workload-identity-federation-from-github-actions-to-google-cloud-platform-7a818da2c33e) pour des informations très utiles sur les CEL.

Pour information, OIDC (OpenID Connect) est un protocol d'authentification qui fonctionne au dessus du framework OAuth 2.0 permettant aux utilisateurs d'utiliser du SSO pour accéder à des ressources stockées chez un provider (comme GCP).

```bash
gcloud iam workload-identity-pools providers create-oidc "$IAM_POOL_PROVIDER_NAME" \
  --project=$ID_PROJECT \
  --location="global" \
  --workload-identity-pool="$IAM_POOL_NAME" \
  --display-name="$IAM_POOL_PROVIDER_DISPLAY_NAME" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository == '$GITHUB_REPO_NAME'" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```
une fois créé on trouve le provider "$IAM_POOL_PROVIDER_DISPLAY_NAME" dans "IAM & Admin > Workload Identiy Federation > $IAM_POOL_DISPLAY_NAME".

Nous pouvons extraire le nom de cette ressource avec la commande :
```bash
gcloud iam workload-identity-pools providers describe "$IAM_POOL_PROVIDER_NAME" \
  --project=$ID_PROJECT \
  --location="global" \
  --workload-identity-pool="$IAM_POOL_NAME" \
  --format="value(name)"

  # Valeur de retour
  projects/$ID_PROJECT_NUMBER/locations/global/workloadIdentityPools/$IAM_POOL_NAME/providers/$GITHUB_REPO_NAME
```

## 3. Ajout des droits nécessaires
Pour cela nous allons créer un script bash qui permet d'attribuer des droits à la pool créée précédemment ($IAM_POOL_NAME). Il faut donc exécuter le script `give_rights.sh` avant le lancement du workflow la première fois.

Exemple de code retrouvé dans le script en question : 
```bash
gcloud projects add-iam-policy-binding $PROJECT_ID --member="principalSet://iam.googleapis.com/$IAM_POOL_ID/attribute.repository/$GITHUB_REPO_NAME"  --role='roles/storage.admin'
```


## Adaptation de la CI (fichier `yaml`)

Changer la partie suivante, utilisée pour se connecter avec le JSON :
```yaml
 - name: Checkout
        uses: actions/checkout@v3

      - name: gcp authentication
        uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GOOGLE_CREDENTIALS }}

      - name: GCP account credentials
        uses: google-github-actions/setup-gcloud@v1
        with:
          service_account_key: ${{ secrets.GOOGLE_CREDENTIALS }}
          project_id: ${{ env.PROJECT }}
          export-default_credentials: true
```
Avec le code suivant :

```yaml
- uses: 'google-github-actions/auth@v2'
  with:
    project_id: $ID_PROJECT
    workload_identity_provider: projects/$ID_PROJECT_NUMBER/locations/global/workloadIdentityPools/$IAM_POOL_NAME/providers/$GITHUB_REPO_NAME 
```
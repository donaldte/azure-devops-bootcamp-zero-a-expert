# Cours Approfondi : Azure CLI – Maîtrisez la ligne de commande Microsoft Azure

## Sommaire

1. [Introduction à Azure CLI](#1-introduction-à-azure-cli)
   - 1.1 Qu’est-ce qu’Azure CLI ? (What)
   - 1.2 Pourquoi utiliser Azure CLI ? (Why)
   - 1.3 Quand l’utiliser ? (When)
   - 1.4 Alternatives et cas de non-utilisation (If not)

2. [Installation et Configuration](#2-installation-et-configuration)
   - 2.1 Installation sur Windows, Linux, macOS
   - 2.2 Utilisation via Azure Cloud Shell
   - 2.3 Configuration initiale et authentification

3. [Concepts Fondamentaux](#3-concepts-fondamentaux)
   - 3.1 Structure des commandes Azure CLI
   - 3.2 Groupes de commandes et sous-commandes
   - 3.3 Paramètres globaux et options courantes

4. [Formats de Sortie et Interrogation (JMESPath)](#4-formats-de-sortie-et-interrogation-jmespath)
   - 4.1 Formats de sortie : JSON, Table, TSV, YAML
   - 4.2 Introduction à JMESPath
   - 4.3 Requêtes avancées et transformations

5. [Gestion des Ressources Azure](#5-gestion-des-ressources-azure)
   - 5.1 Gestion des groupes de ressources (az group)
   - 5.2 Gestion des étiquettes (tags)
   - 5.3 Gestion des machines virtuelles (az vm)
   - 5.4 Gestion du réseau (az network)

6. [Automatisation et Scripting](#6-automatisation-et-scripting)
   - 6.1 Structure d’un script Bash avec Azure CLI
   - 6.2 Variables et paramètres
   - 6.3 Boucles et conditions
   - 6.4 Gestion des erreurs et validation
   - 6.5 Infrastructure as Code avec modèles ARM

7. [Gestion des Accès et Sécurité](#7-gestion-des-accès-et-sécurité)
   - 7.1 Azure RBAC (az role)
   - 7.2 Identités managées et principaux de service
   - 7.3 Bonnes pratiques de sécurité

8. [Intégration CI/CD et DevOps](#8-intégration-cicd-et-devops)
   - 8.1 Azure CLI dans Azure Pipelines
   - 8.2 Authentification sans interaction humaine
   - 8.3 Exemple complet de pipeline CI/CD

9. [Dépannage et Bonnes Pratiques](#9-dépannage-et-bonnes-pratiques)
   - 9.1 Erreurs courantes et solutions
   - 9.2 Optimisation des performances
   - 9.3 Audit et journalisation

10. [Conclusion](#10-conclusion)

---

## 1. Introduction à Azure CLI

### 1.1 Qu’est-ce qu’Azure CLI ? (What)

**Azure CLI** (Command‑Line Interface) est un outil multiplateforme permettant de gérer les ressources Microsoft Azure directement depuis la ligne de commande. Optimisé pour l’automatisation et la facilité d’utilisation, il propose des commandes simples qui s’intègrent parfaitement avec le modèle Azure Resource Manager (ARM).

Azure CLI est disponible sur Windows, macOS et Linux, ainsi que directement dans le navigateur via **Azure Cloud Shell** (Bash ou PowerShell).

### 1.2 Pourquoi utiliser Azure CLI ? (Why)

Azure CLI offre plusieurs avantages clés :

- **Automatisation** : Idéal pour les scripts et les pipelines CI/CD. Vous pouvez répéter des tâches sans erreurs humaines.
- **Rapidité** : Une fois les commandes maîtrisées, l’exécution est bien plus rapide que via le portail graphique.
- **Reproductibilité** : Un script Azure CLI est une documentation exécutable de votre infrastructure.
- **Multiplateforme** : Mêmes commandes sur Windows, Linux, macOS ou Cloud Shell.
- **Contrôle fin** : Accès à toutes les fonctionnalités Azure, y compris celles non encore disponibles dans le portail.

### 1.3 Quand l’utiliser ? (When)

Azure CLI est particulièrement adapté pour :

- **Déploiements automatisés** : Création et mise à jour de ressources dans le cadre d’un pipeline CI/CD.
- **Environnements de développement/test** : Création et destruction rapide d’infrastructures éphémères.
- **Tâches répétitives** : Par exemple, lister toutes les VM d’un abonnement avec des filtres précis.
- **Infrastructure as Code** : Déploiement de modèles ARM (JSON ou Bicep) de manière scriptée.
- **Administration quotidienne** : Gestion des groupes de ressources, des tags, des accès.

### 1.4 Alternatives et cas de non-utilisation (If not)

- **Azure PowerShell** : Si votre équipe maîtrise déjà PowerShell et souhaite une intégration plus poussée avec l’écosystème Windows.
- **Portail Azure** : Pour la découverte des services, les configurations ponctuelles ou les utilisateurs non techniques.
- **Terraform** : Pour une approche IaC (Infrastructure as Code) multi-cloud plus déclarative et avec gestion d’état.
- **Azure SDKs** : Pour intégrer la gestion Azure dans des applications personnalisées (Python, .NET, etc.).

---

## 2. Installation et Configuration

### 2.1 Installation sur Windows, Linux, macOS

**Sur Windows** : Téléchargez le MSI depuis le site officiel ou utilisez `winget` :

```bash
winget install Microsoft.AzureCLI
```

**Sur macOS** : Via Homebrew

```bash
brew update && brew install azure-cli
```

**Sur Linux** : Via le script d’installation

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Vérification de l’installation**

```bash
az version
```

### 2.2 Utilisation via Azure Cloud Shell

La méthode la plus simple pour commencer est d’utiliser **Azure Cloud Shell**, accessible depuis le portail Azure ou via `https://shell.azure.com`. Aucune installation n’est requise, et vous bénéficiez de la dernière version d’Azure CLI préinstallée.

### 2.3 Configuration initiale et authentification

**Se connecter à Azure**

```bash
az login
```

Si Azure CLI peut ouvrir votre navigateur par défaut, il lance le flux d’autorisation. Sinon, il propose un flux avec code d’appareil. Après connexion, la liste de vos abonnements s’affiche.

**Sélectionner un abonnement par défaut**

```bash
az account set --subscription "mon-subscription-id"
```

**Vérifier l’abonnement actif**

```bash
az account show
```

**Configurer les valeurs par défaut** (exemple : région par défaut)

```bash
az configure --defaults location=francecentral
```

---

## 3. Concepts Fondamentaux

### 3.1 Structure des commandes Azure CLI

Toutes les commandes Azure CLI suivent le pattern :

```bash
az [groupe] [sous-groupe] [commande] [paramètres]
```

Exemple :

```bash
az vm create --resource-group MyRG --name MyVM --image UbuntuLTS
```

### 3.2 Groupes de commandes et sous-commandes

| Groupe | Description |
|--------|-------------|
| `az group` | Gestion des groupes de ressources |
| `az vm` | Gestion des machines virtuelles |
| `az network` | Gestion du réseau (VNet, NSG, etc.) |
| `az storage` | Gestion des comptes de stockage |
| `az role` | Gestion des rôles RBAC |
| `az ad` | Gestion d’Azure Active Directory |

Pour explorer la structure, utilisez l’aide intégrée :

```bash
az vm --help
az vm create --help
```

### 3.3 Paramètres globaux et options courantes

| Paramètre | Description |
|-----------|-------------|
| `--output` ou `-o` | Définit le format de sortie (json, table, tsv, yaml) |
| `--query` | Applique une requête JMESPath sur le résultat |
| `--verbose` | Affiche des informations détaillées |
| `--debug` | Affiche les informations de débogage |
| `--only-show-errors` | Affiche uniquement les erreurs |

---

## 4. Formats de Sortie et Interrogation (JMESPath)

### 4.1 Formats de sortie : JSON, Table, TSV, YAML

Par défaut, Azure CLI affiche les résultats en **JSON**. Vous pouvez modifier ce comportement avec `--output`.

| Format | Description |
|--------|-------------|
| `json` | JSON par défaut |
| `jsonc` | JSON coloré |
| `table` | Table ASCII avec en‑têtes de colonnes |
| `tsv` | Valeurs séparées par des tabulations, sans clés |
| `yaml` | YAML lisible par un humain |

**Exemples :**

```bash
# Tableau lisible
az group list --output table

# TSV pour script (sans clés)
az vm list --query "[].name" --output tsv

# YAML
az vm show --name MyVM --resource-group MyRG --output yaml
```

### 4.2 Introduction à JMESPath

**JMESPath** est un langage de requête pour JSON, intégré nativement dans Azure CLI via le paramètre `--query`. Il vous permet de sélectionner et transformer les données de sortie directement dans la ligne de commande, sans avoir à utiliser des outils externes comme `jq`.

Toutes les commandes Azure CLI supportent le paramètre `--query`. Les requêtes sont exécutées **côté client** sur l’objet JSON retourné par la commande.

### 4.3 Requêtes avancées et transformations

**Sélectionner une propriété simple**

```bash
az vm show --name MyVM --resource-group MyRG --query "name"
```

**Sélectionner plusieurs propriétés**

```bash
az vm list --query "[].{Name:name, OS:storageProfile.osDisk.osType}"
```

**Filtrer les résultats** (syntaxe `[?condition]`)

```bash
# Lister les VM en état 'Succeeded'
az vm list --query "[?provisioningState=='Succeeded'].name"
```

**Utiliser des fonctions JMESPath**

```bash
# Trier par nom
az vm list --query "sort_by([], &name)"

# Compter les éléments
az vm list --query "length([])"
```

**Exemple pratique** : Récupérer les adresses IP publiques de toutes les VM

```bash
az vm list --query "[].{Name:name, PublicIP:publicIpAddress}" --output table
```

---

## 5. Gestion des Ressources Azure

### 5.1 Gestion des groupes de ressources (az group)

Un **groupe de ressources** est un conteneur logique qui regroupe les ressources associées d’une solution Azure.

**Créer un groupe de ressources**

```bash
az group create --name MyResourceGroup --location francecentral
```

**Lister les groupes de ressources**

```bash
az group list --output table
```

**Obtenir les détails d’un groupe**

```bash
az group show --name MyResourceGroup
```

**Supprimer un groupe (et toutes ses ressources)**

```bash
az group delete --name MyResourceGroup --yes --no-wait
```

> `--yes` supprime la confirmation, `--no-wait` rend la commande non-bloquante.

### 5.2 Gestion des étiquettes (tags)

Les étiquettes (tags) permettent de catégoriser les ressources pour la facturation, la gestion et les politiques.

**Ajouter des étiquettes à un groupe de ressources**

```bash
az tag create --resource-id $(az group show --name MyResourceGroup --query id --output tsv) --tags Environment=Production Department=IT
```

**Mettre à jour des étiquettes**

```bash
az tag update --resource-id $(az group show --name MyResourceGroup --query id --output tsv) --operation Merge --tags CostCenter=Finance
```

**Lister les étiquettes d’un groupe**

```bash
az tag list --resource-id $(az group show --name MyResourceGroup --query id --output tsv)
```

### 5.3 Gestion des machines virtuelles (az vm)

**Créer une VM Linux**

```bash
az vm create \
  --resource-group MyResourceGroup \
  --name MyLinuxVM \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --size Standard_B1s
```

> L’option `--generate-ssh-keys` génère automatiquement une paire de clés SSH si elle n’existe pas.

**Lister les VM d’un groupe**

```bash
az vm list --resource-group MyResourceGroup --output table
```

**Démarrer / Arrêter / Redémarrer une VM**

```bash
az vm start --name MyLinuxVM --resource-group MyResourceGroup
az vm stop --name MyLinuxVM --resource-group MyResourceGroup
az vm restart --name MyLinuxVM --resource-group MyResourceGroup
```

**Redimensionner une VM**

```bash
az vm resize --name MyLinuxVM --resource-group MyResourceGroup --size Standard_D2s_v3
```

**Supprimer une VM**

```bash
az vm delete --name MyLinuxVM --resource-group MyResourceGroup --yes
```

### 5.4 Gestion du réseau (az network)

**Créer un réseau virtuel (VNet) et un sous‑réseau**

```bash
az network vnet create \
  --resource-group MyResourceGroup \
  --name MyVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name MySubnet \
  --subnet-prefix 10.0.1.0/24
```

**Créer un groupe de sécurité réseau (NSG)**

```bash
az network nsg create \
  --resource-group MyResourceGroup \
  --name MyNSG
```

**Ajouter une règle entrante (SSH)**

```bash
az network nsg rule create \
  --resource-group MyResourceGroup \
  --nsg-name MyNSG \
  --name AllowSSH \
  --priority 100 \
  --source-address-prefixes Internet \
  --destination-port-ranges 22 \
  --access Allow \
  --protocol Tcp
```

**Associer le NSG à un sous‑réseau**

```bash
az network vnet subnet update \
  --resource-group MyResourceGroup \
  --vnet-name MyVNet \
  --name MySubnet \
  --network-security-group MyNSG
```

---

## 6. Automatisation et Scripting

### 6.1 Structure d’un script Bash avec Azure CLI

Un script Azure CLI bien structuré comprend généralement :

- **Shebang** : `#!/bin/bash` ou `#!/usr/bin/env bash`
- **Variables** : pour stocker les noms, localisations, configurations
- **Commentaires** : pour documenter la logique
- **Gestion des erreurs** : validation avant création
- **Boucles et conditions** : pour créer plusieurs ressources

### 6.2 Variables et paramètres

```bash
#!/bin/bash

# Variables
RESOURCE_GROUP="rg-projet-001"
LOCATION="francecentral"
VM_NAME="web-server-001"
```

**Utiliser des paramètres externes**

```bash
RESOURCE_GROUP=$1
LOCATION=$2
```

### 6.3 Boucles et conditions

**Créer plusieurs comptes de stockage**

```bash
for i in $(seq 1 3); do
    STORAGE_NAME="stproj${i}"
    az storage account create \
        --name $STORAGE_NAME \
        --resource-group $RESOURCE_GROUP \
        --location $LOCATION \
        --sku Standard_LRS
done
```

**Vérifier l’existence d’une ressource avant création**

```bash
if az group show --name $RESOURCE_GROUP &> /dev/null; then
    echo "Le groupe $RESOURCE_GROUP existe déjà."
else
    az group create --name $RESOURCE_GROUP --location $LOCATION
fi
```

### 6.4 Gestion des erreurs et validation

**Vérifier qu’Azure CLI est installé et authentifié**

```bash
if ! command -v az &> /dev/null; then
    echo "Erreur : Azure CLI n'est pas installé."
    exit 1
fi

if ! az account show &> /dev/null; then
    echo "Erreur : Non authentifié. Lancez 'az login'."
    exit 1
fi
```

### 6.5 Infrastructure as Code avec modèles ARM

Azure CLI permet de déployer des modèles ARM (JSON ou Bicep) de manière déclarative.

**Déployer un modèle local**

```bash
az deployment group create \
    --resource-group MyResourceGroup \
    --template-file template.json \
    --parameters param1=valeur1 param2=valeur2
```

**Déployer un modèle depuis une URL**

```bash
az deployment group create \
    --resource-group MyResourceGroup \
    --template-uri https://exemple.com/template.json
```

---

## 7. Gestion des Accès et Sécurité

### 7.1 Azure RBAC (az role)

**Lister les rôles disponibles**

```bash
az role definition list --output table
```

**Attribuer un rôle à un utilisateur**

```bash
az role assignment create \
    --assignee "user@contoso.com" \
    --role "Contributor" \
    --scope "/subscriptions/xxx/resourceGroups/MyResourceGroup"
```

**Lister les attributions de rôles**

```bash
az role assignment list --assignee "user@contoso.com"
```

### 7.2 Identités managées et principaux de service

**Créer un principal de service**

```bash
az ad sp create-for-rbac --name "my-service-principal"
```

Cela retourne un `appId`, `password` et `tenant`. Utilisez ces informations pour l’authentification sans interaction humaine.

**Se connecter avec un principal de service**

```bash
az login --service-principal -u <appId> -p <password> --tenant <tenant>
```

### 7.3 Bonnes pratiques de sécurité

- **Ne jamais coder en dur les secrets** : Utilisez des variables d’environnement ou Azure Key Vault.
- **Utiliser des identités managées** dans les VM ou Azure Functions pour éviter la gestion des secrets.
- **MFA obligatoire** : Depuis septembre 2025, Microsoft exige l’authentification multifacteur pour les comptes utilisateurs dans Azure CLI. Migrez vos workflows automatisés vers des principaux de service ou identités managées.

---

## 8. Intégration CI/CD et DevOps

### 8.1 Azure CLI dans Azure Pipelines

Azure CLI s’intègre parfaitement dans les pipelines CI/CD via la tâche `AzureCLI@2`.

**Exemple de pipeline YAML**

```yaml
- task: AzureCLI@2
  inputs:
    azureSubscription: 'MaConnexionAzure'
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      az group create --name rg-prod --location francecentral
      az vm create --resource-group rg-prod --name web-vm --image UbuntuLTS
```

### 8.2 Authentification sans interaction humaine

Pour les pipelines, utilisez un **principal de service** ou une **identité managée**. La tâche `AzureCLI@2` gère l’authentification automatiquement si la connexion de service Azure est correctement configurée.

### 8.3 Exemple complet de pipeline CI/CD

```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  resourceGroup: 'rg-app-prod'
  location: 'francecentral'

steps:
- task: AzureCLI@2
  inputs:
    azureSubscription: 'AzureServiceConnection'
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      # Créer le groupe de ressources
      az group create --name $(resourceGroup) --location $(location)
      
      # Déployer le modèle ARM
      az deployment group create \
        --resource-group $(resourceGroup) \
        --template-file infra/template.json \
        --parameters environment=prod
```

---

## 9. Dépannage et Bonnes Pratiques

### 9.1 Erreurs courantes et solutions

| Erreur | Cause probable | Solution |
|--------|----------------|----------|
| `az login` ne répond pas | Navigateur bloqué | Utilisez `az login --use-device-code` |
| `Permission denied` | Droits RBAC insuffisants | Vérifiez les attributions de rôles avec `az role assignment list` |
| `Resource not found` | Ressource inexistante ou mauvais groupe | Vérifiez avec `az resource list --resource-group` |
| Authentification MFA bloquée | Utilisation d’un compte utilisateur dans un pipeline | Migrez vers un principal de service|

### 9.2 Optimisation des performances

- Utilisez `--output tsv` ou `--query` pour réduire la quantité de données retournées.
- Préférez `--only-show-errors` dans les scripts pour éviter les logs superflus.
- Utilisez `--no-wait` pour les opérations longues (création de VM, suppression de groupe).

### 9.3 Audit et journalisation

Activez les logs de diagnostic pour Azure CLI dans vos pipelines. Conservez les journaux pour l’audit et le débogage.

**Commande de journalisation dans un script**

```bash
az vm create --name MyVM --resource-group MyRG --verbose --output json >> deployment.log
```

---

## 10. Conclusion

Azure CLI est un outil indispensable pour tout professionnel du cloud souhaitant gérer efficacement les ressources Microsoft Azure. Il combine :

- **Puissance** : Accès à toutes les fonctionnalités d’Azure
- **Flexibilité** : Scriptable et intégrable dans des pipelines CI/CD
- **Performance** : Bien plus rapide que le portail graphique
- **Reproductibilité** : Idéal pour l’Infrastructure as Code

**Bonnes pratiques à retenir :**

1. Utilisez les formats de sortie adaptés (`table` pour l’humain, `tsv` pour les scripts)
2. Exploitez JMESPath pour filtrer les résultats côté client
3. Structurez vos scripts avec variables, commentaires et gestion d’erreurs
4. Privilégiez les identités managées et principaux de service pour l’automatisation
5. Testez toujours vos scripts dans un environnement de développement avant la production

**Pour aller plus loin :**
- Consultez la [documentation officielle Azure CLI](https://learn.microsoft.com/cli/azure/)
- Explorez le dépôt GitHub [Azure/azure-cli](https://github.com/Azure/azure-cli) pour les exemples
- Suivez les modules [Azure CLI Training](https://learn.microsoft.com/training/browse/?products=azure-cli)

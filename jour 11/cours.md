# Cours complet : Les comptes de stockage Azure (Azure Storage Account)

## Sommaire

1. [Introduction : Qu’est-ce qu’un compte de stockage Azure ?](#1-introduction--quest-ce-quun-compte-de-stockage-azure-)
2. [Architecture d’un compte de stockage](#2-architecture-dun-compte-de-stockage)
3. [Types de comptes de stockage](#3-types-de-comptes-de-stockage)
4. [Services de stockage intégrés](#4-services-de-stockage-intégrés)
5. [Redondance et réplication des données](#5-redondance-et-réplication-des-données)
6. [Niveaux d’accès (Access Tiers)](#6-niveaux-daccès-access-tiers)
7. [Gestion du cycle de vie des données (Lifecycle Management)](#7-gestion-du-cycle-de-vie-des-données-lifecycle-management)
8. [Sécurité d’un compte de stockage](#8-sécurité-dun-compte-de-stockage)
9. [Cas d’utilisation concrets](#9-cas-dutilisation-concrets)
10. [Opérations avec Azure CLI](#10-opérations-avec-azure-cli)
11. [Bonnes pratiques](#11-bonnes-pratiques)
12. [Conclusion](#12-conclusion)

---

## 1. Introduction : Qu’est-ce qu’un compte de stockage Azure ?

Un **compte de stockage Azure (Azure Storage Account)** est le point d’entrée central vers les services de stockage de Microsoft Azure. Il contient l’ensemble des objets de données Azure : blobs (données non structurées), fichiers, files d’attente (queues) et tables[reference:0].

### Caractéristiques fondamentales

Un compte de stockage fournit un **espace de noms unique** pour vos données, accessible depuis n’importe où dans le monde via HTTP ou HTTPS. Les données qu’il contient sont :
- **Durables** : plusieurs copies sont conservées pour garantir la pérennité
- **Hautement disponibles** : avec un SLA allant de 99,9 % à 99,99 % selon la configuration
- **Sécurisées** : chiffrement au repos et en transit
- **Massivement scalables** : capacité allant jusqu’à l’exaoctet sans provisionnement préalable[reference:1]

### Pourquoi un compte de stockage ?

Un compte de stockage est indispensable dans presque toutes les architectures Azure :
- Stockage des fichiers statiques d’une application web
- Hébergement de bases de données NoSQL
- Stockage des journaux d’audit
- Sauvegardes et reprise après sinistre
- Support des services Azure (VM, Functions, App Services)

> **Schéma conceptuel :**
> ```
> +-------------------------------------------------------------------+
> |                     AZURE STORAGE ACCOUNT                         |
> |                   (Espace de noms unique global)                  |
> |                                                                   |
> |  +------------+  +------------+  +------------+  +------------+  |
> |  |    BLOB    |  |    FILE    |  |   QUEUE    |  |   TABLE    |  |
> |  |  STORAGE   |  |  STORAGE   |  |  STORAGE   |  |  STORAGE   |  |
> |  |            |  |            |  |            |  |            |  |
> |  | Données    |  | Partages   |  | Messagerie |  | Stockage   |  |
> |  | non struc- |  | de fichiers|  | asynchrone |  | NoSQL clé- |  |
> |  | turées     |  | (SMB/NFS)  |  |            |  | valeur     |  |
> |  +------------+  +------------+  +------------+  +------------+  |
> |                                                                   |
> |  +-------------------------------------------------------------+  |
> |  |                  COUCHES DE REDONDANCE                       |  |
> |  |   LRS  |  ZRS  |  GRS  |  RA-GRS  |  GZRS  |  RA-GZRS       |  |
> |  +-------------------------------------------------------------+  |
> +-------------------------------------------------------------------+
> ```

---

## 2. Architecture d’un compte de stockage

L’architecture d’un compte de stockage repose sur plusieurs composants clés.

### Hiérarchie des ressources

```
Groupe de ressources
└── Compte de stockage (nom globalement unique, 3 à 24 caractères)
    ├── Services
    │   ├── Conteneurs de blobs
    │   │   └── Blobs (blocs, pages, ajouts)
    │   ├── Partages de fichiers
    │   │   └── Répertoires / Fichiers
    │   ├── Files d’attente
    │   │   └── Messages
    │   └── Tables
    │       └── Entités (partitions, lignes, propriétés)
    └── Configuration
        ├── Redondance (LRS, ZRS, GRS, etc.)
        ├── Niveau d’accès (Hot, Cool, Cold, Archive)
        ├── Règles de pare-feu et réseaux virtuels
        └── Politiques de cycle de vie
```

### Nommage du compte

Le nom du compte de stockage doit être :
- Globalement unique sur l’ensemble d’Azure
- Composé de 3 à 24 caractères
- Uniquement des lettres minuscules et des chiffres

### Point de terminaison (endpoint)

Chaque compte expose des endpoints pour ses services :
- Blob : `https://<nom-compte>.blob.core.windows.net`
- File : `https://<nom-compte>.file.core.windows.net`
- Queue : `https://<nom-compte>.queue.core.windows.net`
- Table : `https://<nom-compte>.table.core.windows.net`

---

## 3. Types de comptes de stockage

Azure propose plusieurs types de comptes de stockage. Le choix dépend du type de données à stocker et des exigences de performance.

### 3.1 Compte Standard general-purpose v2 (GPv2)

Le **GPv2** est le type recommandé par Microsoft pour la plupart des scénarios[reference:2]. Il supporte tous les services de stockage (Blob, File, Queue, Table) et toutes les fonctionnalités récentes.

| Caractéristique | Détail |
|----------------|--------|
| **Services supportés** | Blob (y compris Data Lake Storage), File, Queue, Table |
| **Redondances disponibles** | LRS, ZRS, GRS, RA-GRS, GZRS, RA-GZRS (selon région) |
| **Niveaux d’accès** | Hot, Cool, Cold, Archive |
| **Cas d’usage** | Applications générales, sites web, sauvegardes, Big Data |

### 3.2 Comptes Premium

Les comptes **Premium** utilisent des disques SSD (solid-state drives) pour offrir une latence constamment faible et un débit élevé[reference:3]. Ils se déclinent en trois sous-types.

| Type | Services supportés | Cas d’usage |
|------|-------------------|--------------|
| **Premium block blobs** | Blocs et ajouts | Transactions élevées, petits objets, applications nécessitant une latence < 10 ms[reference:4] |
| **Premium file shares** | Fichiers uniquement | Applications d’entreprise, partages SMB/NFS haute performance[reference:5] |
| **Premium page blobs** | Pages blobs uniquement | Disques VHD pour VM Azure (stockage de pages)[reference:6] |

### 3.3 Types hérités (déconseillés)

Les comptes **General-purpose v1 (GPv1)** et **BlobStorage** sont des types hérités. Microsoft recommande de migrer vers GPv2[reference:7]. Seules les applications legacy qui ne supportent pas GPv2 justifient leur utilisation.

> **Schéma de choix :**
> ```
> +---------------------+
> |    QUELLES DONNÉES ?   |
> +---------------------+
>           |
>           v
> +---------------------+    NON   +------------------------+
> | Latence très faible |-------->| Compte Standard GPv2   |
> | (< 10 ms) ?         |         | (recommandé par défaut)|
> +---------------------+         +------------------------+
>           |
>          OUI
>           v
> +-----------------------------------------------------+
> |                COMPTE PREMIUM                       |
> +-----------------------------------------------------+
>           |
>           +---> Blocs/ajouts -----> Premium block blobs
>           |
>           +---> Fichiers ---------> Premium file shares
>           |
>           +---> Pages -------------> Premium page blobs
> ```

---

## 4. Services de stockage intégrés

### 4.1 Blob Storage

Le **Blob Storage** est conçu pour les données non structurées : images, vidéos, documents, logs, sauvegardes.

- **Block blobs** : pour les fichiers texte et binaires (taille max 4,75 To par blob)
- **Append blobs** : pour les journaux (optimisés pour les opérations d’ajout)
- **Page blobs** : pour les disques de VM (accès aléatoire, lecture/écriture par pages de 512 octets)

### 4.2 Azure Files

**Azure Files** fournit des partages de fichiers managés accessibles via SMB (Server Message Block) ou NFS (Network File System).

- Utilisations : remplacement des serveurs de fichiers locaux, partage de configuration entre VM, migration « lift-and-shift »

### 4.3 Queue Storage

**Queue Storage** est un service de messagerie asynchrone pour la communication entre composants d’applications distribuées.

- Messages jusqu’à 64 Ko
- Ordre FIFO non garanti (contrairement aux files Azure Service Bus)

### 4.4 Table Storage

**Table Storage** est un magasin NoSQL clé-valeur pour les données semi-structurées.

- Alternative plus simple et économique à Cosmos DB pour les charges non critiques

---

## 5. Redondance et réplication des données

Azure maintient plusieurs copies de vos données pour garantir la durabilité (jusqu’à 99,99999999999999 %, soit 16 neufs) et la disponibilité. Le choix de la redondance influence à la fois la résilience et le coût.

### 5.1 LRS – Locally Redundant Storage

Trois copies synchrones au sein du **même datacenter**[reference:8].

- **Durabilité** : 99,999999999 % (11 neufs)
- **Protection** : pannes de rack et de disque
- **Non protégé contre** : sinistre du datacenter (incendie, inondation)
- **Coût** : le plus bas

### 5.2 ZRS – Zone-Redundant Storage

Trois copies réparties dans **trois zones de disponibilité distinctes** au sein de la même région[reference:9].

- **Protection** : panne d’une zone de disponibilité complète
- **Durée minimale de stockage** : aucune
- **Disponibilité** : meilleure que LRS

### 5.3 GRS – Geo-Redundant Storage

LRS dans la région primaire + réplication asynchrone vers une **région secondaire distante de plusieurs centaines de kilomètres**[reference:10].

- **Récupération** : bascule manuelle (failover) en cas de panne régionale
- **Accès secondaire** : lecture uniquement après bascule
- **Durée minimale de stockage** : aucune

### 5.4 RA-GRS – Read-Access Geo-Redundant Storage

Identique à GRS, mais permet la **lecture directe** depuis la région secondaire à tout moment[reference:11].

- **Idéal pour** : applications critiques nécessitant une haute disponibilité (l’application peut continuer à lire les données même si la région primaire est indisponible)

### 5.5 GZRS et RA-GZRS

**GZRS** combine ZRS dans la région primaire et réplication géographique vers une région secondaire. **RA-GZRS** ajoute la lecture directe sur le secondaire.

- **Durabilité maximale** : recommandé par Microsoft pour la haute disponibilité[reference:12]
- **Disponibilité RA-GZRS** : 99,99 % pour les lectures

> **Schéma comparatif des redondances :**
> ```
> LRS (3 copies)          ZRS (3 copies, 3 zones)          GRS (LRS + secondaire)
> +----------------+      +----------------+                +----------------+
> |   Datacenter   |      |   Zone A       |                |   Région A     |
> |  +----------+  |      |  +----------+  |                |  +----------+  |
> |  | copie 1  |  |      |  | copie 1  |  |                |  | copie 1  |  |
> |  | copie 2  |  |      |  +----------+  |                |  | copie 2  |  |
> |  | copie 3  |  |      |   Zone B       |                |  | copie 3  |  |
> |  +----------+  |      |  +----------+  |                |  +----------+  |
> +----------------+      |  | copie 2  |  |                +----------------+
>                         |  +----------+  |                           |
>                         |   Zone C       |                     Réplication
>                         |  +----------+  |                     asynchrone
>                         |  | copie 3  |  |                           v
>                         |  +----------+  |                +----------------+
>                         +----------------+                |   Région B     |
>                                                            |  +----------+  |
> LRS = moins cher, moins résilient                         |  | copie 4  |  |
> ZRS = résilient aux pannes de zone                        |  | copie 5  |  |
> GRS/RA-GRS = protection régionale                         |  | copie 6  |  |
>                                                            |  +----------+  |
>                                                            +----------------+
> ```

---

## 6. Niveaux d’accès (Access Tiers)

Les niveaux d’accès permettent d’optimiser les coûts en fonction de la fréquence d’accès aux données.

### 6.1 Hot tier

| Caractéristique | Détail |
|----------------|--------|
| **Optimisé pour** | Données fréquemment accédées ou modifiées |
| **Coût de stockage** | Élevé |
| **Coût d’accès** | Faible |
| **Stockage min.** | Aucun[reference:13] |
| **Disponibilité (LRS)** | 99,9 % |
| **Disponibilité (RA-GRS)** | 99,99 % |

**Cas d’usage** : données en production active, traitements en cours, caches.

### 6.2 Cool tier

| Caractéristique | Détail |
|----------------|--------|
| **Optimisé pour** | Données rarement accédées (moins d’une fois par mois) |
| **Coût de stockage** | Modéré |
| **Coût d’accès** | Supérieur au Hot |
| **Stockage min.** | 30 jours[reference:14] |
| **Disponibilité (LRS)** | 99 % |

**Cas d’usage** : sauvegardes court terme, données de récupération après sinistre, contenus multimédia anciens.

### 6.3 Cold tier

| Caractéristique | Détail |
|----------------|--------|
| **Optimisé pour** | Données très rarement accédées (quelques fois par an) |
| **Coût de stockage** | Bas |
| **Coût d’accès** | Élevé |
| **Stockage min.** | 90 jours[reference:15] |
| **Disponibilité (LRS)** | 99 % |

**Cas d’usage** : archives court à moyen terme, données réglementaires conservées plusieurs trimestres.

### 6.4 Archive tier

| Caractéristique | Détail |
|----------------|--------|
| **Optimisé pour** | Données quasi jamais accédées |
| **Statut** | Hors ligne (nécessite réhydratation) |
| **Latence de récupération** | Heures (jusqu’à 15 h) |
| **Coût de stockage** | Minimal |
| **Coût d’accès** | Très élevé |
| **Stockage min.** | 180 jours[reference:16] |
| **Disponibilité** | N/A (hors ligne) |

**Cas d’usage** : archives légales, conformité à long terme, sauvegardes secondaires.

> **Schéma des niveaux d’accès :**
> ```
> +--------------+     +--------------+     +--------------+     +--------------+
> |     HOT      |     |     COOL     |     |     COLD     |     |   ARCHIVE    |
> |              |     |              |     |              |     |              |
> | Disponibilité|     | Disponibilité|     | Disponibilité|     |   Hors ligne |
> |   99,9%      |     |   99%        |     |   99%        |     | Réhydratation|
> | Latence ms   |     | Latence ms   |     | Latence ms   |     | en heures    |
> | Stockage min.|     | Stockage min.|     | Stockage min.|     | Stockage min.|
> |    0 jour    |     |   30 jours   |     |   90 jours   |     |  180 jours   |
> +--------------+     +--------------+     +--------------+     +--------------+
>        ^                     ^                     ^                     ^
>        |                     |                     |                     |
>   Prix stockage ---------------------------------------------> Décroissant
>   Prix accès    <--------------------------------------------- Croissant
> ```

> **⚠️ Pénalités de suppression anticipée** : un blob supprimé ou déplacé vers un niveau inférieur avant la durée minimale de stockage est facturé comme s’il était resté dans le niveau[reference:17].

---

## 7. Gestion du cycle de vie des données (Lifecycle Management)

La **gestion du cycle de vie** est une fonctionnalité qui automatise le déplacement des blobs entre les niveaux d’accès ou leur suppression selon des règles basées sur l’âge ou d’autres critères[reference:18].

### 7.1 Pourquoi utiliser Lifecycle Management ?

- **Réduction des coûts** : les données rarement consultées sont automatiquement déplacées vers des niveaux moins chers
- **Suppression automatique** : élimination des données périmées sans intervention manuelle
- **Prévisibilité** : gestion intelligente des coûts de stockage[reference:19]

### 7.2 Règles typiques

| Règle | Action | Délai |
|-------|--------|-------|
| Déplacer les logs vers Cool | `tierToCool` | 30 jours |
| Déplacer les logs vers Archive | `tierToArchive` | 90 jours |
| Supprimer les logs | `delete` | 365 jours |

### 7.3 Exemple de règle en JSON

```json
{
  "rules": [
    {
      "name": "move-to-cool",
      "enabled": true,
      "type": "Lifecycle",
      "definition": {
        "filters": {
          "blobTypes": ["blockBlob"],
          "prefixMatch": ["logs/"]
        },
        "actions": {
          "baseBlob": {
            "tierToCoolAfterDays": 30,
            "tierToArchiveAfterDays": 90,
            "deleteAfterDays": 365
          }
        }
      }
    }
  ]
}
```

---

## 8. Sécurité d’un compte de stockage

### 8.1 Authentification

Trois méthodes principales existent pour s’authentifier auprès d’un compte de stockage.

| Méthode | Niveau de sécurité | Cas d’usage |
|---------|-------------------|--------------|
| **Clés d’accès** (2 clés) | Élevé, mais contrôle total | Déploiements, migration initiale |
| **SAS (Shared Access Signature)** | Limité (permissions fines, expiration) | Accès délégué temporaire[reference:20] |
| **Microsoft Entra ID + identités managées** | Recommandé par Microsoft | Accès sécurisé sans clés[reference:21] |

> **Recommandation** : pour une sécurité optimale, utilisez Microsoft Entra ID avec des identités managées plutôt que les clés d’accès partagées.

### 8.2 Chiffrement

- **Chiffrement au repos** : activé par défaut pour tous les comptes
- **Chiffrement en transit** : exigence de transfert sécurisé (HTTPS)
- **Clés gérées par le client (CMK – Customer-Managed Keys)** : pour les organisations soumises à des exigences réglementaires strictes[reference:22]

### 8.3 Contrôle d’accès réseau

| Mécanisme | Description |
|-----------|-------------|
| **Pare-feu** | Restreint l’accès à des réseaux virtuels ou plages IP spécifiques[reference:23] |
| **Points de terminaison de service** | Connexion sécurisée depuis un VNet vers le compte de stockage[reference:24] |
| **Points de terminaison privés** | IP privée statique pour les environnements hybrides (VPN, ExpressRoute)[reference:25] |

### 8.4 Bonnes pratiques de sécurité

1. Désactiver l’accès public aux blobs si non nécessaire
2. Appliquer le principe du moindre privilège
3. Faire tourner régulièrement les clés d’accès
4. Activer Azure Defender pour la détection des menaces
5. Utiliser des SAS avec des permissions minimales et des fenêtres de validité courtes[reference:26]

---

## 9. Cas d’utilisation concrets

### 9.1 Hébergement d’un site web statique

Le Blob Storage peut héberger directement un site web statique (HTML, CSS, JavaScript). Les avantages sont les suivants : simplicité, pas de serveur à gérer, intégration CDN possible.

### 9.2 Data Lake pour l’analytique Big Data

Le **Data Lake Storage Gen2** (activable sur un GPv2) apporte un espace de noms hiérarchique. Il permet des analyses Big Data avec Hadoop, Spark et Azure Synapse[reference:27].

### 9.3 Sauvegarde et reprise après sinistre

Combinaison de la redondance géographique (RA-GRS, RA-GZRS) et des niveaux d’accès pour stocker les sauvegardes de manière économique tout en restant récupérables.

### 9.4 Migration « lift-and-shift » de serveurs de fichiers

Azure Files remplace les serveurs de fichiers locaux. La synchronisation avec Azure File Sync maintient les données à jour entre le site local et le cloud.

---

## 10. Opérations avec Azure CLI

### 10.1 Création d’un compte de stockage

```bash
# Variables
RESOURCE_GROUP="rg-storage-demo"
LOCATION="francecentral"
STORAGE_ACCOUNT="mastockageunique"

# Créer un groupe de ressources
az group create --name $RESOURCE_GROUP --location $LOCATION

# Créer un compte GPv2 avec redondance LRS
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2
```

### 10.2 Gestion des clés d’accès

```bash
# Lister les clés d’accès
az storage account keys list \
  --account-name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --output table

# Régénérer une clé (exemple : clé 1)
az storage account keys renew \
  --account-name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --key primary
```

### 10.3 Configuration du pare-feu

```bash
# Ajouter une règle IP
az storage account network-rule add \
  --account-name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --ip-address "203.0.113.0/24"

# Autoriser uniquement les réseaux sélectionnés
az storage account update \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --default-action Deny
```

### 10.4 Politique de cycle de vie

```bash
# Créer une politique JSON (lifecycle.json)
az storage account management-policy create \
  --account-name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --policy @lifecycle.json
```

### 10.5 Génération d’un jeton SAS

```bash
# Générer un SAS pour le compte
az storage account generate-sas \
  --account-name $STORAGE_ACCOUNT \
  --permissions rwl \
  --services b \
  --resource-types co \
  --expiry 2025-12-31T23:59:59Z
```

---

## 11. Bonnes pratiques

| Domaine | Recommandation |
|---------|----------------|
| **Type de compte** | Toujours commencer par GPv2 sauf si les performances Premium sont impératives |
| **Redondance** | RA-GZRS pour les applications critiques ; LRS pour les environnements de développement |
| **Niveau d’accès** | Cool ou Cold après 30 jours d’inactivité ; Archive au‑delà de 180 jours |
| **Nommage** | Utiliser un préfixe standardisé (ex: `stappprod001`) |
| **Sécurité** | Préférer Entra ID + identités managées aux clés d’accès |
| **Surveillance** | Activer les journaux de diagnostic et Azure Monitor |
| **Économies** | Appliquer systématiquement une politique de cycle de vie |
| **Région** | Choisir une région proche des utilisateurs finaux pour minimiser la latence |

---

## 12. Conclusion

Le compte de stockage Azure est un service fondamental qui sert de socle à de nombreuses architectures cloud. Sa maîtrise implique de comprendre :

- Les **types de comptes** : GPv2 pour la plupart des cas, Premium pour les hautes performances
- La **redondance** : de LRS (économique) à RA-GZRS (ultra‑résilient)
- Les **niveaux d’accès** : Hot → Cool → Cold → Archive pour optimiser les coûts
- La **gestion du cycle de vie** : automatisée via des règles
- La **sécurité** : authentification moderne (Entra ID, identités managées), chiffrement, pare‑feu

En appliquant les bonnes pratiques présentées dans ce cours, vous serez en mesure de concevoir des solutions de stockage Azure à la fois performantes, sécurisées et économiquement optimisées.

> **Références utiles :**
> - Documentation Microsoft : [Storage account overview](https://learn.microsoft.com/azure/storage/common/storage-account-overview)
> - [Azure Storage redundancy](https://learn.microsoft.com/azure/storage/common/storage-redundancy)
> - [Access tiers for blob data](https://learn.microsoft.com/azure/storage/blobs/access-tiers-overview)
# Sommaire

1. [Introduction au Cloud Computing](#1-introduction-au-cloud-computing)
2. [Types de Cloud](#2-types-de-cloud)
3. [Concepts Fondamentaux : Virtualisation et API](#3-concepts-fondamentaux--virtualisation-et-api)
4. [Infrastructure Globale : Régions et Zones de Disponibilité](#4-infrastructure-globale--régions-et-zones-de-disponibilité)
5. [Scalabilité, Élasticité et Haute Disponibilité](#5-scalabilité-élasticité-et-haute-disponibilité)
6. [Reprise après sinistre et objectifs de performance](#6-reprise-après-sinistre-et-objectifs-de-performance)
7.
8. ----

9. ## 1. Introduction au Cloud Computing

**Cloud computing** = modèle permettant un accès réseau à la demande à un pool partagé de ressources informatiques configurables (serveurs, stockage, applications, services).  

On parle des trois grands fournisseurs publics :  
- **AWS** (Amazon Web Services)  
- **Azure** (Microsoft)  
- **GCP** (Google Cloud Platform)

### Pourquoi le cloud a‑t‑il émergé ?

Il y a 10–15 ans, les entreprises géraient leurs propres **serveurs physiques** dans une **salle serveur** (datacenter sur site). L’administrateur système devait provisionner manuellement des machines pour chaque besoin.  
On appelait cela le **private cloud** (cloud privé) quand on virtualisait ces ressources en interne.

**Problèmes de l’approche traditionnelle :**  
- **24/7 uptime** : maintenir la disponibilité permanente est complexe et coûteux  
- **Overhead** : équipe dédiée à la gestion matérielle  
- **Cost** : investissement lourd (achat, maintenance, électricité, climatisation)  
- **Scalability** : difficile d’augmenter ou réduire rapidement la capacité  
- **Security** : la sécurité physique et logicielle repose entièrement sur l’entreprise

> Aujourd’hui, les fournisseurs cloud (AWS, Azure, GCP) possèdent des **datacenters** répartis dans le monde entier. On parle alors de **public cloud** : on loue des ressources à la demande.

---

## 2. Types de Cloud

### Public Cloud
- Ressources partagées entre plusieurs clients (mutualisation)  
- Exemple : créer 10 **VM** (machines virtuelles) en région US ou Inde en quelques clics  
- Fournisseurs : AWS, Azure, GCP

### Private Cloud
- Cloud dédié à une seule organisation, souvent dans ses propres datacenters (on‑premise)  
- Utilisé pour des applications sensibles ou héritées (legacy)  
- **Legacy application** = application non conçue pour le cloud (ex. système bancaire) – pour des raisons de **sécurité** ou de **coût** de migration.

### Hybrid Cloud
- Combinaison de public et private cloud, avec orchestration entre les deux  
- Exemple : **xyz.com** – base de données en private cloud (on‑premise) et frontend web dans le public cloud.

---

## 3. Concepts Fondamentaux : Virtualisation et API

### Virtualisation
- Avant, un serveur physique = un OS + des applications. Peu flexible.  
- Avec un **hypervisor** (ex. Hyper‑V, VMware), on peut découper un serveur physique en plusieurs **machines virtuelles (VM)**.  
- Chaque VM a son propre OS et ses ressources allouées (CPU, RAM, stockage).  
- Dans le cloud, les fournisseurs possèdent des milliers de serveurs physiques virtualisés → on loue des VM.

> **À retenir** : la virtualisation est la base du cloud.

### API (Application Programming Interface)
- Interface qui permet à des applications ou outils de dialoguer avec un service.  
- Dans le cloud, tout est automatisable via des **API** : création de 1000 VM, configuration réseau, etc.  
- Exemples d’interaction :  
  - **UI** (portail Azure)  
  - **CLI** (Azure CLI)  
  - **API REST** (utilisée par des outils comme Jenkins, Terraform)

> **Azure vous conseille d’utiliser les API pour toute gestion à grande échelle.**

---

## 4. Infrastructure Globale : Régions et Zones de Disponibilité

### Région (Region)
- Zone géographique contenant un ou plusieurs datacenters.  
- Exemples : *East US*, *West Europe*, *Southeast Asia*.  
- Pour rapprocher les données des utilisateurs ou respecter des lois de résidence des données.

### Zone de disponibilité (Availability Zone)
- Au sein d’une région, on a plusieurs datacenters isolés (électricité, réseau indépendants).  
- Chaque zone est une **Availability Zone (AZ)**.  
- Déployer une application sur deux AZ différentes = **réplication** pour la tolérance aux pannes.

### Load Balancer (équilibreur de charge)
- Répartit le trafic entrant entre les instances répliquées (ex. VM dans deux AZ).  
- Améliore la disponibilité et la scalabilité.

---

## 5. Scalabilité, Élasticité et Haute Disponibilité

### Scalabilité (Scalability)
- Capacité d’un système à gérer une charge croissante.  
- **Scalabilité verticale** (*scale up/down*) : augmenter la puissance d’une machine (plus de CPU/RAM).  
- **Scalabilité horizontale** (*scale out/in*) : ajouter ou retirer des instances (ex. plus de VM).

### Élasticité (Elasticity)
- Capacité à adapter automatiquement les ressources à la charge (auto‑scaling).  
- Exemple : pics de trafic le soir, le cloud alloue plus de VM, puis réduit quand la charge baisse.  
- C’est une forme de **scalabilité automatisée**.

### Haute Disponibilité (High Availability – HA)
- Concept qui garantit que le service reste accessible malgré des pannes.  
- On utilise la redondance (multi‑AZ, load balancer).  
- Exemple : système bancaire, Facebook.

---

## 6. Reprise après sinistre et objectifs de performance

### Disaster Recovery (DR)
- Ensemble de politiques et d’outils pour restaurer un système après une catastrophe (sinistre).  
- Inclut les sauvegardes, la réplication vers une autre région.

### RPO et RTO
- **RPO (Recovery Point Objective)** : âge maximal des données que l’on est prêt à perdre (ex. 1 heure → sauvegardes horaires).  
- **RTO (Recovery Time Objective)** : temps maximal acceptable pour restaurer le service.

### SLA, SLO, SLI
- **SLA (Service Level Agreement)** : contrat définissant le niveau de service garanti (ex. 99,9 % de disponibilité).  
- **SLO (Service Level Objective)** : objectif interne (souvent plus strict que le SLA).  
- **SLI (Service Level Indicator)** : mesure réelle de la performance (ex. temps de réponse, taux d’erreur).

---

> **Résumé** :  
> - Cloud = location de ressources informatiques (VM, stockage, etc.) via Internet.  
> - Trois modèles : public, private, hybrid.  
> - Concepts clés : virtualisation, région/AZ, scalabilité, élasticité, HA, DR.  
> - Azure (et AWS/GCP) proposent ces services à l’échelle mondiale.

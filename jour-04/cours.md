## Sommaire

1. [Introduction à la virtualisation et aux VM Azure](#1-introduction-à-la-virtualisation-et-aux-vm-azure)
2. [Azure Spot : exécution à prix réduit](#2-azure-spot--exécution-à-prix-réduit)
3. [Présentation des familles de VM Azure](#3-présentation-des-familles-de-vm-azure)
4. [Famille B – Burstable (économique)](#4-famille-b--burstable-économique)
5. [Famille D – General purpose (polyvalente)](#5-famille-d--general-purpose-polyvalente)
6. [Famille E – Memory optimized (mémoire optimisée)](#6-famille-e--memory-optimized-mémoire-optimisée)
7. [Famille F – Compute optimized (calcul optimisé)](#7-famille-f--compute-optimized-calcul-optimisé)
8. [Famille H – High Performance Computing (HPC)](#8-famille-h--high-performance-computing-hpc)
9. [Famille L – Storage optimized (stockage optimisé)](#9-famille-l--storage-optimized-stockage-optimisé)
10. [Famille M – Memory ultra-optimized (mémoire ultra optimisée)](#10-famille-m--memory-ultra-optimized-mémoire-ultra-optimisée)
11. [Famille N – GPU accelerated (accélération graphique)](#11-famille-n--gpu-accelerated-accélération-graphique)
12. [VM Scale Sets : mise à l’échelle automatique](#12-vm-scale-sets--mise-à-léchelle-automatique)
13. [Azure Cloud Shell](#13-azure-cloud-shell)
14. [Exemple pratique : Déployer Jenkins sur une VM](#14-exemple-pratique--déployer-jenkins-sur-une-vm)

---

## 1. Introduction à la virtualisation et aux VM Azure

### Hyperviseur et virtualisation

L'**hyperviseur** est le logiciel qui s'exécute sur le serveur physique et permet de créer et d'exécuter des machines virtuelles. C'est le fondement de la virtualisation.

La **virtualisation** est le processus de création d'une version virtuelle d'une ressource physique, telle qu'un serveur, un réseau ou un périphérique de stockage.

Dans Azure, chaque machine virtuelle (VM) est une émulation logicielle d'un ordinateur physique. Elle comprend :
- **CPU** (vCPU)
- **RAM**
- **Stockage** (disque temporaire, disques managés)
- **Réseau** (carte réseau virtuelle)

Les VM sont déployées sur l'infrastructure physique des datacenters Azure, virtualisée via un hyperviseur (propriétaire Microsoft).

### Workflow de création

Pour créer une VM, on passe par le portail Azure, Azure CLI, PowerShell ou des modèles ARM. La ressource est enregistrée dans un Resource Group et gérée par Azure Resource Manager.

---

## 2. Azure Spot : exécution à prix réduit

**Azure Spot Virtual Machines** (anciennement "Low Priority") permet de bénéficier de capacités de calcul inutilisées à un tarif fortement réduit (jusqu'à 90 % par rapport au prix standard).

**Caractéristiques :**
- Idéal pour les charges de travail tolérantes aux interruptions : tests, batch processing, environnements de développement, POC (proof of concept).
- Azure peut récupérer la capacité à tout moment avec un préavis de 30 secondes.
- Pas de contrat SLA pour la disponibilité.
- Facturation à la seconde (ou à l'heure selon la région).

**Utilisation typique :**
- Jobs batch asynchrones
- Environnements de non-production
- Traitements de données volumineux pouvant être interrompus et repris

> **Attention** : Ne pas utiliser pour des applications critiques ou des bases de données en production.

---

## 3. Présentation des familles de VM Azure

Azure propose une large gamme de familles de VM, classées par usage et optimisées pour différents types de charges de travail. Chaque famille se décline en plusieurs séries (générations) avec des processeurs Intel, AMD ou ARM.

Voici les principales familles (d'après la page [Azure VM series](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/series/)) :

| Famille | Type | Description |
|---------|------|-------------|
| **B** | Burstable | VM économiques avec capacité de « burst » pour les pics d'activité |
| **D** | General purpose | Équilibre CPU/mémoire pour la plupart des charges de production |
| **E** | Memory optimized | Mémoire élevée (8 Go par vCPU) pour applications in-memory |
| **F** | Compute optimized | Ratio CPU/mémoire élevé pour calcul intensif |
| **H** | HPC | Haute performance pour calcul scientifique et technique |
| **L** | Storage optimized | Stockage local haute performance (NVMe) pour bases de données NoSQL |
| **M** | Ultra memory | Mémoire massive (jusqu'à 32 To) pour SAP HANA, etc. |
| **N** | GPU | Accélération graphique pour IA, rendu, visualisation |

---

## 4. Famille B – Burstable (économique)

Les VM de la famille **B** (Burstable) sont conçues pour les charges de travail qui fonctionnent généralement à un faible niveau d'utilisation CPU, mais qui ont besoin de « pics » (bursts) occasionnels. Elles accumulent des crédits CPU lorsqu'elles sont en dessous de la ligne de base et les consomment lors des bursts.

**Processeurs :**
- **Basv2** : AMD EPYC 3e génération (7763v) multi-threaded
- **Bsv2** : Intel Xeon Platinum 8370C (Ice Lake) hyper-threaded

**Mémoire :** De 0.5 à 4 Go par vCPU selon la taille.

**Stockage :** Support Premium SSD, Premium SSD v2, Ultra Disk.

**Cas d'usage typiques :**
- Serveurs de développement et de test
- Petits serveurs web à faible trafic
- Microservices
- Preuves de concept (POC)
- Petites bases de données

**Tarification :** À partir de **3,80 $/mois** (Linux) – extrêmement économique.

---

## 5. Famille D – General purpose (polyvalente)

La famille **D** est la plus utilisée d'Azure. Elle offre un bon équilibre entre vCPU, mémoire et stockage temporaire, convenant à la plupart des charges de production.

**Variantes :**
- **Mid-memory** (Das, Dds, Dsv, etc.) : 4 Go de RAM par vCPU
- **Low-memory** (Dal, Dls, Dpl) : 2 Go de RAM par vCPU
- **Confidential computing** (DCas) : protection mémoire AMD SEV-SNP

**Processeurs disponibles :**
- **AMD** : EPYC 9005 (5e gén), 9004 (4e gén), 7763v (3e gén)
- **Intel** : Xeon Platinum 8573C (5e gén), 8370C (3e gén)
- **ARM** : Azure Cobalt 100 (64 bits), Ampere Altra

**Mémoire max :** Jusqu'à 768 Go (Intel) / 640 Go (AMD)

**Stockage :** Support Premium SSD, Premium SSD v2, Ultra Disk. Certaines séries incluent un disque temporaire NVMe local.

**Cas d'usage :**
- Applications d'entreprise
- Systèmes e-commerce
- Frontaux web
- Solutions de virtualisation de bureau
- Bases de données petites à moyennes
- Serveurs de jeux

**Tarification :** À partir de **41,61 $/mois** (Linux)

---

## 6. Famille E – Memory optimized (mémoire optimisée)

Les VM **E** offrent 8 Go de RAM par vCPU, idéales pour les applications gourmandes en mémoire.

**Processeurs :**
- **AMD** : EPYC 9005 (5e gén), 9004 (4e gén), 7763v (3e gén)
- **Intel** : Xeon Platinum 8573C, 8370C
- **ARM** : Azure Cobalt 100, Ampere Altra

**Mémoire max :** Jusqu'à 1 832 Go (Intel) / 1 280 Go (AMD)

**Séries spéciales :**
- **Ebsv5 / Ebdsv5** : hautes performances de stockage distant (jusqu'à 260 000 IOPS)
- **ECas** : confidential computing AMD

**Cas d'usage :**
- SAP HANA, SAP S/4 HANA
- Grandes bases de données relationnelles (SQL Server, Oracle)
- Data warehousing
- Applications métier critiques
- Analyses en mémoire (in-memory analytics)

**Tarification :** À partir de **58,40 $/mois** (Linux)

---

## 7. Famille F – Compute optimized (calcul optimisé)

La famille **F** offre un ratio CPU/mémoire élevé (2 Go de RAM par vCPU) et est conçue pour les charges de calcul intensif.

**Particularité :** Certaines séries (Fasv7, Falsv7) ne sont pas multithreadées : un vCPU correspond à un cœur physique complet.

**Processeurs :**
- **AMD** : EPYC 9005 (5e gén), 9004 (4e gén)
- **Intel** : Xeon Platinum 8573C (FXmsv2)

**Mémoire max :** Jusqu'à 640 Go (AMD) / 1 832 Go (Intel)

**Séries :**
- **Fasv7 / Fadsv7** : mid-memory (4 Go par vCPU)
- **Falsv7 / Faldsv7** : low-memory (2 Go par vCPU)
- **Famsv7 / Famdsv7** : high-memory (8 Go par vCPU)
- **FXmsv2** : high-memory Intel pour EDA et SQL

**Cas d'usage :**
- Traitement par lots (batch processing)
- Serveurs web à fort trafic
- Analyses
- Jeux en ligne
- Electronic Design Automation (EDA)

**Tarification :** À partir de **35,77 $/mois** (Linux)

---

## 8. Famille H – High Performance Computing (HPC)

Les VM **H** sont optimisées pour les charges HPC (calcul haute performance) nécessitant une bande passante mémoire élevée et un réseau InfiniBand à faible latence.

**Séries :**
- **HB** : optimisé mémoire (bande passante) – processeurs AMD EPYC
- **HC** : optimisé calcul intensif – Intel Xeon Platinum

**Caractéristiques :**
- Pas de multithreading (1 cœur physique par vCPU)
- Jusqu'à 352 cœurs AMD EPYC
- 7 To/s de bande passante mémoire
- InfiniBand 800 Gb/s
- Disques SSD haute performance

**Cas d'usage :**
- Dynamique des fluides
- Modélisation météo
- Simulation moléculaire
- Calcul sismique
- Analyse de risques
- Rendu 3D (HPC)

**Tarification :** À partir de **581,08 $/mois** (Linux)

---

## 9. Famille L – Storage optimized (stockage optimisé)

Les VM **L** sont conçues pour les applications nécessitant un stockage local à faible latence et un débit élevé, comme les bases de données NoSQL.

**Caractéristiques :**
- Disques NVMe locaux directement mappés
- 8 Go de RAM par vCPU
- Jusqu'à 23 To de stockage NVMe local

**Processeurs :**
- **AMD** : EPYC 9004 (Genoa) – Lasv4, Laosv4 ; EPYC 7763v – Lasv3
- **Intel** : Xeon Platinum 8573C – Lsv4 ; Xeon 8370C – Lsv3

**Séries :**
- **Lasv4** : 240 Go NVMe par vCPU
- **Laosv4** : 720 Go NVMe par vCPU (IO renforcé)
- **Lsv4** : Intel, 240 Go NVMe par vCPU
- **Lasv3 / Lsv3** : générations précédentes

**Cas d'usage :**
- Cassandra, MongoDB, Cloudera
- Redis
- Data warehousing
- Bases de données transactionnelles volumineuses

**Tarification :** À partir de **455,52 $/mois** (Linux)

---

## 10. Famille M – Memory ultra-optimized (mémoire ultra optimisée)

La famille **M** est l'offre « extreme memory » d'Azure, destinée aux charges nécessitant plusieurs téraoctets de RAM.

**Caractéristiques :**
- Mémoire de 4 To à 32 To selon la série
- Processeurs Intel Xeon Scalable 4e génération
- IOPS de stockage distant jusqu'à 650 000
- Bande passante réseau jusqu'à 185 Gbps

**Séries :**
- **Mbsv3 / Mbdsv3** : mémoire et stockage optimisés (4 To max)
- **Msv3-medium / Mdsv3-medium** : 4 To
- **Msv3-high / Mdsv3-high** : jusqu'à 16 To
- **Msv3-very high** : jusqu'à 32 To
- **Msv2 / Mdsv2** : génération précédente

**Cas d'usage :**
- SAP HANA (très grandes instances)
- SQL Server Hekaton
- Data warehousing à très grande échelle

**Tarification :** À partir de **1 121,28 $/mois** (Linux)

---

## 11. Famille N – GPU accelerated (accélération graphique)

Les VM **N** intègrent des GPU (NVIDIA ou AMD) pour les charges de calcul intensif graphique ou IA.

**Trois sous-familles :**

| Série | GPU | Usage principal |
|-------|-----|-----------------|
| **ND** | NVIDIA A100, H100, H200, GB200, AMD MI300X | Deep learning, IA training, inference |
| **NC** | NVIDIA A100, H100 | Calcul HPC, simulations, rendu temps réel |
| **NV** | NVIDIA Tesla M60, A10, AMD Radeon MI25 | Virtualisation de postes de travail, visualisation 3D, IA légère |

**Caractéristiques additionnelles :**
- InfiniBand ultra faible latence sur ND et NC
- Réseau haut débit optimisé pour streaming sur NV

**Cas d'usage :**
- Entraînement de modèles d'IA (fine-tuning, distillation)
- Systèmes agentiques, jumeaux numériques
- Robotique (Physical AI)
- Rendu 3D interactif
- Visualisation à distance

**Tarification :** Variable selon la configuration GPU, généralement élevée.

---

## 12. VM Scale Sets : mise à l’échelle automatique

**VM Scale Sets** est une fonctionnalité Azure qui permet de créer et gérer un ensemble de VM identiques, avec mise à l'échelle automatique (auto scaling).

**Principes :**
- On définit une configuration de VM (image, taille, etc.)
- Azure ajuste automatiquement le nombre d'instances en fonction de la charge (CPU, file d'attente, etc.)
- Possibilité de scaling manuel ou basé sur des métriques

**Avantages :**
- Haute disponibilité
- Élasticité
- Intégration avec Azure Load Balancer
- Gestion centralisée des mises à jour

**Utilisation typique :**
- Applications web à trafic variable
- Microservices
- Traitements batch parallélisés

---

## 13. Azure Cloud Shell

**Azure Cloud Shell** est un terminal interactif accessible depuis le portail Azure (ou via shell.azure.com). Il propose deux environnements : **Bash** et **PowerShell**.

**Caractéristiques :**
- Session authentifiée automatiquement avec vos identifiants Azure
- Outils préinstallés : Azure CLI, PowerShell, kubectl, terraform, etc.
- Stockage persistant de 5 Go (fichiers utilisateur)

**Pourquoi les DevOps ne l'utilisent pas toujours ?**
- Cloud Shell est pratique pour des tâches ponctuelles ou de découverte.
- Mais les ingénieurs DevOps préfèrent souvent leurs propres terminaux locaux avec leurs configurations personnalisées, ou des environnements d'intégration continue (CI/CD).
- Cloud Shell a une durée de session limitée et n'est pas adapté à l'automatisation lourde.

**Quand l'utiliser :**
- Prise en main rapide d'Azure
- Tests sans installation locale
- Accès depuis un poste restreint (pas d'installation possible)

---

## 14. Exemple pratique : Déployer Jenkins sur une VM

Nous allons illustrer le déploiement d'un serveur Jenkins sur une VM Azure (famille D, par exemple) en utilisant Azure CLI.

### Étapes

1. **Créer un Resource Group**
   ```bash
   az group create --name jenkins-rg --location francecentral
   ```

2. **Créer une VM Linux (Ubuntu)**
   ```bash
   az vm create \
     --resource-group jenkins-rg \
     --name jenkins-vm \
     --image UbuntuLTS \
     --admin-username azureuser \
     --generate-ssh-keys \
     --size Standard_D2s_v3
   ```

3. **Ouvrir le port 8080 (Jenkins)**
   ```bash
   az vm open-port --port 8080 --resource-group jenkins-rg --name jenkins-vm
   ```

4. **Se connecter à la VM en SSH**
   ```bash
   ssh -i votre-fichier-pem azureuser@<public-ip>
   ```

5. **Installer Jenkins** documentation ici: https://www.jenkins.io/doc/book/installing/linux/
   ```bash
   sudo apt update
   sudo apt install openjdk-11-jdk -y
   wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
   sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
   sudo apt update
   sudo apt install jenkins -y
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ```

6. **Vérifier le processus Jenkins**
   ```bash
   ps -ef | grep jenkins
   ```

7. **Obtenir le mot de passe initial**
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

8. **Accéder à Jenkins**  
   Ouvrir un navigateur sur `http://<public-ip>:8080` et saisir le mot de passe.

### Règle de sécurité (Network Security Group)
L'étape `az vm open-port` a automatiquement ajouté une règle **inbound** sur le port 8080 dans le groupe de sécurité réseau (NSG) associé à la VM. Vous pouvez également le faire manuellement via le portail.

---

## Conclusion

Azure offre une richesse de familles de VM pour couvrir tous les besoins, des plus économiques (B) aux plus extrêmes (M, N). Le choix de la bonne famille dépend de la charge de travail : généraliste (D), mémoire (E), calcul (F), HPC (H), stockage (L), ou GPU (N). Les **VM Scale Sets** apportent l'élasticité, tandis qu'**Azure Spot** permet de réduire les coûts pour les workloads interruptibles. Enfin, des outils comme **Azure Cloud Shell** facilitent la gestion, mais les professionnels préfèrent souvent leurs environnements locaux pour l'automatisation.

> **Référence** : Pour une liste à jour des tailles et prix, consultez la [documentation officielle Azure](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/series/).

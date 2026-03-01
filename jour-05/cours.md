# Cours Complet : Azure Networking Services

## Sommaire

1. [Introduction aux réseaux dans Azure](#1-introduction-aux-réseaux-dans-azure)
2. [Azure Virtual Network (VNet) – Le réseau virtuel](#2-azure-virtual-network-vnet--le-réseau-virtuel)
   - 2.1 Qu’est‑ce qu’un VNet ?
   - 2.2 Pourquoi utiliser un VNet ?
3. [Planification d’un VNet : adressage IP et CIDR](#3-planification-dun-vnet--adressage-ip-et-cidr)
   - 3.1 Qu’est‑ce que le CIDR ?
   - 3.2 Choisir un bloc CIDR pour son VNet
   - 3.3 Créer des sous‑réseaux (subnets)
4. [Sécuriser les sous‑réseaux avec les Network Security Groups (NSG)](#4-sécuriser-les-sous-réseaux-avec-les-network-security-groups-nsg)
   - 4.1 Définition d’un NSG
   - 4.2 Règles de sécurité (inbound / outbound)
   - 4.3 Association d’un NSG à un subnet ou à une carte réseau
   - 4.4 Cas pratique : isoler une base de données
5. [Affiner la sécurité avec les Application Security Groups (ASG)](#5-affiner-la-sécurité-avec-les-application-security-groups-asg)
   - 5.1 Principe de l’ASG
   - 5.2 Exemple d’utilisation
6. [Architecture type : application à trois tiers (Web, App, DB)](#6-architecture-type--application-à-trois-tiers-web-app-db)
   - 6.1 Conception du VNet et des subnets
   - 6.2 Règles NSG pour chaque niveau
   - 6.3 Intégration des ASG pour une gestion simplifiée
7. [Autres services réseau Azure (aperçu)](#7-autres-services-réseau-azure-aperçu)
   - 7.1 Azure Load Balancer
   - 7.2 Azure VPN Gateway
   - 7.3 Azure DNS
8. [Conclusion et bonnes pratiques](#8-conclusion-et-bonnes-pratiques)

---

## 1. Introduction aux réseaux dans Azure

Dans le cloud, les ressources (machines virtuelles, bases de données, applications) ont besoin de communiquer entre elles et avec l’extérieur de manière sécurisée. Azure fournit une gamme de services réseau pour créer des topologies complexes et isolées. Le composant fondamental est le **Virtual Network (VNet)** , qui permet de définir votre propre espace réseau privé dans le cloud.

Ce cours vous guide à travers les concepts essentiels de la mise en réseau sur Azure : création d’un VNet, choix des plages d’adresses (CIDR), découpage en sous‑réseaux, et sécurisation des flux avec les **Network Security Groups (NSG)** et les **Application Security Groups (ASG)**.

---

## 2. Azure Virtual Network (VNet) – Le réseau virtuel

### 2.1 Qu’est‑ce qu’un VNet ?

Un **Virtual Network (VNet)** est une représentation logicielle de votre propre réseau dans le cloud. C’est un **isolat logique** dédié à votre abonnement Azure. À l’intérieur d’un VNet, vous pouvez déployer des ressources Azure (VM, App Service Environments, etc.) et les connecter entre elles de manière privée.

Chaque VNet possède son propre espace d’adressage IP, défini en **CIDR** (Classless Inter‑Domain Routing), et peut être divisé en **sous‑réseaux (subnets)** .

### 2.2 Pourquoi utiliser un VNet ?

Prenons un exemple simple : deux utilisateurs, Donald et Franck, déploient chacun une VM dans la région East US. Sans VNet, ces VM seraient directement exposées sur le réseau partagé du datacenter, avec un risque accru d’accès non autorisé. En les plaçant dans des VNets distincts (ou même dans le même VNet avec des subnets isolés), on crée une frontière de sécurité. Les communications entre ressources de différents VNets peuvent être contrôlées (peering, VPN).

**Objectifs principaux :**
- **Isolation** : chaque VNet est isolé des autres par défaut.
- **Sécurité** : vous définissez qui peut entrer et sortir.
- **Connectivité** : vous pouvez connecter des VNets entre eux ou à votre réseau sur site (hybride).

---

## 3. Planification d’un VNet : adressage IP et CIDR

### 3.1 Qu’est‑ce que le CIDR ?

Le **CIDR (Classless Inter‑Domain Routing)** est une méthode de notation des adresses IP et de leurs masques de sous‑réseau. Elle s’écrit sous la forme `x.x.x.x/y`, où `y` est le nombre de bits de réseau.

Exemple : `10.0.0.0/16` signifie que les 16 premiers bits identifient le réseau, laissant 16 bits pour les hôtes, soit 65 536 adresses.

### 3.2 Choisir un bloc CIDR pour son VNet

Azure recommande d’utiliser des plages d’adresses privées (RFC 1918) :
- `10.0.0.0/8` (10.0.0.0 – 10.255.255.255)
- `172.16.0.0/12` (172.16.0.0 – 172.31.255.255)
- `192.168.0.0/16` (192.168.0.0 – 192.168.255.255)

**Règles de base :**
- Le bloc CIDR ne doit pas chevaucher d’autres réseaux avec lesquels vous prévoyez de vous connecter (peering, VPN).
- Prévoyez suffisamment d’adresses pour la croissance future.
- Exemple pour une application simple : `10.1.0.0/16` (65 536 adresses).

### 3.3 Créer des sous‑réseaux (subnets)

Un VNet est découpé en **subnets** pour organiser et sécuriser les ressources.

- **Subnet public** : généralement pour les serveurs web accessibles depuis Internet.
- **Subnet privé** : pour les bases de données ou les applications internes.

Exemple de découpage avec le VNet `10.1.0.0/16` :
- Subnet Web : `10.1.1.0/24` (256 adresses)
- Subnet App : `10.1.2.0/24`
- Subnet DB : `10.1.3.0/24`

Chaque subnet hérite du routage du VNet, mais peut avoir ses propres règles de sécurité (NSG).

---

## 4. Sécuriser les sous‑réseaux avec les Network Security Groups (NSG)

### 4.1 Définition d’un NSG

Un **Network Security Group (NSG)** est un pare‑feu distribué qui filtre le trafic réseau à destination et en provenance des ressources Azure. Il contient une liste de règles de sécurité évaluées par priorité.

### 4.2 Règles de sécurité (inbound / outbound)

Chaque règle spécifie :
- **Nom** et **priorité** (les règles avec la priorité la plus basse sont appliquées en premier).
- **Source** / **Destination** : adresse IP, service tag (ex: `Internet`), ou **Application Security Group**.
- **Protocole** : TCP, UDP, ICMP, ou Any.
- **Plage de ports**.
- **Action** : Autoriser ou Refuser.

Il existe des règles par défaut (ex: tout refusé sauf le trafic interne du VNet et les équilibreurs de charge), mais vous pouvez ajouter vos propres règles.

### 4.3 Association d’un NSG à un subnet ou à une carte réseau

Un NSG peut être associé à :
- Un **subnet** : les règles s’appliquent à tout le trafic entrant/sortant des ressources dans ce subnet.
- Une **carte réseau (NIC)** : les règles s’appliquent uniquement à cette VM spécifique.

Si un NSG est attaché au subnet et un autre à la NIC, les deux sont évalués (le plus restrictif s’applique).

### 4.4 Cas pratique : isoler une base de données

Imaginons que personne ne doive accéder à la base de données (DB) depuis Internet, mais que l’application métier (dans le subnet App) doive pouvoir s’y connecter.

**Solution avec NSG sur le subnet DB :**
- Règle 100 : Autoriser TCP/1433 (SQL Server) depuis la source `10.1.2.0/24` (subnet App).
- Règle 200 : Refuser tout autre trafic entrant.

Ainsi, seules les ressources du subnet App peuvent joindre la DB sur le port SQL.

---

## 5. Affiner la sécurité avec les Application Security Groups (ASG)

### 5.1 Principe de l’ASG

Un **Application Security Group (ASG)** vous permet de regrouper logiquement des machines virtuelles (ou d’autres ressources) et de les référencer par leur nom dans les règles NSG, plutôt que par des plages d’adresses IP.

**Avantages :**
- Les règles deviennent plus lisibles et maintenables.
- On peut ajouter ou retirer des VM d’un ASG sans modifier les règles NSG.
- Idéal pour des architectures où les adresses IP changent (auto‑scaling).

### 5.2 Exemple d’utilisation

Reprenons l’exemple précédent : au lieu d’autoriser tout le subnet App (`10.1.2.0/24`), on souhaite que seules certaines VM de l’application (celles qui ont besoin de la base) puissent y accéder.

1. Créer un ASG nommé `ASG_App_SQL`.
2. Ajouter les VM concernées à cet ASG.
3. Dans la règle NSG du subnet DB, définir la source comme `ASG_App_SQL` au lieu de la plage IP.

Résultat : seules les VM membres de l’ASG peuvent communiquer avec la DB, indépendamment de leur adresse IP.

---

## 6. Architecture type : application à trois tiers (Web, App, DB)

### 6.1 Conception du VNet et des subnets

On crée un VNet `10.0.0.0/16` avec trois subnets :
- **WebSubnet** : `10.0.1.0/24` – contient les serveurs web accessibles depuis Internet.
- **AppSubnet** : `10.0.2.0/24` – contient la logique métier (API, application).
- **DBSubnet** : `10.0.3.0/24` – contient les bases de données.

### 6.2 Règles NSG pour chaque niveau

- **NSG_Web** (associé à WebSubnet) :
  - Autoriser HTTP/HTTPS (80,443) depuis Internet.
  - Autoriser SSH (22) depuis une plage d’administration (ex: IP du bureau).
  - Refuser tout le reste.

- **NSG_App** (associé à AppSubnet) :
  - Autoriser le trafic depuis WebSubnet (sur le port de l’API, ex: 8080).
  - Autoriser SSH depuis la plage d’admin.
  - Refuser Internet direct.

- **NSG_DB** (associé à DBSubnet) :
  - Autoriser SQL (1433) depuis AppSubnet uniquement.
  - Refuser tout autre trafic.

### 6.3 Intégration des ASG pour une gestion simplifiée

Pour plus de finesse, on peut créer des ASG :
- **ASG_WebServers** : VM web.
- **ASG_AppServers** : VM applicatives.
- **ASG_DBServers** : VM bases de données.

Puis les règles deviennent :
- Dans NSG_App : autoriser le trafic depuis ASG_WebServers sur le port applicatif.
- Dans NSG_DB : autoriser le trafic depuis ASG_AppServers sur le port SQL.

Ainsi, si on ajoute une nouvelle VM web, on l’inclut simplement dans ASG_WebServers, et la communication fonctionne sans toucher aux NSG.

---

## 7. Autres services réseau Azure (aperçu)

### 7.1 Azure Load Balancer
Distribue le trafic entrant entre plusieurs VM (dans un subnet) pour assurer la haute disponibilité et la scalabilité.

### 7.2 Azure VPN Gateway
Permet de connecter votre VNet à votre réseau local via un tunnel VPN sécurisé (site‑to‑site) ou à des clients individuels (point‑to‑site).

### 7.3 Azure DNS
Service d’hébergement de domaines DNS, intégré avec Azure pour la résolution de noms.

### 7.4 Azure Firewall
Pare‑feu managé avec inspection des couches 3 à 7, centralisé pour l’ensemble du VNet.

---

## 8. Conclusion et bonnes pratiques

- **Toujours commencer par planifier son adressage CIDR** en évitant les chevauchements.
- **Utiliser des NSG** pour segmenter et sécuriser les sous‑réseaux.
- **Privilégier les ASG** pour rendre les règles plus lisibles et évolutives.
- **Ne jamais exposer directement une base de données sur Internet** : toujours la placer dans un subnet privé avec des règles restrictives.
- **Combiner NSG et autres services** (Load Balancer, Firewall) pour une défense en profondeur.

En maîtrisant ces concepts, vous serez capable de concevoir des architectures réseau robustes, isolées et sécurisées sur Microsoft Azure.

---

> **Résumé des termes clés à retenir :**
> - **VNet** : réseau virtuel isolé.
> - **CIDR** : notation d’adressage IP.
> - **Subnet** : sous‑réseau.
> - **NSG** : groupe de sécurité réseau (pare‑feu).
> - **ASG** : groupe de sécurité applicatif (regroupement logique).
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
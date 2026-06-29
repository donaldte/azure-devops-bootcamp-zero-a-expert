# 🎥 COURS YouTube - PARTIE 2 : Déploiement Continu avec AKS et ArgoCD

---

## 📌 Introduction

Bonjour à tous et bienvenue dans cette deuxième partie du cours !

Dans la première partie, nous avons vu comment construire notre application et automatiser les tests via une pipeline CI. Aujourd'hui, nous allons passer à l'étape suivante, et pas des moindres : **le déploiement en production** !

Au programme de cette vidéo :
- Le stage Deploy dans notre pipeline
- La mise en place d'un cluster **AKS** (Azure Kubernetes Service)
- L'utilisation d'**ArgoCD** pour le GitOps

Attachez vos ceintures, on démarre ! 🚀

---

## 1️⃣ Pourquoi ajouter un stage Deploy ?

### Le constat

Jusqu'ici, nous avions :
- ✅ Un build automatisé
- ✅ Des tests exécutés à chaque commit
- ❌ Mais un déploiement manuel en production

### La solution

Nous allons ajouter un **troisième stage** à notre pipeline : le stage **Deploy**.

**Objectif :** Automatiser la mise en production de notre application.

### Ce que ça va faire concrètement

1. Construire l'image Docker
2. La pousser vers notre registre de conteneurs (ACR)
3. Mettre à jour nos fichiers de configuration Kubernetes
4. Déclencher le déploiement sur notre cluster

### Les bénéfices

- **Plus d'erreurs humaines** : tout est automatisé
- **Traçabilité** : chaque déploiement est lié à un commit
- **Rapidité** : on déploie en quelques minutes au lieu de plusieurs heures

---

## 2️⃣ Le cluster AKS, kesako ?

### Définition simple

**AKS** (Azure Kubernetes Service) est le service de Kubernetes proposé par Microsoft Azure.

C'est comme avoir un **orchestrateur de conteneurs managé** dans le cloud.

### En quoi c'est intéressant ?

| Avantage | Explication |
|----------|-------------|
| **Managé** | Azure s'occupe du master (plan de contrôle), toi tu gères juste les workers |
| **Intégré** | Fonctionne nativement avec Azure AD, ACR, les réseaux, etc. |
| **Auto-scalable** | Le cluster s'adapte automatiquement à la charge |
| **Sécurisé** | Authentification via Azure Active Directory |

### Comment ça s'articule avec notre app ?

Notre application tourne **dans des pods** sur ce cluster. Ces pods sont :
- Orchestrés par Kubernetes
- Exposés via des Services
- Accessibles depuis l'extérieur via un Ingress

### En résumé

AKS, c'est notre **plateforme d'exécution**. C'est là que notre application va vivre en production.

---

## 3️⃣ ArgoCD et le GitOps, la révolution

### C'est quoi ArgoCD ?

**ArgoCD** est un outil de déploiement continu basé sur le principe du **GitOps**.

### Le GitOps, c'est quoi ?

C'est une philosophie où **Git est la source de vérité** pour votre infrastructure.

**Principe :**
- Toute la configuration est dans Git
- ArgoCD surveille ce dépôt en permanence
- Si un changement est détecté, ArgoCD l'applique automatiquement sur le cluster

### Le fonctionnement en image

```
📁 Dépôt Git (manifests Kubernetes)
         ↓
👁️ ArgoCD surveille
         ↓
🔄 Changement détecté (nouvelle version d'image)
         ↓
⚡ ArgoCD synchronise le cluster
         ↓
☸️ AKS applique les changements
```

### Pourquoi c'est génial ?

| Avantage | Explication |
|----------|-------------|
| **Versionné** | Toute config est dans Git, on peut revenir en arrière |
| **Auto-réparation** | Si le cluster dérive, ArgoCD le corrige |
| **Audit** | On sait qui a changé quoi et quand |
| **Déclaratif** | On décrit ce qu'on veut, ArgoCD s'occupe du reste |

### La différence entre déploiement "classique" et GitOps

| Approche classique | Approche GitOps |
|--------------------|-----------------|
| On pousse l'image vers le registry | On pousse l'image vers le registry |
| On se connecte au cluster manuellement | On met à jour les manifests Git |
| On exécute des commandes kubectl | ArgoCD détecte et applique |
| Risque d'erreur humain | Automatique et fiable |

---

## 4️⃣ Comment tout s'articule ensemble ?

### Le workflow complet

```
1. Tu pousses ton code sur GitLab/GitHub
         ↓
2. Pipeline CI : Build → Test (validé)
         ↓
3. Pipeline CD : Stage Deploy
         ↓
4. L'image Docker est poussée vers ACR
         ↓
5. Le fichier deployment.yaml est mis à jour dans le repo GitOps
         ↓
6. ArgoCD détecte le changement
         ↓
7. ArgoCD synchronise le cluster AKS
         ↓
8. L'application est déployée en production ✅
```

### Les acteurs en jeu

| Acteur | Rôle |
|--------|------|
| **Pipeline CI/CD** | Automatise le build, les tests et le déploiement |
| **ACR** | Stocke les images Docker |
| **Dépôt GitOps** | Contient les manifests Kubernetes |
| **ArgoCD** | Synchronise le cluster avec le dépôt GitOps |
| **AKS** | Héberge et exécute l'application |

---

## 5️⃣ Les concepts clés à retenir

### Le déploiement déclaratif

Au lieu de donner des **ordres** (impératif), on décrit un **état désiré** (déclaratif).

- **Impératif** : "kubectl create deployment nginx --image=nginx"
- **Déclaratif** : "Voici un fichier YAML qui décrit un deployment nginx"

### La réconciliation

C'est le mécanisme par lequel ArgoCD vérifie en continu que le cluster correspond à ce qui est déclaré dans Git.

Si quelqu'un modifie le cluster manuellement, ArgoCD **rétablit l'état désiré** automatiquement.

### L'immutabilité

À chaque déploiement, on crée **de nouveaux pods**. On ne modifie jamais les pods existants.

**Avantage :** Si quelque chose ne va pas, on peut revenir en arrière instantanément.

---

## 6️⃣ Ce qu'il faut retenir de cette partie

1. **Le stage Deploy** automatise la mise en production
2. **AKS** est notre cluster Kubernetes managé sur Azure
3. **ArgoCD** applique le principe du GitOps
4. **Git est la source de vérité** pour notre infrastructure
5. L'ensemble forme un **workflow CI/CD complet et fiable**

### Le schéma mental à garder

```
CODE → BUILD → TEST → DEPLOY → ARGOCD → AKS → PRODUCTION
```

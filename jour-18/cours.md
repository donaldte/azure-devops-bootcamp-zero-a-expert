

### **Description du Tutoriel : Migration d'une Pipeline CI vers Azure DevOps**

Ce tutoriel documente la migration complète d'une pipeline d'intégration continue (CI) depuis **GitHub Actions** vers **Azure DevOps**, en l'appliquant à une application de vote distribuée (projet `example-voting-app`). L'objectif principal est de démontrer comment orchestrer un pipeline CI robuste en utilisant des composants Azure natifs, tout en conservant le code source sur GitHub.

#### **Contexte et Projet Support**

Le projet d'exemple, [`example-voting-app`](https://github.com/donaldte/example-voting-app), est une application polyglotte (Python, Node.js, .NET, Redis, Postgres) typique des architectures microservices. Le pipeline CI existant sur GitHub Actions a été entièrement recréé sur Azure DevOps pour tirer parti de ses fonctionnalités avancées de gestion des pipelines et d'intégration avec l'écosystème Azure.

#### **Infrastructure et Agents Personnalisés**

Une des spécificités majeures de ce tutoriel est la mise en place d'une infrastructure dédiée :

*   **Agent Auto-Hébergé** : Au lieu d'utiliser des agents Microsoft hébergés, nous avons créé notre propre agent Azure DevOps.
*   **Machine Virtuelle Sur-Mesure** : Cet agent est installé sur une **machine virtuelle (VM) Azure** que nous avons provisionnée et configurée manuellement. Cela permet un contrôle total sur l'environnement de build (dépendances, outils, ressources) et une meilleure maîtrise des coûts.

#### **Structure du Pipeline CI (Azure Pipelines - YAML)**

Le pipeline CI, entièrement codé en **YAML** (suivant les bonnes pratiques 2026), est découpé en plusieurs étapes logiques, reflétant les phases clés du cycle de développement :

1.  **Récupération du Code** : Le pipeline s'initialise en clonant le dépôt GitHub contenant le code source de l'application.

2.  **Tests Unitaires (Unit Testing)** : Pour chaque service (Python, .NET, Node.js), des tâches de test sont exécutées via les frameworks respectifs pour valider la logique métier à un niveau granulaire.

3.  **Analyse Statique du Code (Static Code Analysis)** :
    *   Intégration d'outils d'analyse (ex: SonarQube ou l'analyse CodeQL de GitHub Advanced Security) pour détecter les vulnérabilités et la dette technique.
    *   Les résultats sont publiés dans Azure DevOps, permettant un suivi de la qualité du code.

4.  **Construction des Images (Build)** :
    *   Les conteneurs Docker de chaque microservice (vote, worker, result) sont construits.
    *   Les images sont taguées avec un identifiant unique (généralement basé sur le numéro du build ou le hash du commit).

5.  **Tests de Bout en Bout (End-to-End Testing)** :
    *   Une fois les images construites, l'application complète est lancée (via `docker-compose`).
    *   Une suite de tests automatisés (ex: avec Selenium ou Playwright) valide le fonctionnement global de l'application (vote, stockage Redis, traitement par le worker, affichage des résultats).

6.  **Publication de l'Artéfact (Publish Artifact)** :
    *   Les images Docker construites (et taguées) sont considérées comme l'artéfact principal de la pipeline.
    *   **Push vers Azure Container Registry (ACR)** : L'étape finale consiste à pousser ces images vers un registre de conteneurs Azure (ACR), les rendant ainsi disponibles pour les pipelines de déploiement (CD) ultérieurs.

#### **Synthèse des Technologies et Compétences Mises en Œuvre**

| Domaine | Technologies / Concepts Utilisés |
| :--- | :--- |
| **Plateforme DevOps** | Azure DevOps (Pipelines, Repos intégré via GitHub), Agents auto-hébergés |
| **Infrastructure Cloud** | Machine Virtuelle Azure, Azure Container Registry (ACR) |
| **Conteneurisation** | Docker, Docker Compose |
| **CI / CD (YAML)** | Pipelines Azure en YAML, Définition de _stages_, _jobs_ et _steps_ |
| **Qualité & Sécurité** | Tests Unitaires (xUnit, Jest, pytest), Analyse Statique (SonarQube/CodeQL), Tests E2E |
| **Langages & Frameworks**| Python (Flask), .NET (C#), Node.js (Express) |

#### **Valeur Ajoutée du Tutoriel**

*   **Approche "From Scratch"** : Le tutoriel ne se contente pas de survoler la configuration ; il guide l'utilisateur à travers la **création de la VM**, l'**installation et la configuration de l'agent Azure DevOps**, et l'**écriture de chaque étape du pipeline YAML**.
*   **Cas Concret** : L'utilisation d'une application microservices réelle (et non d'un exemple "Hello World") rend l'apprentissage pertinent pour des scénarios professionnels.
*   **Exhaustivité** : En couvrant l'ensemble du cycle CI (du test au push vers le registre), ce tutoriel prépare le terrain pour une chaîne d'outils CI/CD complète.
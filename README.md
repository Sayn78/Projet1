# 🌐 Projet 1 - Déploiement Web Automatisé avec CI/CD

[![SonarCloud](https://sonarcloud.io/api/project_badges/measure?project=Sayn78_Projet1&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Sayn78_Projet1)
[![Quality Gate](https://sonarcloud.io/api/project_badges/quality_gate?project=Sayn78_Projet1)](https://sonarcloud.io/summary/new_code?id=Sayn78_Projet1)

---

## 📌 Présentation

Ce projet montre la mise en place d'une **chaîne DevOps complète** pour déployer automatiquement un site web HTML sur un serveur AWS EC2 via :

- Infrastructure as Code (Terraform)
- Configuration Management (Ansible)
- Conteneurisation (Docker)
- Intégration Continue (Jenkins)
- Analyse de code (SonarCloud)

---

## 🚀 Stack Technique

| Outil         | Rôle                                       |
|---------------|--------------------------------------------|
| **Terraform** | Provisionnement de l'infrastructure AWS    |
| **Ansible**   | Configuration de la machine (NGINX + Docker) |
| **Docker**    | Conteneurisation du site HTML              |
| **Jenkins**   | CI/CD automatisé (test, build, déploiement)|
| **SonarCloud**| Analyse de code et qualité logicielle      |
| **GitHub**    | Hébergement du code source                 |

---

## 🔄 CI/CD

La pipeline Jenkins automatise :

1. 🧪 **Tests unitaires** (avec Jest)
2. 🐳 **Build Docker**
3. 🚀 **Déploiement via Ansible sur EC2**
4. 🔍 **Analyse de code avec SonarCloud**

---

## 📂 Arborescence du projet

projet1/
├── ansible/
│ └── nginx_docker.yml
├── terraform/
│ └── main.tf
├── tests/
│ └── exemple.test.js
├── www/
│ └── index.html
├── sonar-project.properties
├── Jenkinsfile
├── package.json
└── README.md




🌐 Accéder au site
🖥️ Le site est déployé automatiquement sur une instance EC2 AWS.
L'IP publique est affichée en fin de pipeline Jenkins après le déploiement.

🤝 Auteur
Anthony SENAN

Passionné par l'automatisation, l'infrastructure et le DevOps.

LinkedIn (ou à remplacer)

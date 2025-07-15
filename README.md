# 🚀 Projet 1 – Déploiement Web automatisé avec CI/CD

![SonarCloud](https://sonarcloud.io/api/project_badges/measure?project=Sayn78_Projet1&metric=alert_status)

## 🧾 Description

Ce projet met en place un pipeline CI/CD complet pour le déploiement automatisé d'un site HTML statique via une instance EC2 sur AWS.

Il inclut :

- Infrastructure as Code (Terraform)
- Provisionnement (Ansible)
- Conteneurisation (Docker)
- Intégration continue (Jenkins)
- Analyse de code (SonarCloud)
- Tests unitaires (Jest)

---

## 🛠️ Technologies utilisées

| Outil         | Usage                                   |
|--------------|------------------------------------------|
| Terraform     | Création d'une VM EC2 AWS               |
| Ansible       | Installation de Docker + déploiement    |
| Jenkins       | CI/CD automatisé                        |
| Docker        | Conteneurisation du serveur NGINX       |
| Jest          | Tests unitaires JavaScript              |
| SonarCloud    | Analyse de la qualité du code           |
| GitHub        | Versioning et gestion du code source    |

---

## 🔄 Pipeline Jenkins

1. **Terraform** : provisionne une instance EC2 AWS
2. **Ansible** : installe Docker et déploie NGINX avec le site HTML
3. **Tests Jest** : exécute les tests unitaires
4. **SonarCloud** : exécute une analyse statique du code
5. **Déploiement** : versionné via tags Git

---

## 📦 Scripts npm

```bash
npm install        # Installe les dépendances
npm test           # Lance les tests avec Jest
npm run sonar      # Lance une analyse SonarCloud via npx sonar-scanner

```

## 🤝 Auteurs
Anthony Senan
DevOps junior passionné, en formation continue sur les technologies cloud, l’automatisation et l’intégration continue.

## ✅ Objectif
Mettre en œuvre une infrastructure DevOps professionnelle complète, versionnée, testée et analysée en continu.

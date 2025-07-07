# Utilise l'image NGINX officielle
FROM nginx:alpine

# Copie les fichiers du site dans le dossier servi par NGINX
COPY www/ /usr/share/nginx/html/

EXPOSE 80

# Dockerfile
FROM nginx:alpine
ARG CACHEBUSTER=1
COPY index.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY images/ /usr/share/nginx/html/images/
COPY elements.html  /usr/share/nginx/html/
COPY left-sidebar.html /usr/share/nginx/html/
COPY no-sidebar.html /usr/share/nginx/html/ 
COPY right-sidebar.html /usr/share/nginx/html/ 

EXPOSE 80

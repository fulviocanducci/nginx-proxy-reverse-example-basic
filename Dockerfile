FROM nginx:v1.22.0

COPY index.html /usr/share/nginx/html/

EXPOSE 80
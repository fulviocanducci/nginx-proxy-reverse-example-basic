## NGINX Proxy Reverse 

### nginx.conf
```
events {
    worker_connections 1024;
}

http {
    upstream web {
        ip_hash;
        server web1:80;
        server web2:80;
    }
    server {
        listen 80;
        listen [::]:80;
        server_name localhost;
        location / {
            proxy_pass http://web;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;            
        }
        location /green/ {
            proxy_pass http://web1:80/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;            
        } 
        location /red/ {
            proxy_pass http://web2:80/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;            
        }      
    }    
}
```

## docker-compose.yml

```
version: '3'

services:
  host-web-server:
    image: nginx:1.22.0
    restart: always
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - 80:80
    networks:
      - proxy
    depends_on:
      - web1
      - web2

  web1:
    image: nginx:1.22.0
    restart: always
    volumes:
      - ./index-green.html:/usr/share/nginx/html/index.html
    networks:
      - proxy

  web2:
    image: nginx:1.22.0
    restart: always    
    volumes:
      - ./index-red.html:/usr/share/nginx/html/index.html
    networks:
      - proxy

networks:
  proxy:
    driver: bridge
```

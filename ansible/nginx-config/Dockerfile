# Usar la imagen base de Nginx
FROM docker.io/nginx:latest

# Crear directorios para certificados y autenticación
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /etc/nginx/auth 

# Copiar la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los certificados SSL
COPY ssl/nginx.crt /etc/nginx/ssl/nginx.crt
COPY ssl/nginx.key /etc/nginx/ssl/nginx.key

# Copiar el archivo .htpasswd para autenticación básica
COPY auth/.htpasswd /etc/nginx/auth/.htpasswd

# Asegurar que los archivos tengan los permisos correctos
RUN chmod 644 /etc/nginx/ssl/nginx.crt && \
    chmod 600 /etc/nginx/ssl/nginx.key && \
    chmod 644 /etc/nginx/auth/.htpasswd

# Exponer los puertos 80 (HTTP) y 443 (HTTPS)
EXPOSE 80 443

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
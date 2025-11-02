FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK CMD wget -qO- http://localhost:80 || exit 1

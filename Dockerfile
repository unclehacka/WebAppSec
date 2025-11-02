FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/nginx.conf
USER non-root
HEALTHCHECK CMD wget -qO- http://localhost:80 || exit 1

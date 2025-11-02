FROM nginx:1.27-alpine
RUN adduser -D -H -u 1001 appuser
COPY nginx.conf /etc/nginx/nginx.conf
USER appuser
EXPOSE 8080
HEALTHCHECK CMD wget -qO- http://localhost:8080 || exit 1

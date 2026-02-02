FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/
EXPOSE 80

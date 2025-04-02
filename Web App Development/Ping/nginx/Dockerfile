# pull official base image
FROM nginx:latest

COPY default.conf /etc/nginx/conf.d/

RUN rm /usr/share/nginx/html/index.html

#ENTRYPOINT ["tail", "-f", "/dev/null"]
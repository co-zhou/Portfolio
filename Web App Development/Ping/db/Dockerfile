# pull official base image
FROM mariadb:lts

COPY init.sql /docker-entrypoint-initdb.d/init.sql

#ENTRYPOINT ["tail", "-f", "/dev/null"]
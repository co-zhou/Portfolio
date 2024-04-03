# pull official base image
FROM node:lts

# set work directory
WORKDIR /ping

# install dependencies
RUN apt-get update && apt-get install -y iputils-ping
COPY package*.json .
RUN npm install

# copy project
COPY . .

#ENTRYPOINT ["tail", "-f", "/dev/null"]
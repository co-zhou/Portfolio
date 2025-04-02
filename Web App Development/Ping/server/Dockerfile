# pull official base image
FROM node:lts

# set work directory
WORKDIR /server

# install dependencies
COPY package.json .
RUN npm install

# copy project
COPY . .

#ENTRYPOINT ["tail", "-f", "/dev/null"]
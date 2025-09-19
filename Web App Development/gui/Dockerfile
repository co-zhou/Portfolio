# pull official base image
FROM node:lts

# create next app
RUN npx create-next-app@latest gui --ts --eslint --tailwind --no-src-dir --app --import-alias '@/*'

# set work directory
WORKDIR /gui

# install dependencies
COPY package*.json .
RUN npm install

# copy project
RUN rm -rf ./app/page.tsx
COPY app ./app

# add localhost to allowedOrigins
COPY next.config.js .

# build project
RUN npm run build

#ENTRYPOINT ["tail", "-f", "/dev/null"]
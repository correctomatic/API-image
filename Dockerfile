ARG NODE_VERSION=20.12.2
FROM node:${NODE_VERSION}-alpine

# Shared folder between containers
ARG SHARED_FOLDER

RUN apk add --no-cache git
USER node

# Create the shared folder for the exercises
RUN mkdir -p ${SHARED_FOLDER}

# App directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Clone the repo and install dependencies
ENV REPO_URL https://github.com/correctomatic/correction-API.git

RUN git clone $REPO_URL correction-api
WORKDIR /home/node/app/correction-api
RUN npm install

EXPOSE 3000
ENTRYPOINT [ "node", "src/index.js" ]

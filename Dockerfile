ARG NODE_VERSION=20.12.2
FROM node:${NODE_VERSION}-alpine

ARG REPO_URL=https://github.com/correctomatic/correction-API.git
ARG REPO_BRANCH=master


ENV UPLOAD_DIRECTORY=/tmp/exercises
ENV PORT=3000
ENV NODE_ENV=production
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV LOG_LEVEL=info
ENV LOG_FILE=/var/log/correctomatic/correctomatic.log

# Create the folders for the default log file and upload directory
RUN mkdir -p /var/log/correctomatic && chown -R node:node /var/log/correctomatic
RUN mkdir -p /tmp/exercises && chown -R node:node /tmp/exercises

RUN apk add --no-cache git tini
USER node

# Create the folder for the exercises
RUN mkdir -p ${UPLOAD_DIRECTORY}

# App directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Clone the repo and install dependencies
RUN git clone -b $REPO_BRANCH $REPO_URL correction-api
WORKDIR /home/node/app/correction-api
RUN npm install

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--", "node", "src/index.js"]

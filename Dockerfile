ARG NODE_VERSION=20.12.2
FROM node:${NODE_VERSION}-alpine

ARG REPO_URL=https://github.com/correctomatic/correction-API.git
ARG REPO_BRANCH=master

ENV UPLOAD_DIRECTORY=/tmp/exercises
ENV PORT=3000
ENV NODE_ENV=production

ENV DB_NAME=correctomatic
ENV DB_HOST=postgresql
ENV DB_PORT=5432

ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

ENV LOG_LEVEL=info
ENV LOG_FILE=/var/log/correctomatic/correctomatic.log

# Create log folder
RUN mkdir -p /var/log/correctomatic && chown -R node:node /var/log/correctomatic

# App directory
RUN mkdir -p /app && chown -R node:node /app

# Create the folder for the exercises
# This folder can change at runtime
RUN mkdir -p ${UPLOAD_DIRECTORY} && chown -R node:node ${UPLOAD_DIRECTORY}

RUN apk add --no-cache git tini

USER node
WORKDIR /app

# Clone the repo and install dependencies
RUN git clone -b $REPO_BRANCH $REPO_URL .
RUN npm install --omit=dev

EXPOSE ${PORT}
ENTRYPOINT ["/sbin/tini", "--", "node", "src/index.js"]

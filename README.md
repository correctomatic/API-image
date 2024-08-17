# Runner image

Docker image for running the correctomatic API. The source code for the correctomatic API is in the [correction-api](https://github.com/correctomatic/correction-API) repository.

The image is available in [Docker Hub](https://hub.docker.com/r/correctomatic/api).

## Using the image

There are two ways of configuring the image: with environment variables or with an `.env` file. In both cases, the variables are the same as defined in the correction-API's [.env-example](https://github.com/correctomatic/correction-API/blob/master/.env.example) file.


### Using .env file

You can use a `.env` file to configure the container. Mount the file to the container in the `/app` directory:

```bash
docker run --rm \
  -v /path/to/.env:/app/.env \
  correctomatic/api
```

The documentation for shuch `.env` file is in the [correction-API repository](https://github.com/correctomatic/correction-API/blob/master/.env.example), but are the same as the environment variables described below.

### Using environment variables

The main variables you can pass are:
- `UPLOAD_DIRECTORY`: Directory where the uploaded files will be stored. The path is from the container's point of view. You will probably need to share this directory with the correctomatic's runner processes, using a bind mount or a volume.
- `REDIS_HOST`: Host of the redis server, from the container's point of view.
- `REDIS_PORT`: Port of the redis server
- `REDIS_PASSWORD`: Password for the redis server
- `PORT`: Port where the API will listen

There are also variables for debugging:
- `NODE_ENV`: Environment where the application is running. It can be `development`, `test` or `production`.
- `LOG_LEVEL`: Log level for the application.
- `LOG_FILE`: File where the logs will be written. The path is from the container's point of view.

You have the default values in the Dockerfile.

This is an example of how to run the container to connect to a remote docker server. You will need to mount the certificates in the container, and set the `DOCKER_OPTIONS` environment variable:

```bash
docker run --rm \
  -e UPLOAD_DIRECTORY=\tmp\exercises \
  -e REDIS_HOST=redis \
  -e REDIS_PORT=6379 \
  -e REDIS_PASSWORD=value \
  -e NODE_ENV=value \
  -e LOG_LEVEL=info \
  -e LOG_FILE=/var/log/correctomatic/correctomatic.log \
  -p 8080:8080 \
  correctomatic/api
```
You will probably need to include the redis host and to mount the upload directory:
```bash
docker run ...
  ...
  --add-host=redis:host-gateway \
  --mount type=bind,source=/tmp/exercises,target=/tmp/exercises \
  correctomatic/api
```

## Build the image

Build the image with `./build.sh`. All the parameters passed to the script will be passed to the `docker build` command. For example, to build the image with a custom tag:

```bash
./build.sh --no-cache --tag correctomatic/api:custom-tag
```

Take in account that some parameters are fixed in the script, like the git repository and the node version to install in the image, which are defined in the `.env` file in this repository.


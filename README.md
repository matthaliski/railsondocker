# Rails on Docker

This example app follows the book Docker For Rails Developers and creates a Rails app that runs on Docker.

## Running the app in Docker (manually, not cool)

First, make sure you have an image built:

```shell
docker build -t myapp .
```

Once that's built, you can run a container:

```shell
docker run -p 3000:3000 myapp
```

## Running the app the cool way

Use Docker Compose to specify your needs in a declarative way and let it do all the heavy lifting.

```shell
docker compose up

# If anything seems "cached" and you wan to start fresh:
docker compose up --build
```

# Rails on Docker

This example app follows the book Docker For Rails Developers and creates a Rails app that runs on Docker.

## Running the app in Docker

First, make sure you have an image built:

```shell
docker build -t myapp .
```

Once that's built, you can run a container:

```shell
docker run -p 3000:3000 myapp
```

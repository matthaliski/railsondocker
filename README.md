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

## Interactive shell for `web`

If you've dockerized your Rails app, then you're no longer going to run `rails` commands from your local terminal. Heck, you might not even have the correct Ruby version installed or any of your app's gems. All that stuff is in the containers you've set up.

Instead, we can run bash and attach to the already running `web` container. (This assume you've already done `docker compose up`)

```shell
docker compose exec web bash
```

Now that you've got an interactive shell, you can go to town with stuff like `rails db:migrate` or any other useful `rails` commands.

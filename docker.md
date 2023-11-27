# Docker cheatsheet

## Running in a one-time container

To make sure your container is removed when the task completes:

~~~ shell
docker-compose run --rm my-service
docker run --rm my-image
~~~

## Clean up things no longer in use

~~~ shell
docker system prune -a
~~~


Type Ctrl+p then Ctrl+q. It will help you to turn interactive mode to daemon mode.

See https://docs.docker.com/engine/reference/commandline/cli/#default-key-sequence-to-detach-from-containers:

Once attached to a container, users detach from it and leave it running using the using CTRL-p CTRL-q key sequence. This detach key sequence is customizable using the detachKeys property. [...]

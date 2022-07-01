# Hello

Create and load the image:

```shell
nix build .
docker load < result
```

Now run the image:

```shell
docker run -t nix-docker-hello:v0.1.0
```

That should output `Hello, world!`. You can also pass args:

```shell
docker run -t nix-docker-hello:v0.1.0 --traditional
# hello, world

docker run -t nix-docker-hello:v0.1.0 --greeting "Herzlich willkommen\!"
# Herzlich willkommen!
```

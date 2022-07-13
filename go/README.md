# Go web service example

Build the image using [Nix] and [load] the result into [Docker]:

```shell
nix build
docker load < result
```

To run the image:

```shell
docker run -t nix-docker-go-svc:v0.1.0
```

The web service has just one endpoint at `/`:

```shell
curl http://localhost:8080
```

That should output `Welcome to Go inside Docker built with Nix!`.

## Build without checking out

You can also build and run the image without having access to this code locally:

```shell
nix build 'github:the-nix-way/nix-docker-examples?dir=go'
docker load < result
docker run -t nix-docker-go-svc:v0.1.0
```

[docker]: https://docker.com
[load]: https://docs.docker.com/engine/reference/commandline/load
[nix]: https://nixos.org

# Hello

Build the image using [Nix] and [load] the result into [Docker]:

```shell
nix build .
docker load < result
```

To run the image:

```shell
alias hello='docker run -t nix-docker-hello:v0.1.0'

hello
```

That should output `Hello, world!`. You can also pass args:

```shell
hello --traditional
# hello, world

hello --greeting "Herzlich willkommen\!"
# Herzlich willkommen!
```

[docker]: https://docker.com
[load]: https://docs.docker.com/engine/reference/commandline/load
[nix]: https://nixos.org

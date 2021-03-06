# Script example

Build the image using [Nix] and [load] the result into [Docker]:

```shell
nix build
docker load < result
```

Now run the image:

```shell
docker run -t nix-docker-script:v0.1.0 foo bar baz
```

The output should be something like this:

```
Hello! Here's some information about this image:

{
  built-by:    aarch64-darwin,
  built-for:   x86_64-linux,
  shell:       /bin/bash,
  base-image:  shell-plus-coreutils
  args-passed: "foo bar baz"
}
```

The `built-by` field may change if you're using a different platform.

## Build without checking out

You can also build and run the image without having access to this code locally:

```shell
nix build 'github:the-nix-way/nix-docker-examples?dir=script'
docker load < result
docker run -t nix-docker-script:v0.1.0
```

[docker]: https://docker.com
[load]: https://docs.docker.com/engine/reference/commandline/load
[nix]: https://nixos.org

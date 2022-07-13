# Nix Docker examples

| Directory             | Docker image contents                        |
| :-------------------- | :------------------------------------------- |
| [`go`](./go/)         | A simple [Go] web service                    |
| [`hello`](./hello/)   | An image containing just the `hello` package |
| [`script`](./script/) | An image wrapping a shell script             |

In each project, you can run the following to build and run the image:

```shell
nix build .
docker load < result
docker run -t ${IMAGE_NAME}:${IMAGE_HASH}
```

The `IMAGE_NAME` and `IMAGE_HASH` need to match the specific example.

> All examples use [Nix flakes][flakes].

[flakes]: https://nixos.wiki/wiki/Flakes
[go]: https://golang.org

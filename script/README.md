# Script example

```shell
nix build .
docker load < result
docker run -t nix-docker-script:v0.1.0
```

Expected output:

```
Hello! Here's some information about this image:

(
  built-by:  aarch64-darwin,
  built-for: x86_64-linux,
  shell:     /bin/bash
)
```

The `built-by` field may change if you're using a different platform.

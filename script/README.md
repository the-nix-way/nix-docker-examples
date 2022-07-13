# Script example

Build the image:

```shell
nix build .
```

Load the image into Docker:

```shell
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

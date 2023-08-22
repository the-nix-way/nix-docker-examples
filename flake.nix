{
  description = "Nix Docker examples";

  inputs = {
    go.url = "path:./go";
    hello.url = "path:./hello";
    script.url = "path:./script";
  };

  outputs = inputs: {
    inherit (inputs) go hello script;
  };
}

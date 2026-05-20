_: {
  configurations.nixos.jet.module = {
    var = {
      username = "arturo";
      hostname = "jet";
      shell = "zsh";
      domain = "turboguac.cc";
      ip = "192.168.68.100";
    };
  };
}

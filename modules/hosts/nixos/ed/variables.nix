_: {
  configurations.nixos.ed.module = {
    var = {
      username = "arturo";
      hostname = "ed";
      shell = "zsh";
      ip = "192.168.68.101";
    };
  };
}

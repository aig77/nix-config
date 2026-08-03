# SSH Between Machines

`ssh arturo@jet` works from any machine in the setup because three pieces line up: every NixOS host runs an SSH server, all hosts share one committed public key, and Tailscale's MagicDNS resolves hostnames over the tailnet.

## Why it works

**1. SSH server is on everywhere.** `modules/aspects/networking.nix` enables `services.openssh` on every NixOS host, since it lives in `nixos.base`.

**2. One shared key grants access.** `modules/aspects/secrets/ssh.pub` is committed to the repo and wired into `modules/aspects/users.nix` as an authorized key for both the primary user and `root`:

```nix
openssh.authorizedKeys.keyFiles = [./secrets/ssh.pub];
```

Because that file is part of `nixos.base`, the same key works on every NixOS host. Deploy a new host and it gets SSH access with the same key, no per-machine setup.

**3. MagicDNS resolves short names.** `modules/aspects/tailnet.nix` pulls the `tailscale` profile into both `nixos.base` and `darwin.base`, so every machine joins the same tailnet. Tailscale's MagicDNS maps each machine's hostname to its tailnet address, which is why `jet` works as a hostname instead of typing `jet.<tailnet>.ts.net` or an IP.

So the full path for `ssh arturo@jet` is: `arturo` resolves against jet's authorized keys, `jet` resolves via MagicDNS to jet's tailnet IP, and openssh on jet accepts the connection over the tailnet.

## Public vs. private key

An SSH keypair is two files, generated together:

- `~/.ssh/id_ed25519` - the **private** key. Secret, stays on your machine, never leaves it.
- `~/.ssh/id_ed25519.pub` - the **public** key. Safe to share, which is why it's the only one in the repo.

Nix only ever deploys the public half. `ssh.pub` is the *only* key referenced in the config; there is no private key anywhere in the repo, and Nix never installs one. That's what makes committing `ssh.pub` safe: if the repo leaks, an attacker gets a public key, which is useless for logging in. Authentication only succeeds by signing a challenge with the private key, and that key was never in the repo.

## Which machines can SSH where

The repo deploys public keys, not private ones, so the model is one-directional until you intervene:

- A new NixOS host gets `ssh.pub` installed in its `authorized_keys`. Other machines can SSH **into** it.
- It does **not** get a private key. It cannot SSH **out** to anything.

To let a machine SSH out (e.g. a second laptop, or a box that needs to reach the fleet), copy the private key over once, manually:

```bash
scp ~/.ssh/id_ed25519 newmachine:~/.ssh/
```

Now it shares the same identity and can SSH anywhere `ssh.pub` is trusted.

That shared identity is the trade-off: whoever holds `~/.ssh/id_ed25519` can log into every host. Copying it to more machines widens that single point of security, so keep copies to machines you actually trust.

## Adding or replacing your key

1. Generate a keypair:

   ```bash
   ssh-keygen -t ed25519
   ```

2. Overwrite `modules/aspects/secrets/ssh.pub` with the new public key.

3. `git add` the file and rebuild every NixOS host:

   ```bash
   git add modules/aspects/secrets/ssh.pub
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

The old key stops working once hosts are rebuilt, since there's exactly one key in the file.

## Reaching machines that aren't NixOS

The tailnet side (MagicDNS + connectivity) applies to Darwin too, since `darwin.base` also imports `tailscale`. macOS still needs Remote Login enabled in System Settings for SSH to accept connections; the shared keyfile does not configure that.

## Useful extras

- **SSH to a machine by short name over the tailnet from your phone or laptop**: same mechanism, as long as that device is on the tailnet and has the key.
- **Only on NixOS hosts**: the `ssh.pub` authorized-key wiring lives in `nixos.base`, so it does not apply to Darwin.

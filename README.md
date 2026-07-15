# dto

## macOS

The macOS nix-darwin flake is in `nix/flake.nix`.

Rebuild it with:

```sh
sudo darwin-rebuild switch
```

## Linux

The shared Linux user environment is in `nix/linux/base/flake.nix`.

It currently installs:

- zsh
- bat
- moor
- delta
- git
- tmux
- neovim

The pi4b-specific Linux environment is in `nix/linux/pi4b/flake.nix`.
It builds on the shared Linux flake and has no extra packages yet.

## Installing Nix on Linux

For Raspberry Pi 4, prefer a 64-bit OS image. The hardware supports it, and
Nix has much better binary cache coverage on `aarch64-linux` than on 32-bit
`armv7l-linux`.

On Raspberry Pi OS or another systemd-based Linux machine, use the official
multi-user daemon install:

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```

After installation, open a new shell or load the Nix profile script:

```sh
. /etc/profile.d/nix.sh
```

Enable the modern `nix` command and flakes for your user:

```sh
mkdir -p ~/.config/nix
printf '%s\n' 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

If the machine is running 32-bit Raspberry Pi OS (`uname -m` prints `armv7l`)
and Nix fails with `Required features: {gccarch-armv7-a}`, add that system
feature to the daemon config:

```sh
sudo sh -c 'printf "%s\n" "system-features = benchmark big-parallel nixos-test uid-range gccarch-armv7-a" >> /etc/nix/nix.conf'
sudo systemctl restart nix-daemon
```

That only fixes the feature gate. On 32-bit ARM, Nix may still need to build
many packages locally because binary substitutes are less available.

If the machine cannot run the daemon install, use the single-user installer
instead:

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
```

## Installing This Environment

Install the shared Linux environment with:

```sh
nix profile add ./nix/linux/base
```

Install the pi4b environment with:

```sh
nix profile add ./nix/linux/pi4b
```

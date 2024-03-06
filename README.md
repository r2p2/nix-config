# Setup new Host

After installing NixOS on a new system, create a new directory inside
`host`. Move the contents of `/etc/nixos/` into the new directory inside
the newly created host instance directory and run `chown` on them so that
you are the new owner.
Symlink both files back into `/etc/nixos` via
```
sudo ln -s <full path>/hosts/<instance>/configuration.nix /etc/nixos/
sudo ln -s <full path>/hosts/<instance>/hardwaare-configuration.nix /etc/nixos/
```

Rebuild and switch 

# Update Configuration

1. Update files
2. `sudo nixos-rebuild switch`
3. If successfull, commit changes to git

# Home-Manager

Documentation for possible options: https://nix-community.github.io/home-manager/options.xhtml

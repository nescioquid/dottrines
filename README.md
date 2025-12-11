# dottrines 📜💾🟠

_°•. A dotfiles manager for true believers of the orthodotsy.•°•°_

You're welcome, future me!

### Adding these configurations to your Linux distro for the first time?

<!-- First, make this repo publicly visible. -->

<!-- 
Then, run the following commands, _separately_ (testing with Ubuntu on WSL2 has routinely failed as a single command, for whatever reason). The first makes the right directory in the right location, clones this repo into it, and sources a `.dotfiles_aliases` file that contains the prerequisite commands:

```console
mkdir ~/repos/ && cd ~/repos &&
git clone https://github.com/nescioquid/dotfiles.git &&
source ~/repos/dotfiles/.dotfiles/.dotfiles_aliases
```

While the second actually installs the configurations locally:

```console
installdotfiles
```

Afterwards, you should run `aliases` to make sure you're `source`-ing whatever aliases you want in your new environment.
 -->

<!-- Then, run the following command: -->
Run the following command:

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nescioquid/dottrines/main/tools/install.sh)"
```

Afterwards, just reload your shell and you're ready to go.

<!-- _Don't forget to make this repo private again afterwards!_ -->

### Then what?

<!-- Push to this repo with `pushdotfiles` and pull from it with `pulldotfiles`. That's it! Remember to run `pushdotfiles` whenever you make any configuration changes! -->

Push to this repo with `promulgatedots` and pull from it with `reindottrinate`. That's it! Remember to run `promulgatedots` whenever you make any configuration changes!

## Other useful commands

Update **apt**:
```console
sudo apt update && sudo apt upgrade -y
```

Install **zsh**:
```console
sudo apt install zsh -y
```

Install **oh-my-zsh**:
```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

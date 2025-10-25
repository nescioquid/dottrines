# dottrines 📜💾🟠

_°•. A dotfiles manager for true believers of the orthodotsy.•°•°_

You're welcome, future me!

### Usage

#### Adding these configurations to your Linux distro for the first time?

First, make this repo publicly visible.

<!-- 
Then, run the following commands, _separately_ (testing with Ubuntu on WSL2 has routinely failed as a single command, for whatever reason). The first makes the right directory in the right location, clones this repo into it, and sources a `.dotfiles_aliases` file that contains the prerequisite commands:

```shell
mkdir ~/repos/ && cd ~/repos &&
git clone https://github.com/nescioquid/dotfiles.git &&
source ~/repos/dotfiles/.dotfiles/.dotfiles_aliases
```

While the second actually installs the configurations locally:

```shell
installdotfiles
```

Afterwards, you should run `aliases` to make sure you're `source`-ing whatever aliases you want in your new environment.
 -->

Then, run the following command:

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nescioquid/dottrines/main/tools/install.sh)"
```

Afterwards, just reload your shell and you're ready to go.

_Don't forget to make this repo private again afterwards!_

#### Else

<!-- Push to this repo with `pushdotfiles` and pull from it with `pulldotfiles`. That's it! Remember to run `pushdotfiles` whenever you make any configuration changes! -->

Push to this repo with `promulgatedots` and pull from it with `reindottrinate`. That's it! Remember to run `promulgatedots` whenever you make any configuration changes!

#### See also

Command to install zsh:
```shell
sudo apt install zsh -y
```

Command to install oh-my-zsh:
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

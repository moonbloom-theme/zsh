### [Zsh](https://zsh.org/)

#### Install

**Github**
1. Download using the [GitHub .zip download](https://github.com/moonbloom-theme/zsh/archive/main.zip) option
2. Move `moonbloom.zsh-theme` file to [oh-my-zsh](https://ohmyz.sh)'s theme folder: `oh-my-zsh/custom/themes/moonbloom.zsh-theme`.

**Wget**

```shell
wget -q --spider https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.zsh-theme && wget -q https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.zsh-theme -O "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/themes/moonbloom.zsh-theme" && wget -q --spider https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.conf && wget -q https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.conf -O "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/themes/moonbloom.conf"
```

**Curl**

```shell
curl -s -f https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.zsh-theme -o "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/themes/moonbloom.zsh-theme" && curl -s -f https://raw.githubusercontent.com/moonbloom-theme/zsh/main/moonbloom.conf -o "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/themes/moonbloom.conf"
```

### Activating theme

Go to your `~/.zshrc` file and set `ZSH_THEME="moonbloom"`.

## Config
See [CONFIG.md](./CONFIG.md)
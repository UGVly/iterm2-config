# iTerm2、Zsh 与 tmux

![Sakurajima Mai 夜景背景](assets/Sakurajima-Mai-Night.jpg)

## iTerm2

iTerm2 3.7.7 的配置快照。默认使用 **Comfortable Dark**，按 **⌥ Space** 呼出 **Hotkey Window**。仓库也收录了背景图、Workgroup 和保存的代码审查提示词。 [动态 Profile](DynamicProfiles/)

### 在另一台 Mac 上恢复 iTerm2

安装 iTerm2 和 JetBrainsMono Nerd Font。完全退出 iTerm2，然后在 macOS 自带的「终端」中运行以下命令。需要已登录的 `gh` 和 Python 3。

```sh
gh repo clone UGVly/iterm2-config
cd iterm2-config

restore_dir="$(mktemp -d)/iterm2"
python3 prepare-restore.py "$restore_dir"

if defaults read com.googlecode.iterm2 >/dev/null 2>&1; then
  defaults export com.googlecode.iterm2 "${restore_dir%/*}/previous-iterm2.plist"
  printf '原偏好设置保存在 %s\n' "${restore_dir%/*}/previous-iterm2.plist"
fi

profiles_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$profiles_dir" "$HOME/Pictures/iTerm2"
cp -i "$restore_dir"/DynamicProfiles/*.json "$profiles_dir/"
cp -i assets/Sakurajima-Mai-Night.jpg "$HOME/Pictures/iTerm2/"
defaults import com.googlecode.iterm2 "$restore_dir/com.googlecode.iterm2.plist"
```

再次打开 iTerm2，确认默认 Profile 是 **Comfortable Dark**，并试一下 **⌥ Space**。恢复命令会替换本机 iTerm2 偏好设置。若本机已有同名动态 Profile 或背景图，复制时会询问是否覆盖。

动态 Profile 的目录和格式见 [iTerm2 官方文档](https://iterm2.com/3.7/documentation-dynamic-profiles.html)。

## Zsh

| 配置文件 | 内容 |
| --- | --- |
| [`.zprofile`](zsh/.zprofile) | Homebrew 初始化、USTC 镜像和 pipx 路径 |
| [`.zshrc`](zsh/.zshrc) | 历史记录、补全、快捷键、Git 别名，以及 fzf、zoxide、pyenv、direnv 和 Miniforge 集成 |
| [`starship.toml`](zsh/starship.toml) | Catppuccin Mocha 提示符，显示 Git 状态、语言环境和命令耗时 |

配置中的 Homebrew 路径采用 Apple Silicon 默认的 `/opt/homebrew`。在仓库目录安装依赖并复制配置，然后打开新的 Zsh 登录 shell。

```sh
brew install starship fzf fd bat eza zoxide pyenv direnv \
  zsh-completions zsh-autosuggestions zsh-syntax-highlighting
mkdir -p "$HOME/.config"
cp -i zsh/.zprofile zsh/.zshrc "$HOME/"
cp -i zsh/starship.toml "$HOME/.config/"
```

## tmux

本机用 Homebrew 安装了 tmux 3.7，使用默认配置。前缀键是 **Ctrl-b**，鼠标模式关闭，状态栏开启，窗口从 0 开始编号。

```sh
brew install tmux
tmux new -s work
```

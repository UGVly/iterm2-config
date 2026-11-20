# iTerm2 配置

iTerm2 3.7.7 的配置快照，包含偏好设置、配色和字体设置、默认的 **Comfortable Dark** Profile、用 **⌥ Space** 呼出的 **Hotkey Window**、背景图、Workgroup 和保存的代码审查提示词。

## 在另一台 Mac 上恢复

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

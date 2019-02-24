#!/usr/bin/env zsh

# Note: it doesn't check git here, the environment should have git if this script already downloaded.

# Back to home
cd ~

# Get FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Get oh-my-zsh
git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh .unix_settings/.oh-my-zsh

# Use personalized theme
mkdir -p ~/.unix_settings/.oh-my-zsh/custom/themes
ln -s ~/.unix_settings/bureau_custom.zsh-theme ~/.unix_settings/.oh-my-zsh/custom/themes/bureau_custom.zsh-theme

# custom plugin for zsh -- incr
mkdir -p ~/.unix_settings/.oh-my-zsh/custom/plugins/incr
ln -s ~/.unix_settings/incr.plugin.zsh ~/.unix_settings/.oh-my-zsh/custom/plugins/incr/incr.plugin.zsh

# tmux plugin manager and corresponding plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm .unix_settings/.tmux/plugins/tpm
git clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect .unix_settings/.tmux/plugins/tmux-resurrect

# Create symbolic links for dot-files
ln -fs .unix_settings/.zshrc
ln -fs .unix_settings/.oh-my-zsh
ln -fs .unix_settings/.tmux
ln -fs .unix_settings/.inputrc
ln -fs .unix_settings/.jupyter
ln -fs .unix_settings/.tmux.conf
ln -fs .unix_settings/.ctags.d
ln -fs .unix_settings/.pylintrc
ln -fs .unix_settings/.jshintrc
ln -fs .unix_settings/.gitconfig
ln -fs .unix_settings/.gdbinit

mkdir .ssh 2> /dev/null
ln -fs ~/.unix_settings/.ssh/config ~/.ssh/config

## (optional)
#`ln -fs .unix_settings/.pudb-theme.py`
#`ln -fs .unix_settings/.Xmodmap`
#`ln -fs .unix_settings/.spyder2-py3`
#`ln -fs .unix_settings/.spyder2`

# Update zsh
source .zshrc
echo "Recommend using vim config from from https://github.com/elsdrium/.vim"

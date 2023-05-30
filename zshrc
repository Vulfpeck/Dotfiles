# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

if [ -f ~/.zshrc.aux ]; then 
  source ~/.zshrc.aux
fi


export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')
export NVM_AUTO_USE=true

source ~/Dotfiles/zsh/antigen.zsh
antigen bundle lukechilds/zsh-nvm
antigen bundle z
antigen theme romkatv/powerlevel10k
antigen bundle git
antigen apply

alias tmux="tmux -u2"
alias vim="nvim"

# bun completions
[ -s "/home/tp/.bun/_bun" ] && source "/home/tp/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

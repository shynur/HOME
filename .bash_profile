export LANG=en_US.UTF-8  # 否则 Emacs TUI 在 container 里无法显示 汉字.  WHY?

export PATH+=:~/.local/bin  # pipx 会把可执行文件安装到此处.

export GOPATH=~/go
export PATH+=:/usr/local/go/bin:$GOPATH/bin

# 忽略 C-d 的 logout 效果.  必须开启, 防止不小心 sign out.
set +o ignoreeof  # (在 .bash_profile 中设置它, 因此仅对 login shell 生效.)

export VISUAL='emacs'
export GIT_EDITOR=$VISUAL

if [ "$PS1" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export ANTHROPIC_BASE_URL=https://api.aicodemirror.com/api/claudecode
export GOOGLE_GEMINI_BASE_URL=https://api.aicodemirror.com/api/gemini

if [ -f ~/.profile.py ]; then
    export PYTHONSTARTUP=~/.profile.py
fi

#!/bin/sh
set -e

USER=$1
PASSWD=$2
THEME=powerlevel10k/powerlevel10k
PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting"

echo
echo "Installing Oh-My-Zsh with:"
echo "  THEME   = $THEME"
echo "  PLUGINS = $PLUGINS"
echo

check_dist() {
    (
        . /etc/os-release
        echo $ID
    )
}

install_dependencies() {
    DIST=`check_dist`
    echo "###### Installing dependencies for $DIST"

    if [ "`id -u`" = "0" ]; then
        Sudo=''
    elif which sudo; then
        Sudo='sudo -S'
    else
        echo "WARNING: 'sudo' command not found. Skipping the installation of dependencies. "
        echo "If this fails, you need to do one of these options:"
        echo "   1) Install 'sudo' before calling this script"
        echo "OR"
        echo "   2) Install the required dependencies: git curl zsh"
        return
    fi

    case $DIST in
        alpine)
            echo $PASSWD | $Sudo apk add --update --no-cache git curl zsh
        ;;
        centos | amzn)
            echo $PASSWD | $Sudo yum update -y
            echo $PASSWD | $Sudo yum install -y git curl
            echo $PASSWD | $Sudo yum install -y ncurses-compat-libs # this is required for AMZN Linux (ref: https://github.com/emqx/emqx/issues/2503) 
            echo $PASSWD | $Sudo curl http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64/zsh-5.1-1.gf.el7.x86_64.rpm > zsh-5.1-1.gf.el7.x86_64.rpm
            echo $PASSWD | $Sudo rpm -i zsh-5.1-1.gf.el7.x86_64.rpm
            echo $PASSWD | $Sudo rm zsh-5.1-1.gf.el7.x86_64.rpm
        ;;
        *)
            echo $PASSWD | $Sudo apt-get update
            echo $PASSWD | $Sudo apt-get -y install git curl zsh
    esac
}

zshrc_template() {
    _HOME=$1; 
    _THEME=$2; shift; shift
    _PLUGINS=$*;

    cat <<EOM
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export TERM=xterm-256color

##### Zsh/Oh-my-Zsh Configuration
export ZSH="$_HOME/.oh-my-zsh"
ZSH_THEME="${_THEME}"
plugins=($_PLUGINS)

source \$ZSH/oh-my-zsh.sh

EOM
}

powerline10k_config() {
    cat <<EOM
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOM
}

install_dependencies

cd /tmp

if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
fi

plugin_list=""
for plugin in $PLUGINS; do
    if [ "`echo $plugin | grep -E '^http.*'`" != "" ]; then
        plugin_name=`basename $plugin`
        git clone $plugin $HOME/.oh-my-zsh/custom/plugins/$plugin_name
    else
        plugin_name=$plugin
    fi
    plugin_list="${plugin_list}$plugin_name "
done

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

zshrc_template "$HOME" "$THEME" "$plugin_list" > $HOME/.zshrc

if [ "$THEME" = "powerlevel10k/powerlevel10k" ]; then
    git clone https://github.com/romkatv/powerlevel10k $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    powerline10k_config >> $HOME/.zshrc
fi

echo $PASSWD | sudo -S usermod -s /bin/zsh $USER

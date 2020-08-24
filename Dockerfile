FROM ubuntu:20.04

# Language
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# alias
ARG APT_INSTALL="apt-get install -y --no-install-recommends"

##########################################################################
# Packages
##########################################################################

# Install tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive ${APT_INSTALL} \
        ca-certificates \
        libssl-dev \
        openssh-server \
        sudo \
        less \
        tzdata \
        git \
        vim \
        tree \
        curl \
        wget \
        make \
        && \
# Install custom packages
    DEBIAN_FRONTEND=noninteractive ${APT_INSTALL} \
        erlang

##########################################################################
# System settings
##########################################################################

# Set time zone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set prompt color
ENV TERM=xterm-256color

##########################################################################
# SSHD settings
##########################################################################

# Copy SSH host keys
COPY configs/ssh_host_key/ssh_host_dsa_key /etc/ssh/ssh_host_dsa_key
COPY configs/ssh_host_key/ssh_host_dsa_key.pub /etc/ssh/ssh_host_dsa_key.pub
COPY configs/ssh_host_key/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
COPY configs/ssh_host_key/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
COPY configs/ssh_host_key/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY configs/ssh_host_key/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY configs/ssh_host_key/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY configs/ssh_host_key/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub

# SSH daemon
RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Export SSH port
EXPOSE 22

##########################################################################
# User settings
##########################################################################

# User arguments
ARG USER
ARG GROUP
ARG PASSWD
ARG UID=1000
ARG GID=1000
ARG HOME=/home/${USER}

# Add an user if given
RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GID} -m -s /bin/bash ${USER} && \
    echo "${USER}:${PASSWD}" | chpasswd && \
    usermod -aG sudo ${USER}

# Set user to use from below
USER ${USER}

# Copy setting files
COPY --chown=${USER}:${GROUP} configs/.p10k.zsh ${HOME}
COPY --chown=${USER}:${GROUP} configs/.gitconfig ${HOME}

# Install ZSH with oh-my-zsh, Powerlevel10k theme
# Fonts: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
COPY --chown=${USER}:${GROUP} scripts ${HOME}/.scripts
RUN sh -c "${HOME}/.scripts/install_zsh.sh ${USER} ${PASSWD}"

# Clean up scripts
RUN rm -rf ${HOME}/.scripts

USER root
ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]

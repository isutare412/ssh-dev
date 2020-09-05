# SSH Dev

Customizable dockerized ssh server for development.

# Requirements

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Powerlevel10k fonts](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
  (Optional. Install if you want to install ZSH instead of BASH)

# How to use

1. Set following build arguments in `docker-compose.yml`.
   * USER=\<ssh user\>
   * GROUP=\<ssh group for user\>
   * PASSWD=\<ssh password for user\>
   * UID=\<ssh user uid\>
   * GID=\<ssh user gid\>
   * INSTALL_ZSH=\<true/false\>

   If you provide arg `INSTALL_ZSH` true, `ZSH`, `oh-my-zsh`, `powerlevel10k`
   will be installed. You should install [Powerlevel10k fonts](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
   for `powerlevel10k` to work properly.

2. Modify `Dockerfile` by adding packages you need below
   line "# Install custom packages".

3. Modify email and name of `configs/.gitconfig` file to your git information.

4. Generate SSH host keys. (Need only once)

```sh
cd configs/ssh_host_key
sudo ./generate.sh
```

5. Build docker image.

```sh
sudo docker-compose build
```

6. Run docker container.

```sh
docker-compose up -d
```

# Package Lists

* Linux Packages
  + zsh
  + git
  + vim
  + tree
  + make
  + wget
  + curl

* Oh-my-zsh Plugins
  + zsh-autosuggestions
  + zsh-syntax-highlighting

* Vim-Plug plugins
  + vim-airline/vim-airline
  + vim-airline/vim-airline-themes

from ubuntu:22.04

SHELL ["/bin/bash", "--login", "-c"]

# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=America/Halifax

RUN apt-get update --fix-missing && apt-get install -y software-properties-common


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl fzf ripgrep tree git \
	xclip python3 python3-pip silversearcher-ag \
	tzdata ninja-build gettext libtool libtool-bin zsh direnv \
	cmake build-essential zip unzip sudo pkg-config automake


# Install Neovim from source.
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j8 && make install
RUN rm -rf /root/TMP
RUN curl -sS https://starship.rs/install.sh | sudo sh -s - --yes

RUN groupadd -r dev && useradd -m -r -g dev -s /usr/bin/zsh dev
RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER dev

WORKDIR /home/dev
RUN bash -l -i -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash"
RUN bash -l -i -c "source ~/.nvm/nvm.sh && nvm ls-remote && nvm install v18.12.1"
RUN bash -l -i -c "source ~/.nvm/nvm.sh && npm i -g neovim"

RUN pip3 install pynvim

RUN bash -l -i -c "git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim"

RUN mkdir -p /home/dev/.config/nvim/lua
COPY --chown=dev:dev ./config/nvim /home/dev/.config/nvim/
COPY --chown=dev:dev ./config/zshrc /home/dev/.zshrc
COPY --chown=dev:dev ./config/starship.toml /home/dev/.config/starship.toml

RUN bash -l -i -c "nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null || echo done"

COPY --chown=dev:dev ./config/nvim-after /home/dev/.config/nvim/after

CMD ["/usr/bin/zsh", "--login"]

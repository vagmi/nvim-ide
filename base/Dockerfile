from ubuntu:22.04

SHELL ["/bin/bash", "--login", "-c"]

# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=America/Halifax

RUN apt-get update --fix-missing && apt-get install -y software-properties-common
ARG GITHUB_HANDLE=vagmi

EXPOSE 22

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl fzf ripgrep tree git \
	xclip python3 python3-pip silversearcher-ag htop libssl3 libssl-dev \
	tzdata ninja-build gettext libtool libtool-bin zsh direnv openssh-server \
	cmake build-essential zip unzip sudo pkg-config automake wget

RUN chsh -s /usr/bin/zsh
RUN mkdir /var/run/sshd
RUN mkdir -p /root/.ssh && curl https://github.com/$GITHUB_HANDLE.keys -o /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

# Install Neovim from source.
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && CMAKE_BUILD_TYPE=Release make -j8 && make install
RUN rm -rf /root/TMP
RUN curl -sS https://starship.rs/install.sh | sudo sh -s - --yes

# Install Java
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -l -c 'source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java'
RUN bash -l -c 'source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install gradle 7.6'

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN bash -l -i -c "rustup install stable"

# Install Go
RUN mkdir -p /root/sources &&  cd /root/sources && wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf /root/sources/go1.19.4.linux-amd64.tar.gz && rm -rf /root/sources

# Install Node
WORKDIR /root
RUN bash -l -i -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash"
RUN bash -l -i -c "source ~/.nvm/nvm.sh && nvm ls-remote && nvm install v18.12.1"
RUN bash -l -i -c "source ~/.nvm/nvm.sh && npm i -g neovim"

# Install Ruby
COPY ./install-ruby.sh /opt/tools/install-ruby.sh
RUN /opt/tools/install-ruby.sh

RUN pip3 install pynvim

RUN bash -l -i -c "git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim"

COPY ./install-go-tools.sh /opt/tools/install-go-tools.sh
RUN /opt/tools/install-go-tools.sh

RUN git clone https://github.com/rupa/z.git /opt/tools/z

RUN mkdir -p /root/.config/nvim/lua
COPY ./config/nvim /root/.config/nvim/
COPY ./config/zshrc /root/.zshrc
COPY ./config/starship.toml /root/.config/starship.toml

RUN bash -l -i -c "nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null || echo done"

COPY ./config/nvim-after /root/.config/nvim/after
RUN zsh -l -i -c "nvim --headless -c 'MasonInstall rust-analyzer' -c 'sleep 20' -c qall  > /dev/null || echo done"

VOLUME /root/work

CMD ["/usr/sbin/sshd", "-D"]

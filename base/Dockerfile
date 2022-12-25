from ubuntu:22.04

SHELL ["/bin/bash", "--login", "-c"]

# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=America/Halifax

RUN apt-get update --fix-missing && apt-get install -y software-properties-common


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl fzf ripgrep tree git \
	xclip python3 python3-pip silversearcher-ag htop \
	tzdata ninja-build gettext libtool libtool-bin zsh direnv \
	cmake build-essential zip unzip sudo pkg-config automake wget


# Install Neovim from source.
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j8 && make install
RUN rm -rf /root/TMP
RUN curl -sS https://starship.rs/install.sh | sudo sh -s - --yes

# Install Java
ENV JAVA_HOME /opt/java/openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_VERSION jdk-17.0.5+8
RUN mkdir -p /opt/java/openjdk && \
    wget -O /tmp/openjdk.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.5_8.tar.gz && \
    tar --extract \
	      --file /tmp/openjdk.tar.gz \
	      --directory "$JAVA_HOME" \
	      --strip-components 1 \
	      --no-same-owner && \
    rm /tmp/openjdk.tar.gz
RUN find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf && \
    ldconfig && \
    java -Xshare:dump

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

RUN pip3 install pynvim

RUN bash -l -i -c "git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim"

COPY ./install-go-tools.sh /root/install-go-tools.sh
RUN ./install-go-tools.sh

RUN mkdir -p /root/.config/nvim/lua
COPY ./config/nvim /root/.config/nvim/
COPY ./config/zshrc /root/.zshrc
COPY ./config/starship.toml /root/.config/starship.toml

RUN bash -l -i -c "nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null || echo done"

COPY ./config/nvim-after /root/.config/nvim/after

CMD ["/usr/bin/zsh", "--login"]

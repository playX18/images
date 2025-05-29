FROM ubuntu:noble

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install the Docker apt repository
RUN apt-get update && \
    apt-get upgrade --yes --no-install-recommends --no-install-suggests && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install baseline packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends --no-install-suggests \
    bash \
    zsh \
    build-essential \
    podman \
    curl \
    htop \
    jq \
    locales \
    man \
    pipx \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    wget \
    binaryen \
    protobuf-compiler \
    openssl-dev \
    rsync && \
# Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    apt-get install --yes git \
    && rm -rf /var/lib/apt/lists/*



# Generate the desired locale (en_US.UTF-8)
RUN locale-gen en_US.UTF-8

# Make typing unicode characters in the terminal work.
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Remove the `ubuntu` user and add a user `coder` so that you're not developing as the `root` user
RUN userdel -r ubuntu && \
    useradd coder \
    --create-home \
    --shell=/bin/bash \
    --groups=sudo \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder
RUN pipx ensurepath 
WORKDIR /home/coder

#RUN /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
# Uses "git", "ssh-agent" and "history-substring-search" bundled plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t gentoo -p git -p ssh-agent -p 'history-substring-search' -p zsh-autosuggestions  -p zsh-autocomplete \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

# Install zsh-autosuggestions and zsh-autocomplete plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/coder/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-/home/coder/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Enable ssh-agent, zsh-autosuggestions, and zsh-autocomplete plugins in .zshrc
#RUN sed -i 's/plugins=(git)/plugins=(git ssh-agent zsh-autosuggestions zsh-autocomplete)/' ~/.zshrc


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -L https://foundry.paradigm.xyz | sh -s -- -y

RUN echo "export PATH=\$HOME/.cargo/bin:\$PATH" >> ~/.zshrc \
    && echo "export PATH=\$HOME/.foundry/bin:\$PATH" >> ~/.zshrc
RUN mkdir -p ~/.local/bin \
    && echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.zshrc
RUN ~/.foundry/bin/foundryup
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir ~/.local/bin
RUN echo 'eval "$(starship init zsh)"' >> ~/.zshrc

CMD [ "zsh" ]
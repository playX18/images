FROM ubuntu:noble

# Install development tools, zsh, and sudo (no groupinstall for dnf5)
#RUN dnf -y update && dnf -y upgrade
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential zsh sudo cmake perl libssl-dev nano net-tools gawk
RUN apt-get update && apt-get install -y \
    podman \
    golang \
    protobuf-compiler \
    wget \
    sudo \
    htop \
    ruby \
    clang \
    llvm \
    libgit2-dev \
    gdb \
    lldb \
    which \
    binaryen \
    freeglut3-dev
# Create user 'coder' with zsh as default shell, add to wheel group for sudo
RUN useradd -m -s /usr/bin/zsh --uid=1000 -G sudo coder
RUN usermod -aG sudo coder 
RUN usermod -aG docker coder
RUN mkdir -p /etc/sudoers.d
RUN echo 'coder ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/coder
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel 
RUN chmod 0440 /etc/sudoers.d/coder
RUN chmod 0440 /etc/sudoers.d/wheel

USER coder
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
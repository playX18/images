FROM fedora:latest

# Install development tools and necessary packages
RUN sudo dnf install -y @development-tools && \
    sudo dnf install -y zsh git curl wget tar unzip gcc-c++ cmake openssl-devel protobuf-devel shadow-utils sudo binaryen

# Create user coder and add to wheel group
RUN useradd -m -s /bin/zsh coder && \
    echo "coder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -aG wheel coder

# Switch to the new user
USER coder
WORKDIR /home/coder


RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t gentoo -p git -p ssh-agent -p 'history-substring-search' -p zsh-autosuggestions  -p zsh-autocomplete \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -L https://foundry.paradigm.xyz | sh -s -- -y

RUN echo "export PATH=\$HOME/.cargo/bin:\$PATH" >> ~/.zshrc \
    && echo "export PATH=\$HOME/.foundry/bin:\$PATH" >> ~/.zshrc
RUN mkdir -p ~/.local/bin \
    && echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.zshrc
RUN ~/.foundry/bin/foundryup
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir ~/.local/bin
RUN echo 'eval "$(starship init zsh)"' >> ~/.zshrc

#RUN echo 'export PATH="/home/coder/.cargo/bin:$PATH"' >> /home/coder/.zshrc
CMD ["/bin/zsh"]

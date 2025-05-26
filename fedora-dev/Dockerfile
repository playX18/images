FROM fedora:latest

# Install development tools, zsh, and sudo (no groupinstall for dnf5)
RUN dnf -y update && dnf -y upgrade
RUN dnf install -y @development-tools zsh sudo cmake perl openssl-devel helix nano net-tools awk
RUN dnf -y install dnf-plugins-core \
    && dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
    && dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
RUN systemctl enable docker
RUN ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
RUN dnf install -y clang-devel llvm-devel libgit2-devel gdb lldb
# Create user 'coder' with zsh as default shell, add to wheel group for sudo
RUN useradd -m -s /usr/bin/zsh --uid=1000 --groups=docker -G wheel coder \
    && echo 'coder ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/coder \
    && chmod 0440 /etc/sudoers.d/coder

USER coder
WORKDIR /home/coder
SHELL ["/usr/bin/zsh", "-c"]
# Install Oh My Zsh non-interactively
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh-autosuggestions and zsh-autocomplete plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/coder/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-/home/coder/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Enable ssh-agent, zsh-autosuggestions, and zsh-autocomplete plugins in .zshrc
RUN sed -i 's/plugins=(git)/plugins=(git ssh-agent zsh-autosuggestions zsh-autocomplete)/' ~/.zshrc

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -L https://foundry.paradigm.xyz | sh -s -- -y
RUN foundryup
RUN echo "export PATH=\$HOME/.cargo/bin:\$PATH" >> ~/.zshrc \
    && echo "export PATH=\$HOME/.foundry/bin:\$PATH" >> ~/.zshrc
RUN mkdir -p ~/.local/bin \
    && echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.zshrc

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir ~/.local/bin

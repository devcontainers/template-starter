ARG VARIANT="bookworm-slim"
FROM debian:${VARIANT}

# install dependencies, upgrade & clean (keep it slim) 
RUN apt-get update && \
    apt-get install -y build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 sudo git && \
    apt-get upgrade -y && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*
 
# Create the user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Set vscode as the default user.
USER $USERNAME

# Install ghcup - Bumped versions from https://www.haskell.org/ghcup/install/ (look for "Supported tools")
RUN sudo curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_GHC_VERSION=9.4.8 \
    BOOTSTRAP_HASKELL_CABAL_VERSION=3.10.3.0 \
    BOOTSTRAP_HASKELL_STACK_VERSION=3.1.1 \
    BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
    BOOTSTRAP_HASKELL_HLS_VERSION=2.9.0.1 \
    BOOTSTRAP_HASKELL_VERBOSE=1 \
    sh

ENV PATH="/home/vscode/.cabal/bin:/home/vscode/.ghcup/bin:$PATH"

ENTRYPOINT ghc -e '"Hello Haskell!"'
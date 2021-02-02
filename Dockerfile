FROM ubuntu:latest

LABEL maintainer="dwilicious"

# environment settings
ENV HOME="/code"
ENV TZ Asia/Jakarta

RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo "**** Update repos and install some programs plus JDK ****" && \
    apt update && \
    apt install -y \
    curl \
    wget \
    git \
    nano \
    openjdk-14-jdk && \
    echo "**** install code-server ****" && \
    CODE_LATEST=$(curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4) && \
    wget $CODE_LATEST && \
    dpkg -i *.deb && \
    # Install Java
    echo "**** installing vscode java extension ****" && \
    code-server --install-extension redhat.java && \
    code-server --install-extension vscjava.vscode-java-debug && \
    code-server --install-extension vscjava.vscode-java-test && \
    code-server --install-extension vscjava.vscode-maven && \
    code-server --install-extension vscjava.vscode-java-dependency && \ 
    echo "**** clean up ****" && \
    apt purge --auto-remove -y && \
    apt autoclean -y && \
    rm -rf \
    ${HOME}/.local/share/code-server/CachedExtensionVSIXs/* \
    /code/*.deb \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# expose port to local machine for code-server
EXPOSE 8080

# run code server
ENTRYPOINT  code-server --bind-addr 0.0.0.0:8080 --auth none

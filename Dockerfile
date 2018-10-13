ARG VERSION=latest
FROM ubuntu:$VERSION

MAINTAINER Chandler <chenjiayicjy@gmail.com>

# # Basic stuff
RUN apt-get update\
    && apt-get install \
    zsh \
    build-essential \
    fontconfig \
    locales\
    locales-all\
    git \
    make \
    cmake \
    autojump\
    neovim\
    wget\
    silversearcher-ag\
    -y\
    # # Cleanup
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

RUN /bin/bash -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" -y\
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

## Install Anaconda3
RUN wget https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh  \
    && /bin/bash ~/anaconda.sh -b -p ~/anaconda \
    && rm ~/anaconda.sh \
    && /root/anaconda/bin/pip install neovim black\
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

# # Install emacs26
RUN apt-get update && apt-get install software-properties-common -y \
    && add-apt-repository ppa:kelleyk/emacs -y\
    && apt-get update && apt-get install emacs26 -y \
# Cleanup
    && apt-get purge software-properties-common -y \
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

# Settle Oh-My-Zsh setting
COPY ./dotzshrc /root/.zshrc

# Settle Chandler's dotfiles
RUN git clone https://github.com/Chandlercjy/.dotfiles ~/.dotfiles \
    && cd ~/.dotfiles && /root/anaconda/bin/python build.py\
# Cleanup
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*


ENV WORKDIR  = "\root"\
    LC_ALL = en_US.UTF-8\
    LANG = en_US.UTF-8\
    LANGUAGE = en_US.UTF-8

CMD ["zsh"]

#FROM ubuntu:22.04
# FROM alpine:3.20
FROM node:22-alpine3.20

ARG USERNAME=minipondubu
ARG USER_UID=7777
ARG USER_GID=7777
ARG command_line_git_status_file=git-status-command-line.txt

# Migrate to Alpine
RUN apk update\
    && apk add bash
#
SHELL [ "/bin/bash", "-c" ]

# Create the user
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#
# Migrate to Alpine
RUN addgroup --gid $USER_GID $USERNAME \
    && adduser --uid $USER_UID --ingroup $USERNAME --disabled-password $USERNAME\
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    #&& apt-get update\
    #&& apt-get -y upgrade\
    #
    #
    # this 3 lines for install neovim lastest unstable version from PPA
    #&& apt-get install -y software-properties-common \
    #&& add-apt-repository ppa:neovim-ppa/unstable \
    #&& apt-get update\
    #
    # install require program
    #&& apt-get install -y sudo vim wget python3-pip\
    #&& apt install -y sudo neovim tmux git lua5.4 gcc curl fontconfig unzip\
    #
    # Migrate to Alpine
    && apk add sudo vim wget\
    && apk add neovim tmux git lua5.4 gcc g++ curl fontconfig unzip\
    && apk add --no-cache python3 py3-pip py3-pandas\
    && apk add --no-cache gcompat\
    # this is for nvm
    # && apk add -U ca-certificates openssl ncurses coreutils make libgcc linux-headers grep util-linux binutils findutils\
    #
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

WORKDIR /home/${USERNAME}

RUN mkdir Documents/

####------ config for showing git status on command line ------####

# copy text file contain code for config git status in command line
COPY ${command_line_git_status_file} /home/${USERNAME}/

#add code to .bashrc and delete the text file
RUN cat ~/${command_line_git_status_file} >> ~/.bashrc && rm ~/${command_line_git_status_file}

#set LANG in .bashrd
RUN echo export LANG=en_US.UTF-8 >> ~/.bashrc
#-------------------------------------------------

####------ config git default value ------####

RUN git config --global init.defaultBranch main\
    && git config --global user.name "supattana-s"\
    && git config --global user.email "supattana.sue@gmail.com"

#-----------------------------------------------------------------#

####------ vimrc confioguration, download from github ------####

RUN mkdir ~/.vim \
    && git clone https://github.com/supattana-s/vimrc-configuration.git ~/.vim/ \
    && mv ~/.vim/.vimrc ~/.vim/vimrc

#-----------------------------------------------------------------#

####------ neovim and tmux confioguration, download from github ------####

RUN mkdir -p ~/.config/nvim \
    && mkdir ~/.config/tmux \
    && git clone https://github.com/supattana-s/nvim-configuration.git ~/.config/nvim/ \
    && git clone https://github.com/supattana-s/tmux-configuration.git ~/.config/tmux/

#-----------------------------------------------------------------#

########## use deno instead ###############

####------ install nvm and npm -----####
#
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
#
# ENV NVM_DIR /home/${USERNAME}/.nvm
# ENV NODE_VERSION node
#
#
# RUN source $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default \
#     && echo source $NVM_DIR/nvm.sh >> ~/.bashrc
#
#
# # add node and npm to path so the commands are available
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

##############################################

#tmux pre-config, install tpm and all plugins
RUN git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
RUN ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh

#install Nerd Font
RUN wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Mononoki.zip \
    && cd ~/.local/share/fonts \
    && unzip Mononoki.zip \
    && rm Mononoki.zip \
    && fc-cache -fv


#-----------------------------------------------------------------#

####------ install go -----####

RUN wget https://go.dev/dl/go1.22.1.linux-arm64.tar.gz -O go.tar.gz\
    &&  rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz \
    &&  echo export PATH=$PATH:/usr/local/go/bin >> ~/.bashrc \
    && rm go.tar.gz

#-----------------------------------------------------------------#

####------ install pandas -----####

#RUN pip3 install pandas

#-----------------------------------------------------------------#


####------ install Deno ------#####

##RUN curl -fsSL https://deno.land/install.sh | sh
COPY --from=denoland/deno:bin-2.0.0 /deno /usr/local/bin/deno

#-----------------------------------------------------------------#

RUN curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh


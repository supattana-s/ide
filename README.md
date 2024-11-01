IDE made for personal coding

Base Image: node:22-alpine3.20

language installed
    - python3
    - go
    - lua
    - js, ts

Tools installed:
    - Neovim
    - Tmux
    - npm, node
    - deno
    - gcc
    - wget
    - curl
    - git
    - unzip
    - sudo

python packages installed:
    - pandas


**You should coding inside ~/Documents
    because ~/Documents mount with ./Documents (in host folder)

    mkdir ./Documents


###### (Recommended) using Docker compose to start docker containers #####

- this command is for docker compose V2
- cd to the folder that container "compose.yml"

- after that, use command as following:
    
    docker compose up -d

    docker exec -it -u minipondubu ide bash

---------------------------------------------------------------------

## we can delete all image built cache by ##

    docker builder prune -a

---------------------------------------------------------------------


### using normal docker ###

build

    docker build --build-arg UID=$UID --build-arg GID=$GID -t ubuntu_ide .

run

    docker run -it --name <container name> ubuntu_ide /bin/bash

re-attach to active container

    docker exec -it <container name> bash

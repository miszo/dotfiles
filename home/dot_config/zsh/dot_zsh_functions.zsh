function brew_update {
    brew upgrade &&
    brew update &&
    brew cleanup &&
    asdf reshim
}

function miszo_git_local_config {
    git config --local user.name "Miszo Radomski"
    git config --local user.email "hello@miszo.dev"
    echo "Local git user email changed to miszo.dev"
    git config --local --get user.name
    git config --local --get user.email
}

function git_clear_gone_branches {
    git remote prune origin
    git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -I{} -n 1 git branch -D {}
    git prune
}

function copy_branch {
    git rev-parse --abbrev-ref HEAD | pbcopy
    echo Copied branch name: \`$(pbpaste)\`
}

function remove_docker_containers {
    echo "Stop running shit"
    docker stop $(docker ps -q)
    echo "Remove the whale shit"
    docker rm $(docker ps -a -q)
}

function remove_docker_images {
    remove_docker_containers
    echo "Remove pictures of whale shit"
    docker rmi $(docker images -f "dangling=true" -q)
}

function CLEAN_THE_FUCKING_DOCKER {
    remove_docker_images
    echo "Fucking shit, those silly fucking whales eating my fucking disk"
    docker volume rm $(docker volume ls -qf dangling=true)
    echo "done m8"
}


function git_pull_them_all {
    for D in *; do
        if [ -d "${D}/.git" ]; then
            echo "Running git pull and clean branches in ${D}" && cd "${D}" && git pull && git_clear_gone_branches && cd .. && echo "Done!\n"
        fi
    done
}

function kitty_update {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
}

function delete_recursively {
    readonly folder_name=${1:?"node_modules"}
    find . -name "$folder_name" -type d -prune -print -exec rm -rf '{}' \;
}
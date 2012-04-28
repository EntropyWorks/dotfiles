#!/usr/bin/env bash
# 
# Quick and dirty tool that you should becareful running
# it will move your old .bash files that match the _bash 
# before creating a symlink to these files
#
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak && echo "mv $target $target.bak"
    fi

    ln -sf ${source} ${target} && echo "ln -sf ${source} ${target}"
}

for i in _*
do
    link_file $i
done

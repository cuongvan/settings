RCDIR=$(realpath rcfiles)

function link_file() {
    git_file=$1     # absolute path
    dest_file=$2    # absolute path

    if [[ -e $dest_file && -L $dest_file ]] # healthy symlink
    then
        :
    elif [[ -e $dest_file && ! -L $dest_file ]]; then # normal file, not a symlink
        echo "    $dest_file is not a symlink"
        echo "        > Move ==> ${dest_file}.bak"
        mv $dest_file ${dest_file}.bak
        echo "        > Link"
        ln -s $git_file $dest_file
    elif [[ -L $dest_file ]]; then # is symlink but real file not exists
        echo "    $dest_file link is broken. Relink now"
        rm $dest_file
        ln -s $git_file $dest_file
    else
        echo "    $dest_file not found. Link now"
        ln -s $git_file $dest_file
    fi
}


echo "> Link ~/bash directory"
if [[ -L ~/bash ]]
then
    if [[ -f ~/bash ]]
    then
        echo "    ~/bash is a file. Backup to bash.bak"
        mv ~/bash ~/bash.bak
        ln -s $RCDIR/bash ~/bash
    elif [[ -d ~/bash ]]
    then
        :
    elif [[ ! -e ~/bash ]]
    then
        echo "    ~/bash is a broken symlink. Update now"
        rm ~/bash
        ln -s $RCDIR/bash ~/bash
    else
        echo "unknow case"
    fi
elif [[ -e ~/bash ]]
then
    echo "    ~/bash is not a symlink. Backup to bash.bak"
    mv ~/bash ~/bash.bak
    ln -s $RCDIR/bash ~/bash
else
    echo "    ~/bash not exists. Link now"
    ln -s $RCDIR/bash ~/bash
fi


echo "> Link ~/.bashrc"
link_file $RCDIR/bashrc $HOME/.bashrc


echo "> Link ~/.bash_profile"
if [[ -e $HOME/.profile ]]
then
    echo "    Found .profile. Will not use this file"
    echo "        > move ==> $HOME/.profile.bak"
    mv $HOME/.profile $HOME/.profile.bak
fi

link_file $RCDIR/bash_profile $HOME/.bash_profile


# terminator config files
echo "> Link ~/.config/terminator/config"
mkdir -p $HOME/.config/terminator
link_file $RCDIR/terminator $HOME/.config/terminator/config



# vscode config files
echo "> Link VS Code config files"
mkdir -p $HOME/.config/Code/User
link_file $RCDIR/vscode/keybindings.json $HOME/.config/Code/User/keybindings.json
link_file $RCDIR/vscode/settings.json $HOME/.config/Code/User/settings.json


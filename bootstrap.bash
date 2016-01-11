cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  local VUNDLE="${HOME}/.vim/bundle/Vundle.vim"
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.bash" \
    --exclude ".idea" --exclude "README.md" --exclude "LICENSE" -avh \
    --no-perms . ${HOME};

	# clone/update Vundle
	if [[ -d ${VUNDLE} ]] 
	then
          cd ${VUNDLE}
          git pull
	else
	  git clone https://github.com/gmarik/Vundle.vim.git ${VUNDLE}
	fi
	vim +PluginInstall +qall


	source ${HOME}/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

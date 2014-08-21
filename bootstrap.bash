
cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.bash" \
    --exclude ".idea" --exclude "LaunchAgents" \
		--exclude "README.md" --exclude "LICENSE" -avh --no-perms . ${HOME};

  [[ ! -d ${HOME}/betty && `command -v git` ]] && {
    /usr/bin/env git clone https://github.com/pickhardt/betty ${HOME}/betty
  }

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

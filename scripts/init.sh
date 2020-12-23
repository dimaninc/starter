#!/usr/bin/env bash

outer_path=$(pwd)
path="$outer_path/$0"
defaultUser='dimaninc'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_NO='\033[0m'

if [[ "$OSTYPE" == "darwin"* ]]; then
	isMacOs=true
else
	isMacOs=false
fi

if [[ $path =~ ((.*)/([^/]+)/scripts/init.sh)$ ]]; then
	folder=${BASH_REMATCH[3]}
	root="${BASH_REMATCH[2]}/$folder"
	echo "Root path: $root"
    echo "Website folder: $folder"
else
	echo "Unable to extract website folder from the path '$folder'"
	exit
fi

if [[ $folder =~ ^_?starter$ ]]; then
	printf "${COLOR_RED}Error:${COLOR_NO} Unable to run script on source repo\n"
	exit
fi

while [ -z ${domain} ]; do
     read -p 'Main domain: ' domain
done
while [ -z ${namespace} ]; do
     read -p 'Namespace: ' namespace
done
read -p "User [${defaultUser}]: " user
user=${user:-$defaultUser}

creator='diCMS Starter'
date=$(date +"%d.%m.%Y")
time=$(date +"%H:%M:%S")

# macros tokens
folderToken='\[%FOLDER%\]'
domainToken='\[%DOMAIN%\]'
namespaceToken='NewProject'
userToken='\[%USER%\]'
creatorToken='\[%CREATOR%\]'
dateToken='\[%DATE%\]'
timeToken='\[%TIME%\]'

environmentFullPathOrig="$root/src/$namespaceToken/Data/Environment.php"
environmentFullPath="$root/src/$namespace/Data/Environment.php"

if [[ -f $environmentFullPathOrig || -f $environmentFullPath ]]; then
	printf "${COLOR_RED}Error:${COLOR_NO} 'Environment.php' found: init script has been already executed before\n"
	exit
fi

# generate Environment class
echo "Generating Environment.php..."
cat > "$environmentFullPathOrig" << EOF
<?php
namespace $namespaceToken\Data;

class Environment extends \diCore\Data\Environment
{
    const mainDomain = '[%DOMAIN%]';
    const initiating = true;
}
EOF

cd "$root"
start_folder=$OLDPWD

# generate readme
echo "Generating README.md..."
cat > "README.md" << EOF
# NewProject
[%DOMAIN%]
EOF

# kill .git folder
echo "Killing starter's git repo..."
rm -rf .git
git init

# replace macros
echo 'Replacing variables...'
if [[ $isMacOs ]]; then
    find . -type f ! -name 'init.sh' | xargs sed -i ''\
        -e "s/$folderToken/$folder/g"\
        -e "s/$domainToken/$domain/g"\
        -e "s/$namespaceToken/$namespace/g"\
        -e "s/$userToken/$user/g"\
        -e "s/$creatorToken/$creator/g"\
        -e "s/$dateToken/$date/g"\
        -e "s/$timeToken/$time/g"
else
    find . -type f ! -name 'init.sh' | xargs sed -i\
        -e "s/$folderToken/$folder/g"\
        -e "s/$domainToken/$domain/g"\
        -e "s/$namespaceToken/$namespace/g"\
        -e "s/$userToken/$user/g"\
        -e "s/$creatorToken/$creator/g"\
        -e "s/$dateToken/$date/g"\
        -e "s/$timeToken/$time/g"
fi

# rename Namespace folder
echo "Renaming folder $root/src/$namespaceToken to $root/src/$namespace..."
mv "$root/src/$namespaceToken" "$root/src/$namespace"

# composer install
echo "Installing composer dependencies..."
composer install
composer require phpmailer/phpmailer

# core init
echo "Creating work folders..."
sh vendor/dimaninc/di_core/scripts/create_work_folders.sh
echo "Copying core assets..."
sh vendor/dimaninc/di_core/scripts/copy_core_static.sh

# npm install
echo "Installing NPM dependencies..."
cd assets
npm install

# gulp build
gulp build

# self-destruction
cd "$start_folder"
rm $0

printf "${COLOR_GREEN}Project ${folder} has been set up successfully${COLOR_NO}\n"

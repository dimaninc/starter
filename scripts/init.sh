#!/usr/bin/env bash

outer_path=$(pwd)
path="$outer_path/$0"
defaultUser='dimaninc'

if [[ "$OSTYPE" == "darwin"* ]]; then
	isMacOs=true
	sedParam=" ''"
else
	isMacOs=false
	sedParam=''
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

# generate Environment class
echo "Generating Environment.php"
cat > "$root/src/$namespaceToken/Data/Environment.php" << EOF
<?php
namespace $namespaceToken\Data;

class Environment extends \diCore\Data\Environment
{
    const mainDomain = '[%DOMAIN%]';
}
EOF

cd "$root"

# replace macros
echo 'Setting up Variables...'
find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" -e "s/$folderToken/$folder/g" -e "s/$domainToken/$domain/g" -e "s/$namespaceToken/$namespace/g" -e "s/$userToken/$user/g" -e "s/$creatorToken/$creator/g" -e "s/$dateToken/$date/g" -e "s/$timeToken/$time/g"

# rename Namespace folder
echo "Renaming folder $root/src/$namespaceToken to $root/src/$namespace"
mv "$root/src/$namespaceToken" "$root/src/$namespace"

# composer install

# npm install

# core init

# gulp build

# kill .git folder
rm -rf .git

cd - >/dev/null 2>&1

# self-destruction
rm $0

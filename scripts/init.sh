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

# replace macros
folderToken='\[%FOLDER%\]'
domainToken='\[%DOMAIN%\]'
namespaceToken='NewProject'
userToken='\[%USER%\]'
creatorToken='\[%CREATOR%\]'
dateToken='\[%DATE%\]'
timeToken='\[%TIME%\]'

cd "$root"
echo 'Setting Variables...'
find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" -e "s/$folderToken/$folder/g" -e "s/$domainToken/$domain/g" -e "s/$namespaceToken/$namespace/g" -e "s/$userToken/$user/g" -e "s/$creatorToken/$creator/g" -e "s/$dateToken/$date/g" -e "s/$timeToken/$time/g"

#echo 'Setting Folder...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$folderToken/$folder/g"
#echo 'Setting Domain...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$domainToken/$domain/g"
#echo 'Setting Namespace...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$namespaceToken/$namespace/g"
#echo 'Setting User...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$userToken/$user/g"
#echo 'Setting Creator...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$creatorToken/$creator/g"
#echo 'Setting Date...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$dateToken/$date/g"
#echo 'Setting Time...'
#find . -type f ! -name 'init.sh' | xargs sed -i"$sedParam" "s/$timeToken/$time/g"
cd - >/dev/null 2>&1

# generate Environment class

# composer install

# npm install

# core init

# gulp build

# kill .git folder

# self-destruction
#rm $0

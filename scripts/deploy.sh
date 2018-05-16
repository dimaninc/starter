#!/bin/sh

env=$1

case $env in
	prod)
		project_root="/web/[%FOLDER%]"
		;;
	stage)
		project_root="/var/www/[%FOLDER%]"
		;;
esac

if [ -z "$project_root" ];
then
	exit 0
fi

lock_dir="/var/lock/.deploy-[%FOLDER%]-$env.lock"

if mkdir $lock_dir
then
    cd $project_root
    git stash
    git pull

    composer selfupdate
    composer install

    sh vendor/dimaninc/di_core/scripts/copy_core_static.sh

    cd assets
    npm install
    gulp build

    echo "Rebuilding caches..."
    php $project_root"/scripts/rebuild_cache.php" env=$env
    echo "Template and Content caches rebuilt"

    rmdir $lock_dir
fi
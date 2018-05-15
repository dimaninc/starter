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

    cd $project_root
    composer selfupdate
    composer install

    cd $project_root"/vendor/dimaninc/di_core/scripts"
    sh copy_core_static.sh

    cd $project_root"/assets"
    npm install
    gulp build

    echo "Rebuilding caches..."
    php $project_root"/scripts/rebuild_cache.php" env=$env
    echo "Template and Content caches rebuilt"

    rmdir $lock_dir
fi
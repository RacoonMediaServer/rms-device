#!/usr/bin/bash

dir=`pwd`
cd /opt/RacoonMediaServer

# Require root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Create backup directory
now=`date +"%Y-%m-%d"`
backup_dir=/mnt/media/backup/$now
mkdir -p $backup_dir

# Determine containers ID's
nc_container=`docker-compose ps -q nextcloud`
db_container=`docker-compose ps -q postgres`
gitea_container=`docker-compose ps -q gitea`

# Backup Nextcloud
echo "=== Backup Nextcloud data ==="
docker exec -u www-data $nc_container php ./occ maintenance:mode --on 

echo "Copy files..."
rsync -Aax /mnt/data/nextcloud $backup_dir/nc/

echo "Dump database..."
docker exec $db_container pg_dump nextcloud -U user_nextcloud -f /var/lib/postgresql/data/nextcloud.bak
rsync -Aax /mnt/data/db/nextcloud.bak $backup_dir/nc.db.bak
rm /mnt/data/db/nextcloud.bak

docker exec -u www-data $nc_container php ./occ maintenance:mode --off
echo "Done."
echo ""

# Backup Gitea
echo "=== Backup Gitea data ==="
docker exec $gitea_container su - -c '/app/gitea/gitea dump -c /data/gitea/conf/app.ini -f gitea.bak.zip' git
rsync -Aax /mnt/data/git/git/gitea.bak.zip $backup_dir/
rm /mnt/data/git/git/gitea.bak.zip
echo "Done."
echo ""

# Backup Shared Data
echo "=== Backup Shared data ==="
rsync -Aax /mnt/data/shared $backup_dir/shared
echo "Done."
echo ""


echo "=== Compressing Backup ==="
backup=$backup_dir.7z
7z a $backup $backup_dir/* && rm -rf $backup_dir
echo "Done."

cd $dir

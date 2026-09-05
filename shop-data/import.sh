#!/bin/bash
# Restores the customized shop data (database + uploaded media) into a
# freshly started dockware container named "shopware".
#
# Run this AFTER the container is started and shows ready in `docker logs shopware`.
set -e

echo "Copying uploaded media files into the container..."
docker cp media/. shopware:/var/www/html/public/media/

echo "Copying image thumbnails into the container..."
docker cp thumbnail/. shopware:/var/www/html/public/thumbnail/

echo "Importing database (this can take a minute)..."
docker exec -i shopware mysql -h127.0.0.1 -uroot -proot shopware < database.sql

echo "Recompiling theme CSS/JS to match the imported settings..."
docker exec shopware php bin/console theme:compile

echo "Clearing cache..."
docker exec shopware php bin/console cache:clear

echo "Done! Open http://localhost to see the customized shop."

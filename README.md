# Shopware via Docker

This project runs a full Shopware 6 online shop locally using Docker, via the
prebuilt `dockware/dev` image (includes PHP, MySQL, and Shopware already
installed — no manual setup required).

## What you need

- **Docker** installed on your computer.
  - Windows / Mac: install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Linux: install via your package manager, e.g. `sudo apt install docker.io` (Ubuntu/Debian)

## How to run it

Open a terminal (or Command Prompt / PowerShell on Windows) and run:

```
docker run --name shopware -p 80:80 -d dockware/dev:latest
```

This downloads the Shopware image (a few GB, first time only) and starts it
in the background. Startup takes 1-3 minutes the first time.

Check it's ready:

```
docker logs shopware
```

Look for a line like `WOHOOO, dockware/dev:... IS READY :)`.

## Using it

- **Storefront** (the shop itself): http://localhost
- **Admin panel** (manage the shop): http://localhost/admin
  - Username: `admin`
  - Password: `shopware`

## Stopping / restarting

```
docker stop shopware      # stop it
docker start shopware     # start it again later (keeps your data)
docker rm shopware        # remove it completely (deletes data)
```

## Notes

- This is a completely independent copy of Shopware, separate from anyone
  else's — nothing is shared over the network. Each person who runs this
  gets their own local shop.
- Port 80 must be free on your computer. If something else is already using
  port 80, change `-p 80:80` to e.g. `-p 8080:80` and use
  http://localhost:8080 instead.

## Getting my customized version (optional)

By default the steps above give you a fresh, default Shopware install. If
you want to see the actual shop I customized (header logo/text, and a
brand navigation menu with Nike / Adidas / Puma / Reebok / Lotto /
Slazenger, each with Men / Women / Kids sub-categories), restore my saved
data on top of it:

1. Make sure the container is running (see "How to run it" above) and has
   finished starting (check `docker logs shopware` for a "READY" message).
2. From this repo folder, run:
   ```
   cd shop-data
   ./import.sh
   ```
3. Refresh http://localhost — you should now see the customized shop.

This works by loading a database backup (`shop-data/database.sql`) and the
uploaded images (`shop-data/media/`) into your container. It's safe to run
on a brand-new container; it will overwrite the default demo data.

### Already tried this and the site looked unstyled (plain text, no design)?

An earlier version of `import.sh` was missing a step, so the shop's design
files never got generated. If you already ran it before and your storefront
looks like plain unformatted text:

1. Get the latest fix: `git pull`
2. Run the import again (safe to repeat): `cd shop-data && ./import.sh`
3. Refresh http://localhost.

If it's still unstyled, run this one command directly and refresh again:
```
docker exec shopware php bin/console theme:compile
```

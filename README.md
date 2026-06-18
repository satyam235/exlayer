# Ex-Layer — marketing site

The landing page for **Ex-Layer**, the AI remediation *execution layer*: connect any
scanner and intelligently remediate security issues at scale, with your environment's
context.

Built with **Astro** (static output) — `npm run build` emits plain HTML/CSS/JS to
`dist/`, served directly by **nginx**. No Node runtime is required on the server.

## Pages

Three design directions are live as routes so they can be compared, plus a chooser:

| Route            | Direction      | Look                                              |
|------------------|----------------|---------------------------------------------------|
| `/`              | Chooser        | Pick-a-direction index                            |
| `/command-deck`  | A — Command Deck | Dark, product-true, live engine terminal        |
| `/boardroom`     | B — Boardroom  | Light, exec-editorial, drawing pipeline + metrics |
| `/blueprint`     | C — Blueprint  | Schematic, animated data-flow diagram             |

Once a direction is chosen, promote it to `/`: copy its body into `src/pages/index.astro`
(or rename), and drop the unused routes.

## Local development

Requires Node 20 (pinned in `.nvmrc`).

```bash
nvm install        # first time; installs the version in .nvmrc
nvm use            # node 20
npm install
npm run dev        # http://localhost:4321
```

Build + locally preview the production output:

```bash
npm run build      # -> dist/
npm run preview    # serves dist/ at http://localhost:4321
```

## Deploy to an Ubuntu 24.04 VM (nginx)

Static files only — build, copy to the web root, point nginx at it.

### 1. Build (locally or on the VM)

```bash
nvm use && npm ci && npm run build      # produces dist/
```

### 2. Put the files on the server

One-shot from your machine (builds + rsyncs):

```bash
./deploy/deploy.sh user@SERVER_IP        # syncs dist/ -> /var/www/exlayer
```

…or manually:

```bash
ssh user@SERVER_IP 'sudo mkdir -p /var/www/exlayer && sudo chown -R $USER /var/www/exlayer'
rsync -avz --delete dist/ user@SERVER_IP:/var/www/exlayer/
```

### 3. Configure nginx (on the VM)

```bash
sudo apt update && sudo apt install -y nginx
sudo cp deploy/nginx-exlayer.conf /etc/nginx/sites-available/exlayer
# edit server_name -> your domain
sudo ln -sf /etc/nginx/sites-available/exlayer /etc/nginx/sites-enabled/exlayer
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

### 4. HTTPS (Let's Encrypt)

Point your domain's DNS A/AAAA records at the VM, then:

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d exlayer.io -d www.exlayer.io
```

Certbot rewrites the nginx config to add the `:443` TLS server block and auto-renews.

## Updating the site

```bash
git pull            # if version-controlled
./deploy/deploy.sh user@SERVER_IP
```

Hashed assets under `/_astro/` are cached immutably; HTML is served `no-cache`, so a new
deploy is visible immediately.

## Notes

- **Set your domain** in `astro.config.mjs` (`site:`) and in `deploy/nginx-exlayer.conf`
  (`server_name`) before deploying — `site:` drives canonical URLs + the sitemap.
- Fonts load from Google Fonts via `<link>` (per design). For an air-gapped/on-prem
  deploy, self-host them and update the `fontHref` in each page.
- Animations respect `prefers-reduced-motion`.

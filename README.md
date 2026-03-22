# alchemic.it

Sito istituzionale della mia attività da libero professionista — [Gabriele Tassoni](https://www.linkedin.com/in/gabrieletassoni/).

## Tech stack

- Pure HTML5 / CSS3 / Vanilla JS — zero runtime dependencies
- Nginx 1.27 (Alpine) via Docker
- GitHub Actions for CI/CD

## Development

Open `index.html` directly in a browser, or spin up a local nginx container:

```bash
docker build -t alchemic.it .
docker run -p 8080:80 alchemic.it
# open http://localhost:8080
```

## Deployment

### GitHub Pages (preview / test)

Triggered automatically on push to `main`/`master` via `.github/workflows/deploy-pages.yml`.

Enable GitHub Pages in repository **Settings → Pages → Source → GitHub Actions**.

### Docker Hub → alchemic.it (production)

Triggered automatically on push to `main`/`master` (and semver tags) via `.github/workflows/deploy-docker.yml`.

**Required repository secrets:**

| Secret | Value |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token (read/write) |

**On the server running alchemic.it:**

```bash
docker pull gabrieletassoni/alchemic.it:latest
docker stop alchemic-it || true
docker rm alchemic-it   || true
docker run -d \
  --name alchemic-it \
  --restart unless-stopped \
  -p 80:80 \
  gabrieletassoni/alchemic.it:latest
```

> For HTTPS, terminate TLS at a reverse proxy (Caddy, Traefik, or certbot + nginx upstream) and forward to port 80 of this container.

## SEO

- Semantic HTML5, ARIA landmarks, proper heading hierarchy
- `<title>`, `<meta description>`, canonical URL
- Open Graph & Twitter Card tags
- JSON-LD structured data: `Person`, `WebSite`, `SoftwareApplication`
- `sitemap.xml` and `robots.txt`
- Nginx gzip compression and long-lived cache headers for static assets

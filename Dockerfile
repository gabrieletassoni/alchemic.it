# ── Build stage (optional: could lint/minify here) ──────────
FROM alpine:3.20 AS builder

WORKDIR /site

COPY . .

# ── Production stage ─────────────────────────────────────────
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="alchemic.it"
LABEL org.opencontainers.image.description="Gabriele Tassoni freelance portfolio"
LABEL org.opencontainers.image.url="https://alchemic.it"
LABEL org.opencontainers.image.source="https://github.com/gabrieletassoni/alchemic.it"
LABEL org.opencontainers.image.licenses="MIT"

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy site files
COPY --from=builder /site/index.html   /usr/share/nginx/html/
COPY --from=builder /site/css          /usr/share/nginx/html/css
COPY --from=builder /site/sitemap.xml  /usr/share/nginx/html/
COPY --from=builder /site/robots.txt   /usr/share/nginx/html/

# Copy img directory
COPY --from=builder /site/img/         /usr/share/nginx/html/img/

# Install custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Validate config at build time
RUN nginx -t

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1

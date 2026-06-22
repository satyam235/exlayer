import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

import cloudflare from "@astrojs/cloudflare";

// Static output — `npm run build` emits plain HTML/CSS/JS to dist/, served by nginx.
export default defineConfig({
  // change to your real domain before deploy
  site: 'https://exlayer.io',

  integrations: [sitemap()],
  build: { inlineStylesheets: 'auto' },
  adapter: cloudflare()
});
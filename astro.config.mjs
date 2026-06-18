import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Static output — `npm run build` emits plain HTML/CSS/JS to dist/, served by nginx.
export default defineConfig({
  site: 'https://exlayer.io',          // change to your real domain before deploy
  integrations: [sitemap()],
  build: { inlineStylesheets: 'auto' },
});

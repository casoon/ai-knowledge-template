import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// [Anpassen] Identität der veröffentlichten Site. In einem abgeleiteten
// Repository gehören hier der eigene Name, die eigene Repository-URL und vor
// allem die spätere Deploy-URL hin — ohne korrektes `site` erzeugt Starlight
// falsche Canonical- und Sitemap-URLs. Bei einem Deploy unter einem Unterpfad
// (z. B. GitHub Pages als Projektseite) zusätzlich `base` setzen.
const SITE_URL = 'https://casoon.github.io/ai-knowledge-template';
const SITE_TITLE = 'AI Knowledge Template';
const REPO_URL = 'https://github.com/casoon/ai-knowledge-template';

export default defineConfig({
  site: SITE_URL,
  integrations: [
    starlight({
      title: SITE_TITLE,
      description:
        'Öffentlich freigegebene Einträge aus der Wissensbasis — alles andere bleibt privat.',
      social: [{ icon: 'github', label: 'GitHub', href: REPO_URL }],
      sidebar: [
        {
          label: 'Wissensbasis',
          items: [{ autogenerate: { directory: '.' } }],
        },
      ],
    }),
  ],
});

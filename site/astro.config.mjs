import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  integrations: [
    starlight({
      title: 'AI Knowledge Template',
      description:
        'Öffentlich freigegebene Einträge aus der Wissensbasis — alles andere bleibt privat.',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/casoon/ai-knowledge-template' },
      ],
      sidebar: [
        {
          label: 'Wissensbasis',
          items: [{ autogenerate: { directory: '.' } }],
        },
      ],
    }),
  ],
});

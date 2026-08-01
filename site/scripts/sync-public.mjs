#!/usr/bin/env node
// Kopiert nur Wissenseinträge mit `public: true` im Frontmatter aus
// ../knowledge in src/content/docs. Läuft vor jedem dev/build (siehe
// package.json), damit privater Inhalt (customers/, secrets/, internal/ o. Ä.)
// niemals über die Starlight-Site erreichbar wird — nur explizit freigegebene
// Einträge landen hier.

import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import yaml from 'js-yaml';

const __dirname = dirname(fileURLToPath(import.meta.url));
const knowledgeDir = join(__dirname, '..', '..', 'knowledge');
const docsDir = join(__dirname, '..', 'src', 'content', 'docs');
const typesPath = join(knowledgeDir, '_types.yml');

const types = yaml.load(readFileSync(typesPath, 'utf8'));

if (existsSync(docsDir)) {
  rmSync(docsDir, { recursive: true, force: true });
}
mkdirSync(docsDir, { recursive: true });

let copied = 0;

for (const [categoryName, categoryConfig] of Object.entries(types.categories ?? {})) {
  if (categoryConfig.kind !== 'knowledge_entry') continue;

  const categoryDir = join(knowledgeDir, categoryName);
  if (!existsSync(categoryDir)) continue;

  for (const file of readdirSync(categoryDir)) {
    if (!file.endsWith('.md') || file === '_template.md') continue;

    const raw = readFileSync(join(categoryDir, file), 'utf8');
    const match = raw.match(/^---\n([\s\S]*?)\n---/);
    if (!match) continue;

    const frontmatter = yaml.load(match[1]) ?? {};
    if (frontmatter.public !== true) continue;

    const targetDir = join(docsDir, categoryName);
    mkdirSync(targetDir, { recursive: true });
    writeFileSync(join(targetDir, file), raw);
    copied += 1;
  }
}

console.log(`sync-public: ${copied} öffentlich freigegebene Einträge nach src/content/docs kopiert.`);

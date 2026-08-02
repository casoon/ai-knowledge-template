#!/usr/bin/env node
// Kopiert nur Wissenseinträge mit `public: true` im Frontmatter aus
// ../knowledge in src/content/docs. Läuft vor jedem dev/build (siehe
// package.json), damit privater Inhalt (kunden/, angebote/, secrets/ o. Ä.)
// niemals über die Starlight-Site erreichbar wird — nur explizit freigegebene
// Einträge landen hier.
//
// Kategorien dürfen Unterordner haben (z. B. projekte/2026/). Die Struktur
// wird beim Kopieren beibehalten; ein Eintrag darf nicht deshalb unsichtbar
// werden, weil er nach Jahr abgelegt ist.

import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join, relative } from 'node:path';
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

function* markdownFiles(dir) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* markdownFiles(full);
    } else if (entry.name.endsWith('.md') && entry.name !== '_template.md') {
      yield full;
    }
  }
}

let copied = 0;
let skipped = 0;

for (const [categoryName, categoryConfig] of Object.entries(types.categories ?? {})) {
  if (categoryConfig.kind !== 'knowledge_entry') continue;

  const categoryDir = join(knowledgeDir, categoryName);
  if (!existsSync(categoryDir)) continue;

  for (const sourcePath of markdownFiles(categoryDir)) {
    const raw = readFileSync(sourcePath, 'utf8');
    const match = raw.match(/^---\n([\s\S]*?)\n---/);
    if (!match) {
      skipped += 1;
      continue;
    }

    const frontmatter = yaml.load(match[1]) ?? {};
    if (frontmatter.public !== true) continue;

    const targetPath = join(docsDir, categoryName, relative(categoryDir, sourcePath));
    mkdirSync(dirname(targetPath), { recursive: true });
    writeFileSync(targetPath, raw);
    copied += 1;
  }
}

console.log(`sync-public: ${copied} öffentlich freigegebene Einträge nach src/content/docs kopiert.`);
if (skipped > 0) {
  console.warn(`sync-public: ${skipped} Datei(en) ohne Frontmatter übersprungen.`);
}

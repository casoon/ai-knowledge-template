use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use gray_matter::engine::YAML;
use gray_matter::Matter;
use serde::Deserialize;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use walkdir::WalkDir;

#[derive(Parser)]
#[command(about = "Validiert und pflegt eine knowledge/-Wissensbasis gegen _types.yml")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Prüft Frontmatter, Status, related-Links, Staleness, Secrets-Verschlüsselung, Attachments
    Lint {
        /// Pfad zum knowledge/-Verzeichnis
        #[arg(default_value = "knowledge")]
        knowledge_dir: PathBuf,

        /// Ab dieser Dateigröße (Bytes) wird empfohlen, _attachments.yml statt Einbetten zu nutzen
        #[arg(long, default_value_t = 500_000)]
        max_file_size: u64,
    },
    /// Entfernt Beispielinhalte aus allen Kategorien, behält Struktur und _template.md
    Clean {
        /// Pfad zum knowledge/-Verzeichnis
        #[arg(default_value = "knowledge")]
        knowledge_dir: PathBuf,
    },
}

#[derive(Debug, Deserialize)]
struct TypesConfig {
    categories: HashMap<String, CategoryConfig>,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
enum CategoryKind {
    KnowledgeEntry,
    SopsSecret,
    /// Reiner Ablageort für Dateien, die aus knowledge/_attachments.yml referenziert
    /// werden — kein Frontmatter-Schema, keine Inhaltsprüfung.
    Assets,
}

#[derive(Debug, Deserialize)]
struct CategoryConfig {
    kind: CategoryKind,
    #[serde(rename = "type")]
    entry_type: Option<String>,
    review_interval_days: Option<i64>,
}

#[derive(Debug, Default, Deserialize)]
struct Frontmatter {
    title: Option<String>,
    #[serde(rename = "type")]
    entry_type: Option<String>,
    created: Option<String>,
    last_reviewed: Option<String>,
    status: Option<String>,
    source: Option<String>,
    #[serde(default)]
    related: Vec<String>,
    #[allow(dead_code)]
    public: Option<bool>,
}

#[derive(Debug, Deserialize)]
struct AttachmentsFile {
    #[serde(default)]
    attachments: Vec<AttachmentEntry>,
}

#[derive(Debug, Deserialize)]
struct AttachmentEntry {
    id: String,
    path: String,
    #[allow(dead_code)]
    description: Option<String>,
    #[serde(default)]
    #[allow(dead_code)]
    referenced_by: Vec<String>,
}

struct Reporter {
    errors: usize,
    warnings: usize,
}

impl Reporter {
    fn new() -> Self {
        Self {
            errors: 0,
            warnings: 0,
        }
    }
    fn error(&mut self, msg: impl AsRef<str>) {
        println!("  FEHLER: {}", msg.as_ref());
        self.errors += 1;
    }
    fn warn(&mut self, msg: impl AsRef<str>) {
        println!("  WARNUNG: {}", msg.as_ref());
        self.warnings += 1;
    }
}

const SECRET_PATTERNS: &[&str] = &[
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN OPENSSH PRIVATE KEY-----",
    "-----BEGIN RSA PRIVATE KEY-----",
    "AGE-SECRET-KEY-1",
];

const SECRET_PREFIXES: &[&str] = &["sk-", "ghp_", "gho_", "AKIA", "xoxb-", "xoxp-"];

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Command::Lint {
            knowledge_dir,
            max_file_size,
        } => run_lint(&knowledge_dir, max_file_size),
        Command::Clean { knowledge_dir } => run_clean(&knowledge_dir),
    }
}

fn load_types(knowledge_dir: &Path) -> Result<TypesConfig> {
    let types_path = knowledge_dir.join("_types.yml");
    let types_raw = fs::read_to_string(&types_path)
        .with_context(|| format!("Konnte {} nicht lesen", types_path.display()))?;
    serde_yaml::from_str(&types_raw)
        .with_context(|| format!("Konnte {} nicht als YAML parsen", types_path.display()))
}

fn run_lint(knowledge_dir: &Path, max_file_size: u64) -> Result<()> {
    let mut reporter = Reporter::new();
    let types = load_types(knowledge_dir)?;

    lint_categories(knowledge_dir, &types, max_file_size, &mut reporter)?;
    lint_attachments(knowledge_dir, &mut reporter);

    println!();
    if reporter.errors > 0 {
        println!(
            "{} Fehler, {} Warnung(en) gefunden.",
            reporter.errors, reporter.warnings
        );
        std::process::exit(1);
    }
    println!("Alle Prüfungen bestanden ({} Warnung(en)).", reporter.warnings);
    Ok(())
}

fn run_clean(knowledge_dir: &Path) -> Result<()> {
    let types = load_types(knowledge_dir)?;

    for (name, category) in &types.categories {
        let dir = knowledge_dir.join(name);
        fs::create_dir_all(&dir)?;

        for entry in fs::read_dir(&dir)? {
            let entry = entry?;
            let path = entry.path();
            if !path.is_file() {
                continue;
            }
            let file_name = path.file_name().and_then(|n| n.to_str()).unwrap_or("");

            let keep = match category.kind {
                CategoryKind::KnowledgeEntry => file_name == "_template.md",
                CategoryKind::SopsSecret | CategoryKind::Assets => file_name == ".gitkeep",
            };
            if !keep {
                fs::remove_file(&path)
                    .with_context(|| format!("Konnte {} nicht löschen", path.display()))?;
            }
        }

        fs::write(dir.join(".gitkeep"), "")?;
        println!("Bereinigt: knowledge/{name}/");
    }

    let attachments_path = knowledge_dir.join("_attachments.yml");
    if attachments_path.exists() {
        fs::write(
            &attachments_path,
            "# Zentrale Registry für Verweise auf große Originaldateien, siehe README.md.\n\nattachments: []\n",
        )?;
        println!("Zurückgesetzt: knowledge/_attachments.yml");
    }

    println!("Fertig. knowledge/_template.md dient als Vorlage für neue Einträge.");
    Ok(())
}

fn lint_categories(
    knowledge_dir: &Path,
    types: &TypesConfig,
    max_file_size: u64,
    reporter: &mut Reporter,
) -> Result<()> {
    for entry in fs::read_dir(knowledge_dir)
        .with_context(|| format!("Konnte {} nicht lesen", knowledge_dir.display()))?
    {
        let entry = entry?;
        if !entry.file_type()?.is_dir() {
            continue;
        }
        let name = entry.file_name().to_string_lossy().to_string();
        let Some(category) = types.categories.get(&name) else {
            println!("Prüfe knowledge/{name}/");
            reporter.error(format!(
                "Kategorie '{name}' ist nicht in _types.yml deklariert"
            ));
            continue;
        };

        match category.kind {
            CategoryKind::KnowledgeEntry => {
                lint_knowledge_category(&entry.path(), &name, category, max_file_size, reporter)?
            }
            CategoryKind::SopsSecret => lint_secrets_category(&entry.path(), reporter)?,
            CategoryKind::Assets => {}
        }
    }
    Ok(())
}

fn lint_knowledge_category(
    dir: &Path,
    category_name: &str,
    category: &CategoryConfig,
    max_file_size: u64,
    reporter: &mut Reporter,
) -> Result<()> {
    let matter = Matter::<YAML>::new();
    let today = chrono::Local::now().date_naive();

    for entry in WalkDir::new(dir).into_iter().filter_map(Result::ok) {
        let path = entry.path();
        if !path.is_file() || path.extension().is_none_or(|ext| ext != "md") {
            continue;
        }
        if path.file_name().and_then(|n| n.to_str()) == Some("_template.md") {
            continue;
        }

        println!("Prüfe {}", path.display());

        let size = fs::metadata(path)?.len();
        if size > max_file_size {
            reporter.warn(format!(
                "Datei ist {} KB groß — große Inhalte eher über knowledge/_attachments.yml referenzieren statt einbetten",
                size / 1000
            ));
        }

        let raw = fs::read_to_string(path)
            .with_context(|| format!("Konnte {} nicht lesen", path.display()))?;
        scan_for_secrets(&raw, reporter);

        let fm = match matter.parse_with_struct::<Frontmatter>(&raw) {
            Some(p) => p.data,
            None => {
                reporter.error("Frontmatter fehlt oder ist nicht lesbar");
                continue;
            }
        };

        if fm.title.as_deref().unwrap_or("").is_empty() {
            reporter.error("title fehlt");
        }
        if fm.source.as_deref().unwrap_or("").is_empty() {
            reporter.error("source fehlt");
        }
        if fm.created.as_deref().unwrap_or("").is_empty() {
            reporter.error("created fehlt");
        }

        match fm.status.as_deref() {
            None | Some("") => reporter.error("status fehlt"),
            Some("aktuell") | Some("veraltet") => {}
            Some(other) => reporter.error(format!(
                "status '{other}' ist weder 'aktuell' noch 'veraltet'"
            )),
        }

        match (&fm.entry_type, &category.entry_type) {
            (Some(t), Some(expected)) if t != expected => reporter.error(format!(
                "type '{t}' passt nicht zu Kategorie '{category_name}' (erwartet: '{expected}')"
            )),
            (None, Some(_)) => reporter.error("type fehlt"),
            _ => {}
        }

        match &fm.last_reviewed {
            None => reporter.error("last_reviewed fehlt"),
            Some(date_str) => match chrono::NaiveDate::parse_from_str(date_str, "%Y-%m-%d") {
                Ok(date) => {
                    let age_days = (today - date).num_days();
                    if fm.status.as_deref() == Some("aktuell") {
                        if let Some(interval) = category.review_interval_days {
                            if age_days > interval {
                                reporter.warn(format!(
                                    "last_reviewed liegt {age_days} Tage zurück (> {interval}), Eintrag ist aber als 'aktuell' markiert"
                                ));
                            }
                        }
                    }
                }
                Err(_) => reporter.error(format!(
                    "last_reviewed '{date_str}' ist kein gültiges Datum (YYYY-MM-DD)"
                )),
            },
        }

        let dir = path.parent().unwrap_or(Path::new("."));
        for rel in &fm.related {
            let target = dir.join(rel);
            if !target.exists() {
                reporter.error(format!(
                    "related-Verweis '{rel}' zeigt auf keine vorhandene Datei"
                ));
            }
        }
    }
    Ok(())
}

fn lint_secrets_category(dir: &Path, reporter: &mut Reporter) -> Result<()> {
    for entry in WalkDir::new(dir).into_iter().filter_map(Result::ok) {
        let path = entry.path();
        if !path.is_file() {
            continue;
        }
        if path.file_name().and_then(|n| n.to_str()) == Some(".gitkeep") {
            continue;
        }

        println!("Prüfe {}", path.display());

        let raw = fs::read_to_string(path)
            .with_context(|| format!("Konnte {} nicht lesen", path.display()))?;

        match serde_yaml::from_str::<serde_yaml::Value>(&raw) {
            Ok(serde_yaml::Value::Mapping(map)) => {
                let has_sops_marker = map
                    .keys()
                    .any(|k| k.as_str() == Some("sops"));
                if !has_sops_marker {
                    reporter.error(
                        "Datei in secrets/ enthält kein sops-Metadatenfeld — nicht SOPS-verschlüsselt?",
                    );
                }
            }
            Ok(_) => reporter.error("Datei in secrets/ ist kein YAML-Mapping — erwartet ein SOPS-verschlüsseltes Dokument"),
            Err(e) => reporter.error(format!("Datei in secrets/ ist kein gültiges YAML: {e}")),
        }
    }
    Ok(())
}

fn scan_for_secrets(content: &str, reporter: &mut Reporter) {
    for pattern in SECRET_PATTERNS {
        if content.contains(pattern) {
            reporter.error(format!(
                "möglicher Klartext-Schlüssel gefunden (Muster: '{pattern}') — gehört nach knowledge/secrets/, verschlüsselt"
            ));
        }
    }
    for prefix in SECRET_PREFIXES {
        if content
            .split_whitespace()
            .any(|word| word.trim_matches(|c: char| !c.is_alphanumeric() && c != '_' && c != '-').starts_with(prefix) && word.len() > prefix.len() + 8)
        {
            reporter.warn(format!(
                "möglicher API-Key mit Präfix '{prefix}' gefunden — prüfen, ob das ein echtes Secret ist"
            ));
        }
    }
}

fn lint_attachments(knowledge_dir: &Path, reporter: &mut Reporter) {
    let path = knowledge_dir.join("_attachments.yml");
    if !path.exists() {
        return;
    }

    println!("Prüfe {}", path.display());

    let raw = match fs::read_to_string(&path) {
        Ok(r) => r,
        Err(e) => {
            reporter.error(format!("Konnte {} nicht lesen: {e}", path.display()));
            return;
        }
    };

    let parsed: AttachmentsFile = match serde_yaml::from_str(&raw) {
        Ok(p) => p,
        Err(e) => {
            reporter.error(format!("{} ist kein gültiges YAML: {e}", path.display()));
            return;
        }
    };

    for att in &parsed.attachments {
        if att.id.is_empty() {
            reporter.error("Attachment ohne id");
        }
        // Pfade in _attachments.yml sind relativ zu knowledge/ (wo die Datei liegt).
        check_attachment_path(&att.id, &att.path, knowledge_dir, reporter);
    }
}

fn check_attachment_path(id: &str, raw_path: &str, base_dir: &Path, reporter: &mut Reporter) {
    if raw_path.starts_with("http://") || raw_path.starts_with("https://") {
        match ureq::head(raw_path).call() {
            Ok(_) => {}
            Err(e) => reporter.warn(format!(
                "Attachment '{id}': URL '{raw_path}' nicht erreichbar ({e})"
            )),
        }
        return;
    }

    // Netzlaufwerk-Schemata lassen sich von hier aus nicht prüfen.
    for scheme in ["smb://", "afp://", "nas://"] {
        if raw_path.starts_with(scheme) {
            return;
        }
    }

    let candidate = if Path::new(raw_path).is_absolute() {
        PathBuf::from(raw_path)
    } else {
        base_dir.join(raw_path)
    };
    if !candidate.exists() {
        reporter.error(format!(
            "Attachment '{id}': Pfad '{raw_path}' existiert nicht"
        ));
    }
}

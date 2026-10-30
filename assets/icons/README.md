# Icons – Streamline "Streamline Light"

Discourse bündelt alle Icons in **einem Sprite**. Dieses Theme lädt
[`tk-icons.svg`](tk-icons.svg) (registriert in [`../../about.json`](../../about.json)
als `"icons-sprite"`).

> **Lizenz:** Streamline-Icons nur mit gültiger Streamline-Lizenz einbinden. Das
> Repo enthält nur Platzhalter im Streamline-Light-Stil – keine Original-Pfade.

## Icon-Manager (empfohlen für einzelne Icons)

[`icon-manager.html`](icon-manager.html) – eine eigenständige, lokale Oberfläche
für `tk-icons.svg`: **öffnen**, alle vorhandenen Icons **auflisten** (mit
Vorschau), **umbenennen**, **löschen**, neue SVGs per Drag & Drop **hinzufügen**
(inkl. Namensvergabe + automatischer `currentColor`-Umwandlung) und wieder
**speichern** – direkt in der Datei auf der Platte, kein Upload, kein Server.

**Nutzung:** `icon-manager.html` doppelklicken (öffnet im Standardbrowser) →
**„Sprite öffnen…"** → `tk-icons.svg` auswählen. Änderungen sammeln sich im
Speicher, **„Speichern"** schreibt sie zurück in die Originaldatei.

- Erfordert **Chrome oder Edge** (File System Access API) fürs direkte
  Speichern. In Firefox/Safari funktioniert Laden + Bearbeiten trotzdem, nur
  „Speichern" wird zu „Als Kopie herunterladen" – die heruntergeladene Datei
  dann manuell über `tk-icons.svg` kopieren.
- **„svg_icon_subset kopieren"** kopiert alle aktuellen Namen kommasepariert
  in die Zwischenablage – direkt einfügbar in die gleichnamige Site-Einstellung
  (siehe Schritt 3 unten).
- Umbenennen/Löschen ändert nur das Sprite. Referenzen in `category_icons`,
  `icon_overrides` oder `svg_icon_subset` danach von Hand nachziehen.
- Für Massen-Import ganzer Ordner bleibt [`build-sprite.mjs`](build-sprite.mjs)
  (unten) die schnellere Wahl.

## Workflow (manuell / Batch)

### 1 · Icons bei Streamline holen

streamlinehq.com → Set **Streamline Light** → gewünschtes Icon → **Download → SVG**
(oder mehrere als ZIP). Ein Export sieht so aus:

```xml
<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M…" stroke="#000000" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

### 2 · In ein `<symbol>` umwandeln und in `tk-icons.svg` einfügen

- `<svg …>` → `<symbol id="tk-NAME" viewBox="0 0 24 24">`, `</svg>` → `</symbol>`
- `stroke="#000000"` / `stroke="#000"` / `stroke="black"` → **`stroke="currentColor"`**
  (oder Attribut entfernen und in einen `<g fill="none" stroke="currentColor"
  stroke-linecap="round" stroke-linejoin="round">…</g>` wrappen – so machen es die
  Platzhalter in `tk-icons.svg`)
- keine festen `width`/`height` am `<symbol>` (nur `viewBox`)

Batch geht mit [`build-sprite.mjs`](build-sprite.mjs) (Node ≥ 18):

```bash
# alle .svg aus ./streamline-export/ zu Symbolen zusammenfassen:
node assets/icons/build-sprite.mjs streamline-export > assets/icons/tk-icons.svg
```

Das Script wrappt jede Datei als `<symbol id="tk-<dateiname>">`, ersetzt harte
Stroke-Farben durch `currentColor` und setzt `fill="none"`.

### 3 · Namen freischalten (`svg_icon_subset`)

Namen, die **nicht fest im Code** stehen (also über Einstellungen gewählt), in
die Site-Einstellung eintragen:

> Admin → Einstellungen → Filter „icons" → **`svg_icon_subset`**
> vollständige, aktuelle Liste siehe unten unter „`tk-icons.svg` – aktueller
> Stand" (oder: `icon-manager.html` öffnen → **„svg_icon_subset kopieren"** →
> direkt einfügen – immer synchron mit dem tatsächlichen Sprite-Inhalt).

Fehlt ein Name in `svg_icon_subset`, taucht das Icon zwar im eigenen
Hero-Panel/Kachel-Grid auf (die laufen direkt über das Sprite), aber **nicht**
im normalen Discourse-Icon-Picker (z. B. „Kategorie bearbeiten → Stil →
Symbol") – dort durchsucht Core nur Namen aus `svg_icon_subset`.

Danach **Strg + F5**.

### 4 · Verwenden

| Wo | So |
| --- | --- |
| Überall im UI | `{{d-icon "tk-server"}}` |
| Discourse-Icon global ersetzen | `api.replaceIcon("bars", "tk-menu")` (api-initializer) |
| **Kategorien durchgängig auf Streamline** | Komponente *TK Kategorien* → Einstellung **`use_sprite_icons` = an** → Panel & Kachel-Grid nutzen `tk-server` … `tk-default` aus dem Sprite |
| Einzelne Kategorie | `icon_overrides`: `server-hardware,tk-server-rack` |

Font-Awesome-Icons (falls doch mal nötig): kein SVG, nur den Namen in
`svg_icon_subset` (`far-bell`, `fab-github`).

## `tk-icons.svg` – aktueller Stand

**Echte Streamline-Icons** (bereits konvertiert):

| Symbol-id | Streamline-Export |
| --- | --- |
| `tk-server` | Server 2 |
| `tk-storage` | Floppy Disk |
| `tk-network` | Monitor Network |
| `tk-linux` | Linux Logo |
| `tk-virt` | Proxmox Logo |
| `tk-automation` | Factory Industrial Robot Arm 1 |
| `tk-chip` | Crypto Blockchain Technology Chip |
| `tk-shield` | Protection Shield 1 |
| `tk-chat` | Feedback 2 |
| `tk-support` | Contact Us Customer Support Chat |
| `tk-calendar` | Calendar Date 5 |
| `tk-team` | Programming Team Chat |
| `tk-faq` | Contact Us Faq |
| `tk-rules` | Rules Book Todo |
| `tk-mail` | Send Email Envelope |
| `tk-welcome` | Messages Bubble Laptop Hi |
| `tk-wiki` | Book Library |
| `tk-cart` | Shopping Cart Add |

**Noch Line-Platzhalter** (Streamline-Icon reinkopieren): `tk-edge`, `tk-ops`,
`tk-cloud`, `tk-wrench`, `tk-book`, `tk-default`.

**Was pro Icon gemacht wurde:** `<svg …>` → `<symbol id="tk-…" viewBox="…">`
(viewBox **aus dem Export**, hier `-2 -2 140 140`), `<desc>` / `<defs>` /
`<title>` entfernt, `<g>`-Wrapper flach, `stroke="#ff7d00"` →
`stroke="currentColor"`, alles in ein `<g fill="none">` gelegt. Pfade,
`stroke-width="4"`, `stroke-miterlimit` unverändert.

> **`<svg>` NICHT in `.js`-Dateien einfügen** – Babel parst das als JSX und der
> Theme-Build bricht ab. Icons gehören ausschließlich in dieses Sprite.

**`svg_icon_subset`** (alle Sprite-Namen, kommasepariert):

```
tk-server, tk-storage, tk-network, tk-edge, tk-linux, tk-virt, tk-automation, tk-ops, tk-chip, tk-shield, tk-cloud, tk-wrench, tk-book, tk-chat, tk-default, tk-support, tk-calendar, tk-team, tk-faq, tk-rules, tk-mail, tk-welcome, tk-wiki, tk-cart
```

Referenz: [Custom SVG icons in a theme](https://meta.discourse.org/t/replace-discourses-default-svg-icons-with-custom-icons-in-a-theme/115736)

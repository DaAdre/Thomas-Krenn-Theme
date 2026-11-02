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

### 5 · Standard-Icons global ersetzen (Marken-Icons)

Die Einstellung **`icon_replacements`** (im Haupttheme, nicht in TK
Kategorien) ersetzt Discourse-Standard-Icons forumweit durch eigene
Sprite-Symbole – ein Eintrag pro Zeile: `discourse-name,tk-name`. Technisch
`api.replaceIcon()` pro Zeile (`javascripts/discourse/api-initializers/
tk-icon-replace.js`).

**Ablauf:**

1. Icon bei Streamline (o. ä.) holen, in `icon-manager.html` öffnen und als
   `<symbol>` unter dem **tk-Namen aus der Tabelle unten** hinzufügen.
2. Namen in **`svg_icon_subset`** eintragen (siehe Schritt 3 oben – auch
   hier gilt: ohne Eintrag kein Core-Icon-Picker-Treffer, aber `replaceIcon`
   funktioniert trotzdem, da es direkt das Sprite nutzt).
3. Fertig – `icon_replacements` ist schon vorausgefüllt und muss i. d. R.
   nicht geändert werden. Fehlt ein Symbol im Sprite noch, bleibt an der
   Stelle nur eine leere Fläche (kein Fehler) – also gefahrlos nach und nach
   ergänzbar.

Vorausgefüllte Zuordnung (Standardwert von `icon_replacements`) – **fett**
markierte tk-Namen existieren bereits im Sprite:

| Discourse-Icon | tk-Name | Wo im UI |
| --- | --- | --- |
| `bars` | `tk-menu` | Hamburger-Menü (Kopfzeile) |
| `magnifying-glass` | `tk-search` | Suche |
| `bell` | `tk-bell` | Benachrichtigungen |
| `circle-user`, `user` | `tk-user` | Profil/Avatar-Platzhalter |
| `gear` | `tk-settings` | Einstellungen |
| `house` | `tk-home` | Startseite |
| `d-chat`, `comment` | `tk-message` | Chat/Kommentar |
| `reply` | `tk-reply` | Antworten |
| `heart` | `tk-heart` | Gefällt mir |
| `bookmark` | `tk-bookmark` | Lesezeichen |
| `share-nodes` | `tk-share` | Teilen |
| `flag` | `tk-flag` | Melden |
| `ellipsis`, `ellipsis-vertical` | `tk-more` | Mehr-Menü |
| `link` | `tk-link` | Link kopieren |
| `pencil` | `tk-edit` | Bearbeiten |
| `trash-can` | `tk-trash` | Löschen |
| `plus` | `tk-plus` | Neu/Hinzufügen |
| `xmark` | `tk-close` | Schließen |
| `check` | `tk-check` | Bestätigen |
| `thumbtack` | `tk-pin` | Anheften |
| `envelope` | **`tk-mail`** | E-Mail |
| `eye`, `eye-slash` | `tk-eye`, `tk-eye-slash` | Beobachten/Stumm |
| `lock` | `tk-lock` | Geschlossen |
| `chevron-down`/`-up`/`-left`/`-right`, `angle-down`/`-up` | `tk-chevron-*` | Aufklappen |
| `caret-down`, `caret-right` | `tk-caret-down`, `tk-caret-right` | Auswahl-Pfeile |
| `arrow-left`/`-right`/`-up`/`-down` | `tk-arrow-*` | Navigation |
| `circle-exclamation`, `triangle-exclamation` | `tk-warning` | Warnung |
| `circle-info` | `tk-info` | Info |
| `circle-question` | `tk-question` | Hilfe |
| `clock` | `tk-clock` | Zeit |
| `calendar-days` | **`tk-calendar`** | Kalender/Termine |
| `file-lines` | `tk-file` | Datei |
| `image` | `tk-image` | Bild |
| `paperclip` | `tk-attachment` | Anhang |
| `code` | `tk-code` | Code |
| `quote-right` | `tk-quote` | Zitat |
| `bold`, `italic` | `tk-bold`, `tk-italic` | Editor-Formatierung |
| `list-ul`, `list-ol` | `tk-list`, `tk-list-numbered` | Listen |
| `table` | `tk-table` | Tabelle |
| `shield-halved` | **`tk-shield`** | Vertrauensstufe/Staff |
| `wrench` | **`tk-wrench`** | Admin-Werkzeuge |
| `gavel` | `tk-gavel` | Moderation |
| `ban` | `tk-ban` | Sperren |
| `users` | **`tk-team`** | Gruppen/Team |
| `star` | `tk-star` | Favorit |
| `upload`, `download` | `tk-upload`, `tk-download` | Datei-Transfer |
| `rotate` | `tk-refresh` | Aktualisieren |
| `copy` | `tk-copy` | Kopieren |
| `print` | `tk-print` | Drucken |

Eigene Zuordnungen hinzufügen/ändern: einfach weitere `name,tk-name`-Zeilen
in `icon_replacements` ergänzen – kein Code nötig.

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

Sobald weitere Icons für `icon_replacements` (Abschnitt 5 oben) ergänzt
werden, deren Namen hier mit aufnehmen – am einfachsten über
`icon-manager.html` → **„svg_icon_subset kopieren"**, das holt immer den
kompletten, aktuellen Sprite-Inhalt.

Referenz: [Custom SVG icons in a theme](https://meta.discourse.org/t/replace-discourses-default-svg-icons-with-custom-icons-in-a-theme/115736)

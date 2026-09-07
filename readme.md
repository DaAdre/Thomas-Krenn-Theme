# Forum Theme – IT-Infrastruktur Community

Ein dunkles, professionelles Discourse-Theme für herstellerunabhängige IT-Fachforen. Entwickelt für Sysadmins, Netzwerktechniker und Infrastruktur-Verantwortliche, die einen strukturierten, seriösen Rahmen für Fachaustausch suchen.

## Übersicht

Das Theme kombiniert ein dunkles Farbschema mit klaren orangenen Akzenten und setzt auf eine kategoriegetriebene Startseite statt einer klassischen chronologischen Themenliste. Ziel ist ein professioneller, "enterprise-tauglicher" Auftritt, der sich von Standard-Discourse-Installationen abhebt.

## Farbschema & Typografie

- **Hintergrund:** Dunkles Anthrazit/Schwarz (`#141414` – `#1a1a1a`)
- **Akzentfarbe:** Orange (`#F7931E`-Ton) für CTAs, Icons und Überschriften-Highlights
- **Schrift:** Serifenlose, moderne Systemschrift; kräftige Headline-Gewichtung, ruhiger Fließtext in Grau/Weiß
- **Kontrast:** Weiße Primärtexte auf dunklem Grund, gedämpfte Grautöne für Sekundärinformationen (Antworten, Teilnehmer, Zeitangaben)

## Layout-Struktur

### Header
- Logo (Icon + Wortmarke "forum")
- Hauptnavigation: *Kategorien, Forum, Aktuelles, Über uns*
- Zwei CTA-Buttons rechts: *Anmelden* (Outline-Stil) und *Beitreten* (gefüllt, orange)

### Hero-Bereich
- Große, zweifarbige Headline (Orange + Weiß) mit Claim, z. B. *„Herstellerunabhängiger Fachaustausch für alle, die professionelle IT-Infrastruktur betreiben."*
- Zentrale Suchleiste mit thematischem Platzhaltertext (z. B. „Welche Frage hast du heute? z. B. ZFS, VLAN, Ansible …") zur direkten Forensuche

### Sidebar „Kategorien"
- Eigene Themenbereich-Übersicht mit Icon je Kategorie
- Beispielkategorien: Server & Hardware, Storage, Netzwerk, Edge & Industrie-IT, Linux & Betriebssysteme, Virtualisierung & Container, Automatisierung & Infrastructure, Aus der Praxis: Betrieb & Troubleshooting
- Kurzer Erklärtext zur Abonnierbarkeit einzelner Kategorien

### Content-Bereich (unterhalb des Hero)
- **Letzte Beiträge:** einfache, kompakte Liste aktueller Themen
- **Meist diskutiert:** Karte mit Antworten-/Teilnehmerzahl und "Mitdiskutieren"-Button
- **Aktuelles/Event-Banner:** großformatige Promo-Kachel (z. B. Ankündigung einer Fachveranstaltung wie „proxtalks")
- Weitere Themenkacheln am unteren Rand (redaktionelle Beiträge, Community-Vorstellung, Beitritts-CTA)

## Funktionale Merkmale

- Card-basierte Darstellung statt reiner Listenansicht
- Icon-Set (Line-Icons) zur visuellen Unterscheidung der Kategorien
- Responsive Grid: Hero + Sidebar zweispaltig, darunter mehrspaltiges Kachel-Layout
- Klare CTA-Hierarchie (Suche im Fokus, Beitreten als primäre Handlung)

## Zielgruppe

IT-Professionals und Administratoren mit Fokus auf Server, Storage, Netzwerk, Virtualisierung und Automatisierung – Positionierung als seriöse, herstellerunabhängige Alternative zu produktgebundenen Community-Foren.

## Technische Hinweise (Discourse-Umsetzung)

- Umsetzung vermutlich über eine angepasste **Home-Page-Komponente** (Custom Homepage / `discourse-custom-homepage`) statt Standard-Kategorienliste
- Sidebar-Kategorien lassen sich über ein **Category-Icon-Theme-Component** realisieren
- Farbschema als eigenes **Color Scheme** (Dark) im Theme hinterlegt
- Event-/Promo-Banner vermutlich als Theme-Component oder manuell eingebundenes HTML-Widget auf der Startseite

---

# Umsetzung

**Ein Theme + zwei Komponenten**, verbunden über **Plugin-Outlets** und
`api.renderInOutlet` (gleicher Ansatz wie
[`discourse-minimal-category-boxes`](https://github.com/discourse/discourse-minimal-category-boxes)).
Keine Plugins, keine DOM-Hacks – reguläre `.gjs`-Komponenten, deren Lebenszyklus
Ember verwaltet.

```
TK-Theme/Thomas-Krenn-Theme/   ← Theme: Farben, Header, Custom Homepage, Hero-Shell + Outlets
TK-Komponenten/TK-Kategorien/  ← rendert in  tk-hero-aside  +  above-discovery-categories
TK-Komponenten/TK-News/        ← rendert in  tk-hero-news
```

## Custom Homepage

`about.json` setzt den Modifier `custom_homepage` → die Route `/` zeigt die
**Landing-Page** (`<TkHomepage>` im Outlet `custom-homepage`) statt der
Themenliste. Das Forum bleibt unter `/latest`, `/categories`, `/top` … erreichbar
(Sidebar-Links, Header-Navigation).

- `custom_homepage_enabled = false` → `/` leitet auf die normale Startliste um.
- `latest_teaser_count` steuert den „Letzte Beiträge"-Teaser auf der Landing-Page.
- `show_hero_on_discovery = true` → der Hero erscheint zusätzlich auf `/latest` …
  (Komponente `<TkDiscoveryHero>` im Outlet `below-site-header`).

## Aufgabenteilung

| Bereich | Wo | Details |
| --- | --- | --- |
| **Farbschema** | Theme | Zwei Color Schemes in [`about.json`](about.json): **„TK Forum Dark"** (BG `#161719`) und **„TK Forum Light"** (BG `#f7f8fa`). Der Header bleibt in beiden dunkel. Alle Inhalts-Farben leiten sich in `common.scss` aus `--primary` / `--secondary` / `--tertiary` ab und flippen automatisch. |
| **Typografie** | Theme | Mitgelieferte Schrift aus [`assets/fonts/`](assets/fonts/) (in `about.json` → `"assets"` registriert), als `@font-face "TK Theme Font"` in `common/common.scss` eingebunden → CSS-Variable `--tk-font`. Fallback **Inter** ([`common/head_tag.html`](common/head_tag.html)) → System-Sans. Eigene Schrift per `assets/fonts/` + `about.json` oder Upload-Einstellungen. |
| **Icons** | Theme | Icon-Sprache **Streamline „Streamline Light"** über das SVG-Sprite [`assets/icons/tk-icons.svg`](assets/icons/tk-icons.svg) (`about.json` → `"assets": {"icons-sprite": …}`, 15 Platzhalter `tk-server … tk-default`). Streamline-Exporte via [`assets/icons/build-sprite.mjs`](assets/icons/build-sprite.mjs) zu `<symbol>` bündeln, Namen in `svg_icon_subset` eintragen. Nutzbar als `{{d-icon "tk-…"}}`, `api.replaceIcon(...)` oder in *TK Kategorien* (`icon_overrides` bzw. `use_sprite_icons = an` für das ganze Panel). Details: [`assets/icons/README.md`](assets/icons/README.md). |
| **Header** | Theme | Logo-Zeichen (≡) + Wortmarke, zentrierte **konfigurierbare** Navigation (`nav_links`), *Anmelden* (Outline) + *Beitreten* (orange). |
| **Hero + Suche** | Theme | [`components/tk-hero-body.gjs`](javascripts/discourse/components/tk-hero-body.gjs): zweifarbige Headline + – Setting `search_style` – die **echte Discourse-Suche** (`<SearchMenu>` aus `discourse/components/search-menu`, Live-Ergebnisse als Dropdown via `api.forceDropdownForMenuPanels`) oder ein einfaches `/search`-Feld. Stellt die Outlets `tk-hero-aside` und `tk-hero-news` bereit. |
| **Kategorien** | Komponente **TK Kategorien** | (a) Hero-**Panel** (`tk-hero-aside`, aus `site.categories`) und (b) **Kategorienseite `/categories` als Kachel-Grid** (`above-discovery-categories`, `@outletArgs.categories`). Icon je Kategorie per Heuristik oder Override; Beschreibung = `description_excerpt` der Kategorie oder überschreibbar. Standard-Liste wird per `html.tk-category-tiles-active` ausgeblendet. |
| **Aktuelles / News** | Komponente **TK News** | `tk-hero-news`. Ein/mehrere Einträge (`news_items`), erster als großes Banner (teal/orange/dark, optionales Bild). |
| **Forenlisten** | Theme | `/latest` … bekommen Karten-Optik; Filterleiste + Sidebar optional aus (`hide_list_nav_on_home`, `hide_sidebar_on_home`). |

## Theme-Dateistruktur

```
Thomas-Krenn-Theme/
├── about.json                       # Color Schemes + modifiers.custom_homepage + assets
├── settings.yml
├── assets/fonts/                    # eigene Schriftdateien (siehe README dort)
├── assets/icons/tk-icons.svg        # eigenes Icon-Sprite (siehe README dort)
├── common/
│   ├── common.scss                  # Design-System + @font-face (assets/fonts/) + Styling
│   └── head_tag.html                # Inter (Fallback-Schrift)
├── javascripts/discourse/
│   ├── components/
│   │   ├── tk-hero-body.gjs         # Headline + <SearchMenu> + <PluginOutlet tk-hero-aside/news>
│   │   ├── tk-homepage.gjs          # Outlet custom-homepage: Hero + Teaser (+ enable/redirect)
│   │   └── tk-discovery-hero.gjs    # Outlet below-site-header: Hero auf /latest … (optional)
│   └── api-initializers/
│       ├── tk-hero.js               # renderInOutlet(custom-homepage / below-site-header)
│       └── tk-chrome.js             # Header-Nav, Button-Texte, Body-Flags
└── locales/en.yml
```

## Outlet-Mechanik

`tk-hero-body.gjs` rendert `<PluginOutlet @name="tk-hero-aside" />` und
`<PluginOutlet @name="tk-hero-news" />`. Die Komponenten hängen sich per
`api.renderInOutlet("tk-hero-aside", …)` bzw. `("tk-hero-news", …)` ein –
unabhängig von der Ladereihenfolge. Fehlt eine Komponente, bleibt der Outlet
leer (`.tk-hero` wird einspaltig, `:has(.tk-panel--categories)`); fehlt das
Theme, gibt es die Outlets `tk-hero-*` nicht – die Kategorienseite funktioniert
trotzdem (nur ohne Theme-Styling).

## Installation (Reihenfolge beachten)

1. **Theme**: Ordner `Thomas-Krenn-Theme/` zippen → Admin → **Anpassen → Themes →
   Installieren → Von deinem Gerät**. Als Standard-Theme aktivieren. Unter dem
   Theme das Standard-Schema wählen (**„TK Forum Dark"** oder **„TK Forum Light"**);
   für automatisches Umschalten das jeweils andere als *dunkles Farbschema*
   eintragen. Beide auf *vom Benutzer wählbar* stellen, damit Mitglieder in ihren
   Einstellungen wechseln können.
2. **TK Kategorien**: Ordner `TK-Kategorien/` zippen → **Komponente installieren**
   → dem TK Forum Theme als übergeordnetes Theme zuweisen.
3. **TK News**: analog mit Ordner `TK-News/`.
4. Discourse ≥ **3.4** (`.gjs`, `<SearchMenu>`, `custom_homepage`-Modifier –
   sonst `search_style = simple`).

## Einstellungen

**Theme:** `brand_name`, `replace_logo`, `show_top_nav`, `nav_links`,
`login_button_text`, `signup_button_text`, `custom_homepage_enabled`,
`latest_teaser_count`, `teaser_prefer_name`, `hero_heading_accent`,
`hero_heading_rest`, `search_style` (native/simple), `hero_search_placeholder`,
`show_hero_on_discovery`, `home_paths`, `hide_list_nav_on_home`,
`hide_sidebar_on_home`, `show_latest_section_title`, `latest_section_title` ·
Fonts: `custom_font_family_name`, `custom_font_variable`, `custom_font_regular`,
`custom_font_medium`, `custom_font_bold` (Details: `assets/fonts/README.md`).

**TK Kategorien:** `only_top_level`, `exclude_categories`, `icon_overrides`,
`order_by` · Hero-Panel: `panel_title`, `panel_subtitle`, `max_categories`,
`show_topic_count` · Kategorienseite: `enable_categories_page`,
`categories_page_title`, `categories_page_intro`, `categories_page_columns`,
`description_max_length`, `topics_label`, `category_descriptions`,
`category_topics`.

**TK News:** `news_enabled`, `news_items`, `news_style`, `news_image`,
`news_open_new_tab`, `news_secondary_list`.

## Bewusste Abgrenzung

- **„Meist diskutiert"** als eigenes Daten-Widget ist nicht enthalten – dafür
  wäre der `discourse-topic-list`-Ansatz/ein Plugin nötig.
- Logo wird per CSS/Wortmarke nachgebaut (`replace_logo`). Echtes Logo hochladen
  → `replace_logo = false`.
- Styling **aller** Komponenten-Inhalte liegt zentral im Theme (`common.scss`) –
  die Komponenten liefern nur Markup und benötigen daher das Theme.
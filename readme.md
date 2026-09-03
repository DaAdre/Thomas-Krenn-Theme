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

Der Entwurf ist in **ein Theme + drei Komponenten** aufgeteilt. Das Theme liefert
Design-System und Hero-Grundgerüst mit zwei leeren **Slots**; die Komponenten
füllen diese Slots mit eigenen Inhalten. Keine Plugins nötig.

```
TK-Theme/Thomas-Krenn-Theme/     ← Theme  (Farben, Header, Hero-Shell, echte Suche, Slots)
TK-Komponenten/TK-Kategorien/    ← Komponente  → Slot data-tk-slot="aside"  (dynamisches Kategorien-Panel)
TK-Komponenten/TK-News/          ← Komponente  → Slot data-tk-slot="news"   (Aktuelles-/Event-Banner)
```

## Aufgabenteilung

| Bereich | Wo | Details |
| --- | --- | --- |
| **Farbschema** | Theme | Color Scheme *„TK Forum Dark"* in [`about.json`](about.json) – BG `#161719`, Header `#141414`, Akzent `#F7931E`. |
| **Typografie** | Theme | Schrift **Inter** über [`common/head_tag.html`](common/head_tag.html). |
| **Header** | Theme | Logo-Zeichen (≡) + Wortmarke, zentrierte **konfigurierbare** Navigation (`nav_links`), *Anmelden* (Outline) + *Beitreten* (orange). |
| **Hero + Suche** | Theme | Komponente [`components/tk-hero.gjs`](javascripts/discourse/components/tk-hero.gjs), eingehängt via `renderInOutlet("below-site-header", …)`. Rendert die zweifarbige Headline und – Setting `search_style` – die **echte Discourse-Suche** (`<SearchMenu>` aus `discourse/components/search-menu`, Live-Ergebnisse als Dropdown) oder ein einfaches Feld, das `/search` öffnet. |
| **Kategorien-Panel** | Komponente **TK Kategorien** | Baut das Panel aus den **echten Kategorien** des Forums (kein statischer Text). Icon je Kategorie per Heuristik (Slug/Name) oder Override. Neue Kategorie im Admin → erscheint automatisch. |
| **Aktuelles / News** | Komponente **TK News** | Ein oder mehrere Einträge (`news_items`), erster als großes Banner (teal/orange/dark, optionales Bild). |
| **Themenliste** | Theme | Discourse-Liste bekommt auf der Startseite Karten-Optik + Titel `latest_section_title`; Filterleiste wird ausgeblendet (`hide_list_nav_on_home`). |

## Theme-Dateistruktur

```
Thomas-Krenn-Theme/
├── about.json                                  # Metadaten + Color Scheme
├── settings.yml                                # Theme-Einstellungen
├── common/
│   ├── common.scss                             # Design-System + Styling ALLER Slot-Inhalte
│   └── head_tag.html                           # Inter-Font
├── javascripts/discourse/
│   ├── components/
│   │   └── tk-hero.gjs                          # Hero-Markup + <SearchMenu> + Slots, isHome-Gate
│   └── api-initializers/
│       ├── tk-hero.js                           # renderInOutlet(below-site-header) + Such-Dropdown
│       └── tk-chrome.js                         # Header-Nav, Button-Texte, Body-Flags
└── locales/en.yml
```

## Slot-Mechanik

Die Hero-Komponente rendert:

```html
<div class="tk-hero-slot" data-tk-slot="aside"></div>   <!-- TK Kategorien -->
<div class="tk-hero-slot" data-tk-slot="news"></div>    <!-- TK News -->
```

Jede Komponente sucht nach jedem Seitenwechsel „ihren" Slot und füllt ihn. Fehlt
eine Komponente, bleibt der Slot leer (`:empty { display:none }`) und der Hero
wird einspaltig. Fehlt das Theme, gibt es keinen Slot – die Komponenten sind
wirkungslos, ohne Fehler.

## Installation (Reihenfolge beachten)

1. **Theme** installieren: Ordner `Thomas-Krenn-Theme/` zippen → Admin →
   **Anpassen → Themes → Installieren → Von deinem Gerät**. Als Standard-Theme
   aktivieren, unter **Farben** Schema **„TK Forum Dark"** wählen.
2. **TK Kategorien** installieren: Ordner `TK-Kategorien/` zippen → Admin →
   **Themes → Komponente installieren → Von deinem Gerät** → dem TK Forum Theme
   als übergeordnetes Theme zuweisen.
3. **TK News** installieren: analog mit Ordner `TK-News/`.
4. Discourse ≥ **3.4** (wegen `.gjs`/`<SearchMenu>` – sonst `search_style = simple`).

Alle drei lassen sich alternativ per Git-Repo installieren.

## Einstellungen

**Theme:** `brand_name`, `replace_logo`, `show_top_nav`, `nav_links`,
`login_button_text`, `signup_button_text`, `hero_heading_accent`,
`hero_heading_rest`, `search_style` (native/simple), `hero_search_placeholder`,
`home_paths`, `hide_list_nav_on_home`, `hide_sidebar_on_home`,
`show_latest_section_title`, `latest_section_title`.

**TK Kategorien:** `panel_title`, `panel_subtitle`, `only_top_level`,
`max_categories`, `show_topic_count`, `exclude_categories`, `icon_overrides`,
`order_by`.

**TK News:** `news_enabled`, `news_items`, `news_style`, `news_image`,
`news_open_new_tab`, `news_secondary_list`.

## Bewusste Abgrenzung

- **„Meist diskutiert"** als eigenes Daten-Widget ist nicht enthalten – dafür
  wäre der `discourse-topic-list`-Ansatz/ein Plugin nötig. Die reguläre
  Discourse-Liste („Letzte Beiträge") wird stattdessen in Karten-Optik gebracht.
- Logo wird per CSS/Wortmarke nachgebaut (`replace_logo`). Echtes Logo hochladen
  → `replace_logo = false`.
- Styling **aller** Slot-Inhalte liegt zentral im Theme (`common.scss`) – die
  Komponenten liefern nur Markup und benötigen daher das Theme.
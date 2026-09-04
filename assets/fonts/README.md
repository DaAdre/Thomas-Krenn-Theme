# Custom Fonts

Schriftdateien des TK Forum Themes.

## Mitgeliefert & aktiv

| Datei | Gewicht | about.json-Key |
| --- | --- | --- |
| `Thomas-Krenn-Light.ttf` | 300 | `tk-font-light` |
| `Thomas-Krenn-Regular.ttf` | 400 | `tk-font-regular` |
| `Thomas-Krenn-Bold.ttf` | 700 | `tk-font-bold` |
| `Thomas-Krenn-Italic.ttf` | 400 · italic | `tk-font-italic` |

Die Keys sind in [`../../about.json`](../../about.json) unter `"assets"`
registriert. [`../common.scss`](../common.scss) baut daraus `@font-face`-Regeln
mit dem internen Familiennamen **„TK Theme Font"**; die CSS-Variable `--tk-font`
nutzt sie: `"TK Theme Font", "Inter", <System-Sans>`. Fehlt eine Datei / ein Key,
greift automatisch der nächste Font im Stack.

> `.ttf` funktioniert, **`.woff2` ist deutlich kleiner** – für die Produktion
> konvertieren (z. B. `woff2_compress`) und danach Dateinamen + `about.json`
> anpassen.

## Andere Schrift verwenden

**A) Dateien austauschen**
1. eigene `.woff2`/`.ttf` hier ablegen (auch ein Variable-Font möglich).
2. `about.json` → `"assets"` auf die neuen Dateinamen zeigen lassen. Keys:
   `tk-font-light` · `tk-font-regular` · `tk-font-medium` · `tk-font-bold` ·
   `tk-font-italic` · `tk-font-variable` (hat Vorrang, deckt alle Gewichte ab).
   Nur vorhandene Keys eintragen.

**B) Hochladen (ohne about.json)**
Admin → **Anpassen → Themes → TK Forum → Einstellungen**:
`custom_font_variable` / `custom_font_regular` / `_medium` / `_bold`.
Wird der Upload abgelehnt: `woff2` (bzw. `woff,ttf,otf`) zur Site-Einstellung
`authorized_extensions` hinzufügen.

Beide Wege binden die Schrift als **„TK Theme Font"** ein – am Stack in
`common.scss` muss nichts geändert werden.

## Lizenz

Nur Schriften einbinden, für die eine Web-Embedding-Lizenz vorliegt. Die
mitgelieferte „Thomas Krenn"-Schrift ist vom Betreiber zu lizenzieren; Inter
(Fallback, `common/head_tag.html`) steht unter der SIL OFL.

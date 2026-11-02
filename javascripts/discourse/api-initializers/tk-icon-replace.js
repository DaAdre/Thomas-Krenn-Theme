import { apiInitializer } from "discourse/lib/api";

/**
 * Ersetzt Standard-Discourse-Icons global durch eigene Sprite-Symbole aus
 * assets/icons/tk-icons.svg - gesteuert über die Einstellung
 * `icon_replacements` ("discourse-name,tk-name" pro Zeile), ohne
 * Code-Änderung erweiterbar.
 *
 * Jeder eigene Name muss als <symbol> im Sprite liegen UND zusätzlich in
 * der Site-Einstellung svg_icon_subset eingetragen sein (siehe
 * assets/icons/README.md) - sonst bleibt an der Stelle eine leere Fläche,
 * kein Fehler, kein Absturz.
 */
function splitList(value) {
  const raw = Array.isArray(value) ? value.join("|") : String(value || "");
  return raw
    .split("|")
    .map((row) => row.trim())
    .filter(Boolean);
}

export default apiInitializer((api) => {
  splitList(settings.icon_replacements).forEach((row) => {
    const i = row.indexOf(",");
    if (i === -1) {
      return;
    }
    const from = row.slice(0, i).trim();
    const to = row.slice(i + 1).trim();
    if (!from || !to) {
      return;
    }
    api.replaceIcon(from, to);
  });
});

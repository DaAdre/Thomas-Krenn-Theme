#!/usr/bin/env node
/**
 * Baut aus einem Ordner einzelner SVG-Dateien (z. B. Streamline-"Light"-Exporte)
 * ein Discourse-Icon-Sprite.
 *
 *   node assets/icons/build-sprite.mjs <ordner> [praefix] > assets/icons/tk-icons.svg
 *
 * - <symbol id="<praefix><dateiname>" viewBox="…"> je Datei (praefix default "tk-")
 * - harte Stroke-/Fill-Farben (#000, #000000, black) -> currentColor
 * - fill standardmaessig "none" (Streamline Light ist stroke-basiert)
 * - keine width/height am <symbol>
 *
 * Kein npm noetig (Node >= 18).
 */
import { readdirSync, readFileSync } from "node:fs";
import { basename, extname, join } from "node:path";

const dir = process.argv[2];
const prefix = process.argv[3] ?? "tk-";

if (!dir) {
  console.error("Aufruf: node build-sprite.mjs <ordner> [praefix]");
  process.exit(1);
}

const slug = (name) =>
  basename(name, extname(name))
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");

const files = readdirSync(dir)
  .filter((f) => f.toLowerCase().endsWith(".svg"))
  .sort();

const symbols = files.map((file) => {
  const raw = readFileSync(join(dir, file), "utf8");

  const viewBox = (raw.match(/viewBox="([^"]+)"/) || [])[1] || "0 0 24 24";

  // Inhalt zwischen <svg …> und </svg>
  let inner = (raw.match(/<svg[^>]*>([\s\S]*?)<\/svg>/i) || [])[1] || "";

  inner = inner
    .replace(/<\?xml[\s\S]*?\?>/gi, "")
    .replace(/<!--[\s\S]*?-->/g, "")
    .replace(/(stroke|fill)="(#000000|#000|black)"/gi, '$1="currentColor"')
    .replace(/(stroke|fill):\s*(#000000|#000|black)/gi, "$1:currentColor")
    .trim();

  return (
    `  <symbol id="${prefix}${slug(file)}" viewBox="${viewBox}">` +
    `<g fill="none" stroke="currentColor" stroke-linecap="round" ` +
    `stroke-linejoin="round">${inner}</g></symbol>`
  );
});

process.stdout.write(
  `<?xml version="1.0" encoding="UTF-8"?>\n` +
    `<!-- generiert von build-sprite.mjs aus "${dir}" -->\n` +
    `<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">\n` +
    symbols.join("\n") +
    `\n</svg>\n`
);

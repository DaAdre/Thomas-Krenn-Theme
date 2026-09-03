import { apiInitializer } from "discourse/lib/api";
import { schedule } from "@ember/runloop";
import TkHero from "../components/tk-hero";

/**
 * Hängt den Hero über dem Hauptinhalt ein (Outlet `below-site-header`) und
 * sorgt dafür, dass die Ergebnisse der eingebetteten <SearchMenu> als
 * andockendes Dropdown erscheinen – nicht als seitenbreite Leiste.
 */
export default apiInitializer((api) => {
  api.renderInOutlet("below-site-header", TkHero);

  api.forceDropdownForMenuPanels?.("search-menu-panel");

  // Platzhaltertext der echten Suche an den Entwurf angleichen.
  const placeholder = String(settings.hero_search_placeholder || "").trim();
  if (placeholder) {
    api.onPageChange(() => {
      schedule("afterRender", () => {
        const input = document.getElementById("tk-hero-search-input");
        if (input && input.getAttribute("placeholder") !== placeholder) {
          input.setAttribute("placeholder", placeholder);
        }
      });
    });
  }
});

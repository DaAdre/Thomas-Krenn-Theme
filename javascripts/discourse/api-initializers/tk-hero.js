import { apiInitializer } from "discourse/lib/api";
import { schedule } from "@ember/runloop";
import TkDiscoveryHero from "../components/tk-discovery-hero";
import TkHomepage from "../components/tk-homepage";

/**
 * Bindet die Startseiten-Komponenten in die passenden Outlets ein:
 *   custom-homepage    -> <TkHomepage>       (Landing-Page unter "/")
 *   below-site-header  -> <TkDiscoveryHero>  (optional auf /latest …)
 *
 * Ausserdem: Such-Ergebnisse der <SearchMenu> als andockendes Dropdown,
 * Platzhaltertext des Suchfelds an den Entwurf angleichen.
 */
export default apiInitializer((api) => {
  api.renderInOutlet("custom-homepage", TkHomepage);

  if (settings.show_hero_on_discovery) {
    api.renderInOutlet("below-site-header", TkDiscoveryHero);
  }

  api.forceDropdownForMenuPanels?.("search-menu-panel");

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

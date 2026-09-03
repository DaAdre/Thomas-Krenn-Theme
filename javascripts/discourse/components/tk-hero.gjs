import Component from "@glimmer/component";
import { service } from "@ember/service";
import SearchMenu from "discourse/components/search-menu";
import { defaultHomepage } from "discourse/lib/utilities";

/**
 * Hero der Startseite. Wird per `renderInOutlet("below-site-header", …)`
 * eingehängt (siehe api-initializers/tk-hero.js).
 *
 *  - zweifarbige Überschrift
 *  - echte Discourse-Suche (<SearchMenu>) oder – Setting `search_style` –
 *    ein einfaches Feld, das die Volltextsuche /search öffnet
 *  - Slot data-tk-slot="aside"  -> Komponente "TK Kategorien"
 *  - Slot data-tk-slot="news"   -> Komponente "TK News"
 */
export default class TkHero extends Component {
  @service router;

  get extraHomeRoutes() {
    const raw = Array.isArray(settings.home_paths)
      ? settings.home_paths.join("|")
      : String(settings.home_paths || "");
    return raw
      .split("|")
      .map((p) => p.trim().replace(/^\//, "").replace(/\/+$/, ""))
      .filter(Boolean);
  }

  get isHome() {
    if (!settings.show_hero) {
      return false;
    }
    const route = this.router.currentRouteName || "";
    if (route === `discovery.${defaultHomepage()}`) {
      return true;
    }
    if (route.startsWith("discovery.")) {
      return this.extraHomeRoutes.includes(route.slice("discovery.".length));
    }
    return false;
  }

  get useNativeSearch() {
    return settings.search_style !== "simple";
  }

  get accent() {
    return settings.hero_heading_accent;
  }

  get rest() {
    return settings.hero_heading_rest;
  }

  get placeholder() {
    return settings.hero_search_placeholder;
  }

  get showLatestTitle() {
    return settings.show_latest_section_title && !!settings.latest_section_title;
  }

  get latestTitle() {
    return settings.latest_section_title;
  }

  <template>
    {{#if this.isHome}}
      <div class="tk-hero-root">
        <div class="tk-hero">
          <div class="tk-hero__main">
            <h1 class="tk-hero__title">
              <span class="tk-accent">{{this.accent}}</span>
              <span class="tk-plain">{{this.rest}}</span>
            </h1>

            <div class="tk-hero__search">
              {{#if this.useNativeSearch}}
                <SearchMenu @searchInputId="tk-hero-search-input" />
              {{else}}
                <form
                  class="tk-hero__search-simple"
                  role="search"
                  action="/search"
                  method="get"
                >
                  <input
                    type="search"
                    name="q"
                    autocomplete="off"
                    spellcheck="false"
                    placeholder={{this.placeholder}}
                    aria-label={{this.placeholder}}
                  />
                </form>
              {{/if}}
            </div>
          </div>

          <div class="tk-hero-slot" data-tk-slot="aside"></div>
        </div>

        <div class="tk-hero-slot" data-tk-slot="news"></div>

        {{#if this.showLatestTitle}}
          <h2 class="tk-section-title">{{this.latestTitle}}</h2>
        {{/if}}
      </div>
    {{/if}}
  </template>
}

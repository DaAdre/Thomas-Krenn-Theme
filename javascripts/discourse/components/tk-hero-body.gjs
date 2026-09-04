import Component from "@glimmer/component";
import PluginOutlet from "discourse/components/plugin-outlet";
import SearchMenu from "discourse/components/search-menu";

/**
 * Innerer Hero: zweifarbige Überschrift + echte Forensuche.
 * Stellt zwei Outlets bereit, in die Theme-Komponenten rendern:
 *   tk-hero-aside  -> "TK Kategorien" (Kategorien-Panel)
 *   tk-hero-news   -> "TK News"       (Aktuelles-Banner)
 *
 * Wird von <TkHomepage> (Custom Homepage) und <TkDiscoveryHero>
 * (optional auf /latest …) eingebunden.
 */
export default class TkHeroBody extends Component {
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

  <template>
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

      <PluginOutlet @name="tk-hero-aside" />
    </div>

    <PluginOutlet @name="tk-hero-news" />
  </template>
}

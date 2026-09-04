import Component from "@glimmer/component";
import { service } from "@ember/service";
import { defaultHomepage } from "discourse/lib/utilities";
import TkHeroBody from "./tk-hero-body";

/**
 * Optionaler Hero auf den Forenlisten (/latest, /categories …).
 * Nur aktiv, wenn Setting `show_hero_on_discovery = true`; wird dann via
 * renderInOutlet("below-site-header", …) eingehängt.
 */
export default class TkDiscoveryHero extends Component {
  @service router;

  get routes() {
    const raw = Array.isArray(settings.home_paths)
      ? settings.home_paths.join("|")
      : String(settings.home_paths || "");
    return raw
      .split("|")
      .map((p) => p.trim().replace(/^\//, "").replace(/\/+$/, ""))
      .filter(Boolean);
  }

  get isHome() {
    const route = this.router.currentRouteName || "";
    if (route === `discovery.${defaultHomepage()}`) {
      return true;
    }
    if (route.startsWith("discovery.")) {
      return this.routes.includes(route.slice("discovery.".length));
    }
    return false;
  }

  get showLatestTitle() {
    return settings.show_latest_section_title && !!settings.latest_section_title;
  }

  <template>
    {{#if this.isHome}}
      <div class="tk-hero-root">
        <TkHeroBody />

        {{#if this.showLatestTitle}}
          <h2 class="tk-section-title">{{settings.latest_section_title}}</h2>
        {{/if}}
      </div>
    {{/if}}
  </template>
}

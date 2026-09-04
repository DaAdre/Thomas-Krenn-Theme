import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { defaultHomepage } from "discourse/lib/utilities";
import TkHeroBody from "./tk-hero-body";

/**
 * Custom Homepage ("/") – wird via renderInOutlet("custom-homepage", …)
 * eingehängt (about.json: modifiers.custom_homepage = true).
 *
 * Zeigt Hero + Kategorien-Panel + News + einen "Letzte Beiträge"-Teaser,
 * statt sofort der Themenliste. Das Forum bleibt unter /latest, /categories …
 *
 * `custom_homepage_enabled = false` -> leitet auf die normale Startliste um.
 */
export default class TkHomepage extends Component {
  @service router;

  @tracked topics = [];

  get enabled() {
    return settings.custom_homepage_enabled;
  }

  @action
  async setup() {
    if (!this.enabled) {
      this.router.replaceWith(`discovery.${defaultHomepage()}`);
      return;
    }

    const count = parseInt(settings.latest_teaser_count, 10) || 0;
    if (count <= 0) {
      return;
    }

    try {
      const data = await ajax("/latest.json");
      this.topics = (data?.topic_list?.topics ?? [])
        .filter((t) => !t.pinned && t.visible !== false)
        .slice(0, count)
        .map((t) => ({
          title: t.title,
          url: `/t/${t.slug}/${t.id}`,
          replies: Math.max(0, (t.posts_count ?? 1) - 1),
        }));
    } catch {
      this.topics = [];
    }
  }

  <template>
    <div class="tk-homepage" {{didInsert this.setup}}>
      {{#if this.enabled}}
        <div class="tk-hero-root">
          <TkHeroBody />

          {{#if this.topics.length}}
            <h2 class="tk-section-title">{{settings.latest_section_title}}</h2>
            <div class="tk-teaser-list">
              {{#each this.topics as |topic|}}
                <a class="tk-teaser" href={{topic.url}}>
                  <span class="tk-teaser__title">{{topic.title}}</span>
                  <span class="tk-teaser__meta">{{topic.replies}} Antworten</span>
                </a>
              {{/each}}
            </div>
          {{/if}}
        </div>
      {{/if}}
    </div>
  </template>
}

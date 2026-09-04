import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import getURL from "discourse/lib/get-url";
import { defaultHomepage } from "discourse/lib/utilities";
import TkHeroBody from "./tk-hero-body";

/**
 * Custom Homepage ("/") – via renderInOutlet("custom-homepage", …)
 * (about.json: modifiers.custom_homepage = true).
 *
 * Hero + Kategorien-Panel + News + "Letzte Beiträge"-Teaser mit Autor und –
 * falls es Antworten gibt – Zeitpunkt + letztem Autor der letzten Antwort.
 *
 * `custom_homepage_enabled = false` -> leitet auf die normale Startliste um.
 */
function displayName(user) {
  if (!user) {
    return "";
  }
  return settings.teaser_prefer_name && user.name
    ? user.name
    : user.username || user.name || "";
}

function avatar(user, size = 48) {
  if (!user?.avatar_template) {
    return null;
  }
  return getURL(user.avatar_template.replace("{size}", String(size)));
}

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
      const users = new Map((data?.users ?? []).map((u) => [u.id, u]));
      const list = (data?.topic_list?.topics ?? [])
        .filter((t) => !t.pinned && t.visible !== false)
        .slice(0, count);

      this.topics = list.map((t) => {
        const posters = t.posters ?? [];
        const op = users.get(posters[0]?.user_id);
        const latestPoster =
          posters.find((p) => (p.extras || "").includes("latest")) ??
          posters[posters.length - 1];
        const last = users.get(latestPoster?.user_id);
        const hasReplies = (t.posts_count ?? 1) > 1;

        return {
          title: t.title,
          url: `/t/${t.slug}/${t.id}`,
          replies: Math.max(0, (t.posts_count ?? 1) - 1),
          author: displayName(op),
          authorAvatar: avatar(op),
          lastReplyBy: hasReplies ? displayName(last) : "",
          lastReplyAvatar: hasReplies ? avatar(last) : null,
          lastReplyAt:
            hasReplies && t.last_posted_at
              ? moment(t.last_posted_at).fromNow()
              : "",
        };
      });
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
                  <span class="tk-teaser__main">
                    <span class="tk-teaser__title">{{topic.title}}</span>
                    <span class="tk-teaser__byline">
                      {{#if topic.authorAvatar}}
                        <img
                          class="tk-teaser__avatar"
                          src={{topic.authorAvatar}}
                          alt=""
                          width="20"
                          height="20"
                          loading="lazy"
                        />
                      {{/if}}
                      <span>{{topic.author}}</span>
                    </span>
                  </span>

                  <span class="tk-teaser__meta">
                    <span class="tk-teaser__replies">{{topic.replies}} Antworten</span>
                    {{#if topic.lastReplyAt}}
                      <span class="tk-teaser__last">
                        <span>zuletzt {{topic.lastReplyAt}}</span>
                        {{#if topic.lastReplyBy}}
                          <span class="tk-teaser__sep">·</span>
                          {{#if topic.lastReplyAvatar}}
                            <img
                              class="tk-teaser__avatar"
                              src={{topic.lastReplyAvatar}}
                              alt=""
                              width="18"
                              height="18"
                              loading="lazy"
                            />
                          {{/if}}
                          <span>{{topic.lastReplyBy}}</span>
                        {{/if}}
                      </span>
                    {{/if}}
                  </span>
                </a>
              {{/each}}
            </div>
          {{/if}}
        </div>
      {{/if}}
    </div>
  </template>
}

import { apiInitializer } from "discourse/lib/api";
import { schedule } from "@ember/runloop";

/**
 * Header-Chrome des TK-Themes:
 *  - zentrierte, konfigurierbare Kopf-Navigation (`nav_links`)
 *  - Umbenennung der Anmelden-/Beitreten-Buttons
 *  - Body-Flags (`tk-home`, `tk-logo`, `tk-hide-list-nav`) + Wortmarke
 *
 * Der Hero selbst wird von der Komponente `components/tk-hero.gjs` gerendert
 * (Outlet `below-site-header`); Kategorien-Panel und News-Banner kommen aus
 * eigenen Theme-Komponenten.
 */
function splitList(value) {
  const raw = Array.isArray(value) ? value.join("|") : String(value || "");
  return raw
    .split("|")
    .map((row) => row.trim())
    .filter(Boolean);
}

function fields(row, count) {
  const parts = row.split(",").map((p) => p.trim());
  if (parts.length <= count) {
    while (parts.length < count) {
      parts.push("");
    }
    return parts;
  }
  const tail = parts.slice(-(count - 1));
  const head = parts.slice(0, parts.length - (count - 1)).join(", ");
  return [head, ...tail];
}

export default apiInitializer("1.14.0", (api) => {
  const s = settings;

  const homePaths = splitList(s.home_paths).map(
    (p) => p.replace(/\/+$/, "") || "/"
  );

  function isHome() {
    const path = window.location.pathname.replace(/\/+$/, "") || "/";
    return homePaths.includes(path);
  }

  function setFlags() {
    const root = document.documentElement;
    root.classList.toggle("tk-home", isHome());
    root.classList.toggle("tk-logo", !!s.replace_logo);
    root.classList.toggle("tk-hide-list-nav", !!s.hide_list_nav_on_home);
    root.classList.toggle("tk-hide-sidebar", !!s.hide_sidebar_on_home);
    root.style.setProperty(
      "--tk-brand",
      JSON.stringify(String(s.brand_name || "forum"))
    );
  }

  function buildTopNav() {
    if (!s.show_top_nav) {
      document.querySelector(".d-header .contents .tk-nav")?.remove();
      return;
    }
    const contents = document.querySelector(".d-header .contents");
    if (!contents || contents.querySelector(".tk-nav")) {
      return;
    }

    const rows = splitList(s.nav_links);
    if (!rows.length) {
      return;
    }

    const nav = document.createElement("nav");
    nav.className = "tk-nav";
    rows.forEach((row) => {
      const [label, url, target] = fields(row, 3);
      if (!label) {
        return;
      }
      const a = document.createElement("a");
      a.href = url || "/";
      a.textContent = label;
      if (target === "_blank" || /^https?:\/\//.test(url || "")) {
        a.target = "_blank";
        a.rel = "noopener";
      }
      nav.appendChild(a);
    });

    const logo = contents.querySelector(".home-logo");
    if (logo && logo.nextSibling) {
      contents.insertBefore(nav, logo.nextSibling);
    } else {
      contents.appendChild(nav);
    }
  }

  function relabelAuthButtons() {
    [
      [".login-button", s.login_button_text],
      [".sign-up-button", s.signup_button_text],
    ].forEach(([selector, text]) => {
      if (!text) {
        return;
      }
      const btn = document.querySelector(`.d-header ${selector}`);
      if (!btn) {
        return;
      }
      const label = btn.querySelector(".d-button-label");
      if (label) {
        label.textContent = text;
      } else if (!btn.querySelector("svg")) {
        btn.textContent = text;
      }
    });
  }

  let observing = false;

  // Der Glimmer-Header rendert bei manchen Aktionen neu -> Nav ggf. neu setzen.
  function watchHeader() {
    if (observing || !("MutationObserver" in window)) {
      return;
    }
    const header = document.querySelector(".d-header");
    if (!header) {
      return;
    }
    observing = true;
    new MutationObserver(() => {
      if (!document.querySelector(".d-header .contents .tk-nav")) {
        buildTopNav();
        relabelAuthButtons();
      }
    }).observe(header, { childList: true, subtree: true });
  }

  function apply() {
    schedule("afterRender", () => {
      try {
        setFlags();
        buildTopNav();
        relabelAuthButtons();
        watchHeader();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.warn("[tk-theme] chrome error", error);
      }
    });
  }

  api.onPageChange(apply);
  apply();
});

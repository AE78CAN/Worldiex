import React, { useEffect, useMemo, useState } from "react";

// === Fully Customisable Website Starter (Single-file React + Tailwind) ===
// - Theme + layout controlled by CONFIG (below) and live Editor Panel
// - Light/Dark mode, brand color palettes, font, radius, max width
// - Drag to reorder sections, toggle visibility, edit content inline
// - Import/Export JSON config, autosaves to localStorage
// - No external libs; uses Tailwind utility classes
// ----------------------------------------------------------------------

const DEFAULT_CONFIG = {
  site: {
    name: "Your Brand",
    tagline: "Do more. Stress less.",
    logoText: "YB",
    nav: [
      { label: "Home", href: "#home" },
      { label: "Features", href: "#features" },
      { label: "Posts", href: "#posts" },
      { label: "Contact", href: "#contact" },
    ],
    social: [
      { label: "X", href: "https://x.com/", icon: "x" },
      { label: "Facebook", href: "https://facebook.com/", icon: "facebook" },
      { label: "YouTube", href: "https://youtube.com/", icon: "youtube" },
    ],
  },
  theme: {
    mode: "light", // 'light' | 'dark'
    palette: "indigo", // indigo | emerald | rose | amber | sky | violet | slate
    radius: "2xl", // md | lg | xl | 2xl | 3xl
    font: "sans", // sans | serif | mono
    maxWidth: "7xl", // md | lg | xl | 2xl | 3xl | 4xl | 5xl | 6xl | 7xl
  },
  sections: [
    {
      id: "home",
      type: "hero",
      visible: true,
      props: {
        eyebrow: "NEW",
        title: "Build a site that bends to your brand",
        subtitle:
          "This starter lets you change colors, fonts, spacing, and content on the fly — then export it as JSON.",
        ctaPrimary: { label: "Get Started", href: "#features" },
        ctaSecondary: { label: "Contact", href: "#contact" },
        image:
          "https://images.unsplash.com/photo-1557093797-4d5e1f0c2b18?q=80&w=1600&auto=format&fit=crop",
      },
    },
    {
      id: "features",
      type: "features",
      visible: true,
      props: {
        heading: "Ridiculously customisable",
        copy:
          "Flip themes, swap palettes, tweak radius and typography — all without touching the code.",
        items: [
          {
            title: "Theme control",
            text: "Light/dark, brand palette, radius, font family, and layout width.",
          },
          {
            title: "Section builder",
            text: "Add, remove, reorder hero, features, posts, and contact blocks.",
          },
          {
            title: "One-file simplicity",
            text: "Everything lives here. Export your config, reuse anywhere.",
          },
        ],
      },
    },
    {
      id: "posts",
      type: "posts",
      visible: true,
      props: {
        heading: "Latest posts",
        copy: "Drop in your stories, announcements, or updates.",
        posts: [
          {
            title: "Launching our customisable starter",
            excerpt:
              "A clean, flexible scaffold you can morph into a portfolio, news site, or landing page.",
            date: "2025-08-19",
            href: "#",
          },
          {
            title: "Design tokens made easy",
            excerpt:
              "Pick a palette and radius — the UI updates instantly across components.",
            date: "2025-08-12",
            href: "#",
          },
          {
            title: "From config to production",
            excerpt:
              "Export JSON, commit it, and hydrate your real app with the same structure.",
            date: "2025-08-01",
            href: "#",
          },
        ],
      },
    },
    {
      id: "contact",
      type: "contact",
      visible: true,
      props: {
        heading: "Talk to us",
        copy:
          "Questions? Ideas? Send a message and we'll get back to you fast.",
        emailTo: "hello@example.com",
      },
    },
  ],
};

const palettes = {
  indigo: {
    ring: "ring-indigo-300",
    text: "text-indigo-600",
    bgSoft: "bg-indigo-50",
    bgStrong: "bg-indigo-600",
    hover: "hover:bg-indigo-700",
    border: "border-indigo-200",
  },
  emerald: {
    ring: "ring-emerald-300",
    text: "text-emerald-600",
    bgSoft: "bg-emerald-50",
    bgStrong: "bg-emerald-600",
    hover: "hover:bg-emerald-700",
    border: "border-emerald-200",
  },
  rose: {
    ring: "ring-rose-300",
    text: "text-rose-600",
    bgSoft: "bg-rose-50",
    bgStrong: "bg-rose-600",
    hover: "hover:bg-rose-700",
    border: "border-rose-200",
  },
  amber: {
    ring: "ring-amber-300",
    text: "text-amber-600",
    bgSoft: "bg-amber-50",
    bgStrong: "bg-amber-500",
    hover: "hover:bg-amber-600",
    border: "border-amber-200",
  },
  sky: {
    ring: "ring-sky-300",
    text: "text-sky-600",
    bgSoft: "bg-sky-50",
    bgStrong: "bg-sky-600",
    hover: "hover:bg-sky-700",
    border: "border-sky-200",
  },
  violet: {
    ring: "ring-violet-300",
    text: "text-violet-600",
    bgSoft: "bg-violet-50",
    bgStrong: "bg-violet-600",
    hover: "hover:bg-violet-700",
    border: "border-violet-200",
  },
  slate: {
    ring: "ring-slate-300",
    text: "text-slate-700",
    bgSoft: "bg-slate-100",
    bgStrong: "bg-slate-700",
    hover: "hover:bg-slate-800",
    border: "border-slate-200",
  },
};

const radiusMap = {
  md: "rounded-md",
  lg: "rounded-lg",
  xl: "rounded-xl",
  "2xl": "rounded-2xl",
  "3xl": "rounded-3xl",
};

const fontMap = {
  sans: "font-sans",
  serif: "font-serif",
  mono: "font-mono",
};

function useLocalConfig(key, initial) {
  const [cfg, setCfg] = useState(() => {
    try {
      const raw = localStorage.getItem(key);
      return raw ? JSON.parse(raw) : initial;
    } catch (e) {
      return initial;
    }
  });
  useEffect(() => {
    try {
      localStorage.setItem(key, JSON.stringify(cfg));
    } catch {}
  }, [key, cfg]);
  return [cfg, setCfg];
}

function classNames(...xs) {
  return xs.filter(Boolean).join(" ");
}

function Icon({ name, className }) {
  const common = "inline-block align-text-bottom";
  if (name === "x")
    return (
      <svg viewBox="0 0 24 24" className={classNames("w-5 h-5", common, className)}>
        <path
          fill="currentColor"
          d="M18.9 2H22l-9.6 11.1L22.8 22h-7l-5.5-6.5L3 22H.1l10.3-12L.6 2h7l5 5.9L18.9 2z"
        />
      </svg>
    );
  if (name === "facebook")
    return (
      <svg viewBox="0 0 24 24" className={classNames("w-5 h-5", common, className)}>
        <path fill="currentColor" d="M22 12a10 10 0 1 0-11.6 9.9V14.9H7.6V12h2.8V9.8c0-2.8 1.7-4.3 4.1-4.3 1.2 0 2.4.2 2.4.2v2.7h-1.4c-1.3 0-1.7.8-1.7 1.6V12h3l-.5 2.9h-2.5v7A10 10 0 0 0 22 12z" />
      </svg>
    );
  if (name === "youtube")
    return (
      <svg viewBox="0 0 24 24" className={classNames("w-5 h-5", common, className)}>
        <path fill="currentColor" d="M23.5 6.2a3 3 0 0 0-2.1-2.1C19.6 3.5 12 3.5 12 3.5s-7.6 0-9.4.6A3 3 0 0 0 .5 6.2 31.4 31.4 0 0 0 0 12a31.4 31.4 0 0 0 .5 5.8 3 3 0 0 0 2.1 2.1c1.8.6 9.4.6 9.4.6s7.6 0 9.4-.6a3 3 0 0 0 2.1-2.1A31.4 31.4 0 0 0 24 12a31.4 31.4 0 0 0-.5-5.8zM9.8 15.3V8.7L15.8 12l-6 3.3z" />
      </svg>
    );
  return null;
}

function Nav({ cfg, paletteClasses }) {
  return (
    <header className={classNames("sticky top-0 z-40 backdrop-blur border-b", palettes[cfg.theme.palette].border, cfg.theme.mode === "dark" ? "bg-black/30 border-white/10" : "bg-white/70")}
    >
      <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16", `max-w-${cfg.theme.maxWidth}`)}>
        <a href="#home" className="flex items-center gap-3">
          <div className={classNames("w-9 h-9 flex items-center justify-center text-white font-semibold", palettes[cfg.theme.palette].bgStrong, radiusMap[cfg.theme.radius])}>
            {cfg.site.logoText}
          </div>
          <div className="flex flex-col leading-tight">
            <span className="font-semibold">{cfg.site.name}</span>
            <span className="text-xs opacity-70">{cfg.site.tagline}</span>
          </div>
        </a>
        <nav className="hidden md:flex items-center gap-6">
          {cfg.site.nav.map((n) => (
            <a key={n.href} href={n.href} className="text-sm opacity-80 hover:opacity-100">
              {n.label}
            </a>
          ))}
        </nav>
        <div className="flex items-center gap-2">
          {cfg.site.social.map((s) => (
            <a key={s.label} href={s.href} className={classNames("p-2", palettes[cfg.theme.palette].text)} aria-label={s.label}>
              <Icon name={s.icon} />
            </a>
          ))}
        </div>
      </div>
    </header>
  );
}

function SectionHero({ cfg, props }) {
  return (
    <section id="home" className="relative overflow-hidden">
      <div className={classNames(palettes[cfg.theme.palette].bgSoft)}>
        <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28 text-center", `max-w-${cfg.theme.maxWidth}`)}>
          <div className="mx-auto max-w-3xl">
            <span className={classNames("inline-block text-xs font-semibold tracking-widest uppercase", palettes[cfg.theme.palette].text)}>
              {props.eyebrow}
            </span>
            <h1 className="mt-3 text-4xl md:text-6xl font-extrabold tracking-tight">
              {props.title}
            </h1>
            <p className="mt-4 text-lg opacity-80">{props.subtitle}</p>
            <div className="mt-8 flex items-center justify-center gap-3">
              <a
                href={props.ctaPrimary.href}
                className={classNames(
                  "px-5 py-3 inline-flex items-center justify-center text-white font-medium",
                  palettes[cfg.theme.palette].bgStrong,
                  palettes[cfg.theme.palette].hover,
                  "transition",
                  radiusMap[cfg.theme.radius]
                )}
              >
                {props.ctaPrimary.label}
              </a>
              <a
                href={props.ctaSecondary.href}
                className={classNames(
                  "px-5 py-3 inline-flex items-center justify-center font-medium border",
                  palettes[cfg.theme.palette].border,
                  radiusMap[cfg.theme.radius]
                )}
              >
                {props.ctaSecondary.label}
              </a>
            </div>
          </div>
          {props.image && (
            <div className="mt-12">
              <img src={props.image} alt="Hero" className={classNames("mx-auto w-full max-w-5xl object-cover", radiusMap[cfg.theme.radius])} />
            </div>
          )}
        </div>
      </div>
    </section>
  );
}

function SectionFeatures({ cfg, props }) {
  return (
    <section id="features" className="py-16 md:py-24">
      <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8", `max-w-${cfg.theme.maxWidth}`)}>
        <div className="max-w-2xl">
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight">{props.heading}</h2>
          <p className="mt-3 opacity-80">{props.copy}</p>
        </div>
        <div className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {props.items.map((it, i) => (
            <div key={i} className={classNames("p-6 border", palettes[cfg.theme.palette].border, radiusMap[cfg.theme.radius])}>
              <div className={classNames("w-9 h-9 flex items-center justify-center text-white", palettes[cfg.theme.palette].bgStrong, radiusMap[cfg.theme.radius])}>{i + 1}</div>
              <h3 className="mt-4 text-lg font-semibold">{it.title}</h3>
              <p className="mt-2 text-sm opacity-80">{it.text}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function SectionPosts({ cfg, props }) {
  return (
    <section id="posts" className="py-16 md:py-24">
      <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8", `max-w-${cfg.theme.maxWidth}`)}>
        <div className="max-w-2xl">
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight">{props.heading}</h2>
          <p className="mt-3 opacity-80">{props.copy}</p>
        </div>
        <div className="mt-10 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {props.posts.map((p, i) => (
            <article key={i} className={classNames("p-6 border flex flex-col", palettes[cfg.theme.palette].border, radiusMap[cfg.theme.radius])}>
              <time className={classNames("text-xs", palettes[cfg.theme.palette].text)}>{p.date}</time>
              <h3 className="mt-2 text-lg font-semibold">{p.title}</h3>
              <p className="mt-2 text-sm opacity-80 flex-1">{p.excerpt}</p>
              <a href={p.href} className={classNames("mt-4 text-sm font-medium", palettes[cfg.theme.palette].text)}>
                Read more →
              </a>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}

function SectionContact({ cfg, props }) {
  const [sent, setSent] = useState(false);
  function onSubmit(e) {
    e.preventDefault();
    setSent(true);
  }
  return (
    <section id="contact" className="py-16 md:py-24">
      <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8", `max-w-${cfg.theme.maxWidth}`)}>
        <div className="max-w-2xl">
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight">{props.heading}</h2>
          <p className="mt-3 opacity-80">{props.copy}</p>
        </div>
        <form onSubmit={onSubmit} className={classNames("mt-10 grid gap-4 p-6 border", palettes[cfg.theme.palette].border, radiusMap[cfg.theme.radius])}>
          <div className="grid gap-4 md:grid-cols-2">
            <input className="w-full p-3 border rounded-lg bg-transparent" placeholder="Your name" required />
            <input className="w-full p-3 border rounded-lg bg-transparent" placeholder="Email" type="email" required />
          </div>
          <textarea className="w-full p-3 border rounded-lg bg-transparent" placeholder="Message" rows={5} required />
          <button type="submit" className={classNames("px-5 py-3 text-white font-medium w-fit", palettes[cfg.theme.palette].bgStrong, palettes[cfg.theme.palette].hover, "transition", radiusMap[cfg.theme.radius])}>
            Send message
          </button>
          {sent && (
            <p className={classNames("text-sm", palettes[cfg.theme.palette].text)}>
              Thanks! We'll reply at {props.emailTo}.
            </p>
          )}
        </form>
      </div>
    </section>
  );
}

function renderSection(cfg, section) {
  if (!section.visible) return null;
  const C = {
    hero: SectionHero,
    features: SectionFeatures,
    posts: SectionPosts,
    contact: SectionContact,
  }[section.type];
  if (!C) return null;
  return <C key={section.id} cfg={cfg} props={section.props} />;
}

function Editor({ cfg, setCfg }) {
  const pal = palettes[cfg.theme.palette];

  function update(path, value) {
    setCfg((prev) => {
      const next = structuredClone(prev);
      const keys = path.split(".");
      let o = next;
      for (let i = 0; i < keys.length - 1; i++) o = o[keys[i]];
      o[keys.at(-1)] = value;
      return next;
    });
  }

  function moveSection(idx, dir) {
    setCfg((prev) => {
      const next = structuredClone(prev);
      const arr = next.sections;
      const target = idx + dir;
      if (target < 0 || target >= arr.length) return prev;
      [arr[idx], arr[target]] = [arr[target], arr[idx]];
      return next;
    });
  }

  function addSection(type) {
    const id = `${type}-${Math.random().toString(36).slice(2, 8)}`;
    const base = {
      hero: {
        eyebrow: "HELLO",
        title: "A fresh hero section",
        subtitle: "Swap this text with your own.",
        ctaPrimary: { label: "Learn more", href: "#" },
        ctaSecondary: { label: "Contact", href: "#contact" },
        image: "",
      },
      features: {
        heading: "New features block",
        copy: "Add or remove items as needed.",
        items: [
          { title: "Item one", text: "Short description." },
          { title: "Item two", text: "Short description." },
          { title: "Item three", text: "Short description." },
        ],
      },
      posts: { heading: "Posts", copy: "What's new.", posts: [] },
      contact: {
        heading: "Contact us",
        copy: "We usually reply within a day.",
        emailTo: "hello@example.com",
      },
    }[type];

    setCfg((prev) => ({
      ...prev,
      sections: [...prev.sections, { id, type, visible: true, props: base }],
    }));
  }

  function exportJSON() {
    const data = JSON.stringify(cfg, null, 2);
    const blob = new Blob([data], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `${cfg.site.name.replace(/\s+/g, "-").toLowerCase()}-config.json`;
    a.click();
    URL.revokeObjectURL(url);
  }

  function importJSON() {
    const input = document.createElement("input");
    input.type = "file";
    input.accept = "application/json";
    input.onchange = () => {
      const file = input.files?.[0];
      if (!file) return;
      const reader = new FileReader();
      reader.onload = () => {
        try {
          const next = JSON.parse(String(reader.result));
          setCfg(next);
        } catch (e) {
          alert("Invalid JSON");
        }
      };
      reader.readAsText(file);
    };
    input.click();
  }

  return (
    <aside
      className={classNames(
        "fixed right-3 md:right-6 bottom-3 md:bottom-6 z-50",
        "w-[min(92vw,380px)]",
        "shadow-2xl border backdrop-blur",
        cfg.theme.mode === "dark" ? "bg-black/60 border-white/10" : "bg-white/80 border-black/10",
        "p-4 rounded-2xl"
      )}
    >
      <div className="flex items-center justify-between gap-2">
        <strong className="text-sm">Editor Panel</strong>
        <div className="flex items-center gap-2">
          <button
            onClick={() => update("theme.mode", cfg.theme.mode === "dark" ? "light" : "dark")}
            className={classNames("text-xs px-2 py-1 border rounded", palettes[cfg.theme.palette].border)}
          >
            {cfg.theme.mode === "dark" ? "Light" : "Dark"}
          </button>
          <button onClick={exportJSON} className={classNames("text-xs px-2 py-1 border rounded", palettes[cfg.theme.palette].border)}>
            Export
          </button>
          <button onClick={importJSON} className={classNames("text-xs px-2 py-1 border rounded", palettes[cfg.theme.palette].border)}>
            Import
          </button>
        </div>
      </div>

      <div className="mt-3 grid gap-3 text-sm">
        <label className="grid gap-1">
          <span className="opacity-70">Site name</span>
          <input value={cfg.site.name} onChange={(e) => update("site.name", e.target.value)} className="p-2 border rounded" />
        </label>
        <label className="grid gap-1">
          <span className="opacity-70">Tagline</span>
          <input value={cfg.site.tagline} onChange={(e) => update("site.tagline", e.target.value)} className="p-2 border rounded" />
        </label>
        <label className="grid gap-1">
          <span className="opacity-70">Palette</span>
          <select value={cfg.theme.palette} onChange={(e) => update("theme.palette", e.target.value)} className="p-2 border rounded">
            {Object.keys(palettes).map((k) => (
              <option key={k} value={k}>
                {k}
              </option>
            ))}
          </select>
        </label>
        <label className="grid gap-1">
          <span className="opacity-70">Font</span>
          <select value={cfg.theme.font} onChange={(e) => update("theme.font", e.target.value)} className="p-2 border rounded">
            {Object.keys(fontMap).map((k) => (
              <option key={k} value={k}>
                {k}
              </option>
            ))}
          </select>
        </label>
        <label className="grid gap-1">
          <span className="opacity-70">Radius</span>
          <select value={cfg.theme.radius} onChange={(e) => update("theme.radius", e.target.value)} className="p-2 border rounded">
            {Object.keys(radiusMap).map((k) => (
              <option key={k} value={k}>
                {k}
              </option>
            ))}
          </select>
        </label>
        <label className="grid gap-1">
          <span className="opacity-70">Max width</span>
          <select value={cfg.theme.maxWidth} onChange={(e) => update("theme.maxWidth", e.target.value)} className="p-2 border rounded">
            {["md","lg","xl","2xl","3xl","4xl","5xl","6xl","7xl"].map((k) => (
              <option key={k} value={k}>
                {k}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="mt-4 border-t pt-3">
        <div className="flex items-center justify-between">
          <strong className="text-sm">Sections</strong>
          <div className="flex gap-2">
            {(["hero","features","posts","contact"]).map((t) => (
              <button key={t} onClick={() => addSection(t)} className={classNames("text-xs px-2 py-1 border rounded", palettes[cfg.theme.palette].border)}>
                + {t}
              </button>
            ))}
          </div>
        </div>
        <div className="mt-2 grid gap-2 max-h-56 overflow-auto pr-1">
          {cfg.sections.map((s, idx) => (
            <div key={s.id} className={classNames("p-2 border flex items-center justify-between gap-2", palettes[cfg.theme.palette].border, radiusMap[cfg.theme.radius])}>
              <div className="min-w-0">
                <div className="text-sm font-medium truncate">{s.type}</div>
                <div className="text-xs opacity-60 truncate">id: {s.id}</div>
              </div>
              <div className="flex items-center gap-1">
                <button onClick={() => moveSection(idx, -1)} className="text-xs px-2 py-1 border rounded">↑</button>
                <button onClick={() => moveSection(idx, 1)} className="text-xs px-2 py-1 border rounded">↓</button>
                <button onClick={() => update(`sections.${idx}.visible`, !s.visible)} className="text-xs px-2 py-1 border rounded">
                  {s.visible ? "Hide" : "Show"}
                </button>
                <button
                  onClick={() =>
                    setCfg((prev) => ({
                      ...prev,
                      sections: prev.sections.filter((_, i) => i !== idx),
                    }))
                  }
                  className="text-xs px-2 py-1 border rounded"
                >
                  Del
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </aside>
  );
}

export default function CustomSite() {
  const [cfg, setCfg] = useLocalConfig("customisable-site-config", DEFAULT_CONFIG);
  const fontClass = fontMap[cfg.theme.font];

  useEffect(() => {
    // Sync dark mode to document
    if (cfg.theme.mode === "dark") {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  }, [cfg.theme.mode]);

  return (
    <div className={classNames("min-h-screen", fontClass, cfg.theme.mode === "dark" ? "bg-neutral-950 text-white" : "bg-white text-black")}
    >
      <Nav cfg={cfg} />
      <main>
        {cfg.sections.map((s) => renderSection(cfg, s))}
      </main>
      <footer className="py-10 border-t mt-10 opacity-80">
        <div className={classNames("mx-auto px-4 sm:px-6 lg:px-8 text-sm", `max-w-${cfg.theme.maxWidth}`)}>
          © {new Date().getFullYear()} {cfg.site.name}. All rights reserved.
        </div>
      </footer>

      <Editor cfg={cfg} setCfg={setCfg} />
    </div>
  );
}

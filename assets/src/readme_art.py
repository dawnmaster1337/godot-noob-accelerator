#!/usr/bin/env python3
"""Draws the README's graphics, each in a light and a dark version.

Run through make_art.py (python3 assets/src/make_art.py), or on its own. It writes
assets/readme/<name>.svg and <name>-dark.svg; the README picks one with <picture>.

The rules these follow (docs/plans/ review, 2026-11-14):
- Words are text. A graphic illustrates; the page carries every fact as text too.
- Readable on a phone. Canvases are narrow and type is large, so nothing a reader needs is
  under about 11 px when GitHub shrinks the image to a 360 px screen.
- Two themes, one drawing: only the Theme changes between the light and dark files.
"""
from __future__ import annotations

import os
import textwrap
from html import escape

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT = "assets/readme"

FONT = "'Segoe UI', 'Helvetica Neue', Helvetica, Arial, 'Liberation Sans', sans-serif"
MONO = "'JetBrains Mono', 'Cascadia Code', Menlo, Consolas, 'Liberation Mono', monospace"

# Accents are the same in both themes; ON is the text colour that reads on each.
ORANGE = "#D97757"
BLUE = "#5FA3D6"
YELLOW = "#F5C24C"
GREEN = "#5CC8A8"
PINK = "#EE7FA0"
PURPLE = "#8E7CC3"
NAVY = "#1E2A44"
ON = {BLUE: "#0E2C44", YELLOW: "#4A3300", GREEN: "#123B33", PINK: "#4A1024", PURPLE: "#FFFFFF",
      ORANGE: "#FFFFFF"}


class Theme:
    def __init__(self, **kw):
        self.__dict__.update(kw)


LIGHT = Theme(
    suffix="", panel="#FFF7EC", edge="#F0E2CA", well="#EAF4FB", card="#FFFFFF", card_edge="#E9DDC8",
    ink="#1E2A44", soft="#55627F", wire="#1E2A44", outline="#1E2A44", bar="#1E2A44",
    bar_text="#FFF7EC", sky=("#FFF4E2", "#E4F1FB", "#CFE6F7"), shadow="#1E2A44", shadow_op="0.12",
    road="#DDD0BA",
)
DARK = Theme(
    suffix="-dark", panel="#151B26", edge="#2B3547", well="#101622", card="#1F2735",
    card_edge="#35415A", ink="#EEF2F8", soft="#A9B5C9", wire="#93A4BF", outline="#0A0E15",
    bar="#0A0E15", bar_text="#C9D3E3", sky=("#1C2437", "#161D2C", "#111826"), shadow="#000000",
    shadow_op="0.35", road="#34405A",
)

ICONS = {
    "notebook": '<rect x="12" y="6" width="40" height="52" rx="6"/><path d="M20 6 v52 M28 20 h16 M28 30 h16 M28 40 h10"/>',
    "shield": '<path d="M32 6 l22 8 v16 c0 14 -10 24 -22 28 c-12 -4 -22 -14 -22 -28 v-16z"/><path d="M22 32 l7 7 l13 -14"/>',
    "sliders": '<path d="M10 22 h44 M10 42 h44"/><circle cx="24" cy="22" r="7"/><circle cx="40" cy="42" r="7"/>',
    "magnify": '<circle cx="26" cy="26" r="16"/><path d="M38 38 l16 16"/>',
    "hammer": '<path d="M8 18 l16 -10 l10 10 l-6 6 l22 26 l-6 6 l-26 -22 l-4 4z"/>',
}


def wrap(s: str, width: float, size: float, bold: bool = False, mono: bool = False) -> list[str]:
    """Lines of s that fit width px at size px (an estimate of the average glyph width)."""
    per = size * (0.6 if mono else 0.57 if bold else 0.5)
    lines: list[str] = []
    for para in s.split("\n"):
        lines += textwrap.wrap(para, max(4, int(width / per))) or [""]
    return lines


class Art:
    """One graphic in one theme: collects SVG and writes the file."""

    def __init__(self, theme: Theme):
        self.t = theme
        self.body: list[str] = []
        self.defs: list[str] = []
        self.style = ""

    def add(self, s: str) -> None:
        self.body.append(s)

    def text(self, x, y, s, size=26, bold=False, fill=None, anchor="start", mono=False, extra=""):
        weight = ' font-weight="700"' if bold else ""
        fam = f' font-family="{MONO}"' if mono else ""
        self.add(f'<text x="{round(x)}" y="{round(y)}" font-size="{size}"{weight}{fam} '
                 f'fill="{fill or self.t.ink}" text-anchor="{anchor}"{extra}>{escape(s)}</text>')

    def para(self, x, y, s, width, size=26, bold=False, fill=None, lh=1.38, anchor="start") -> float:
        """Wrapped text from baseline y; returns the height used."""
        lines = wrap(s, width, size, bold)
        for i, ln in enumerate(lines):
            self.text(x, y + i * size * lh, ln, size, bold, fill, anchor)
        return len(lines) * size * lh

    def rect(self, x, y, w, h, r=20, fill=None, stroke=None, sw=3, extra=""):
        st = f' stroke="{stroke}" stroke-width="{sw}"' if stroke else ""
        self.add(f'<rect x="{round(x)}" y="{round(y)}" width="{round(w)}" height="{round(h)}" '
                 f'rx="{r}" fill="{fill or self.t.card}"{st}{extra}/>')

    def card(self, x, y, w, h, r=22, edge=None, sw=3):
        self.rect(x, y, w, h, r, self.t.card, edge or self.t.card_edge, sw)

    def circle(self, cx, cy, r, fill, stroke=None, sw=4):
        st = f' stroke="{stroke}" stroke-width="{sw}"' if stroke else ""
        self.add(f'<circle cx="{round(cx)}" cy="{round(cy)}" r="{r}" fill="{fill}"{st}/>')

    def arrow(self, x1, y1, x2, y2, sw=5):
        self.add(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{self.t.soft}" '
                 f'stroke-width="{sw}" stroke-linecap="round" marker-end="url(#head)"/>')

    def icon(self, name, x, y, color=None, s=1.0):
        self.add(f'<g transform="translate({x} {y}) scale({s})" fill="none" stroke="{color or self.t.ink}" '
                 f'stroke-width="4" stroke-linecap="round" stroke-linejoin="round">{ICONS[name]}</g>')

    def pip_head(self, x, y, s=1.0):
        """Pip, head only: 160x130 at s=1, top-left at (x, y)."""
        t = self.t
        self.add(f'''<g transform="translate({x} {y}) scale({s})">
  <line x1="80" y1="6" x2="80" y2="28" stroke="{t.wire}" stroke-width="6" stroke-linecap="round"/>
  <circle cx="80" cy="10" r="11" fill="{ORANGE}"/>
  <rect x="10" y="26" width="140" height="104" rx="42" fill="{BLUE}" stroke="{t.outline}" stroke-width="6"/>
  <rect x="30" y="44" width="100" height="68" rx="28" fill="#FFF8EE"/>
  <ellipse cx="60" cy="74" rx="10" ry="13" fill="{NAVY}"/><ellipse cx="100" cy="74" rx="10" ry="13" fill="{NAVY}"/>
  <circle cx="63" cy="69" r="3.5" fill="#FFF"/><circle cx="103" cy="69" r="3.5" fill="#FFF"/>
  <path d="M62 92 q18 15 36 0" fill="none" stroke="{NAVY}" stroke-width="6" stroke-linecap="round"/>
  <circle cx="40" cy="92" r="7" fill="{PINK}" opacity=".7"/><circle cx="120" cy="92" r="7" fill="{PINK}" opacity=".7"/>
</g>''')

    def pip_full(self, x, y, s=1.0):
        """Pip with a body and a game controller: 240x330 at s=1, top-left at (x, y)."""
        t = self.t
        self.defs.append(f'<linearGradient id="pipbody" x1="0" y1="0" x2="0" y2="1">'
                         f'<stop offset="0" stop-color="#6BB0E2"/><stop offset="1" stop-color="#478CBF"/>'
                         f'</linearGradient>')
        self.add(f'''<g transform="translate({x} {y}) scale({s})">
  <ellipse cx="120" cy="311" rx="118" ry="15" fill="{t.shadow}" opacity="{t.shadow_op}"/>
  <g class="bob">
    <line x1="120" y1="23" x2="120" y2="57" stroke="{t.wire}" stroke-width="7" stroke-linecap="round"/>
    <circle cx="120" cy="15" r="15" fill="{ORANGE}"/><circle cx="115" cy="10" r="5" fill="#FFD1BF"/>
    <rect x="10" y="55" width="220" height="150" rx="58" fill="url(#pipbody)" stroke="{t.outline}" stroke-width="7"/>
    <rect x="38" y="81" width="164" height="96" rx="40" fill="#FFF8EE"/>
    <g class="blink">
      <ellipse cx="86" cy="125" rx="15" ry="19" fill="{NAVY}"/><ellipse cx="154" cy="125" rx="15" ry="19" fill="{NAVY}"/>
      <circle cx="91" cy="118" r="5" fill="#FFF"/><circle cx="159" cy="118" r="5" fill="#FFF"/>
    </g>
    <path d="M98 155 q22 18 44 0" fill="none" stroke="{NAVY}" stroke-width="6" stroke-linecap="round"/>
    <circle cx="60" cy="151" r="9" fill="{PINK}" opacity=".7"/><circle cx="180" cy="151" r="9" fill="{PINK}" opacity=".7"/>
    <rect x="44" y="201" width="152" height="86" rx="30" fill="url(#pipbody)" stroke="{t.outline}" stroke-width="7"/>
    <rect x="54" y="217" width="132" height="58" rx="26" fill="{NAVY}"/>
    <rect x="74" y="238" width="26" height="9" rx="3" fill="#FFF4E2"/><rect x="82" y="230" width="9" height="26" rx="3" fill="#FFF4E2"/>
    <circle cx="150" cy="235" r="7" fill="{YELLOW}"/><circle cx="166" cy="249" r="7" fill="{GREEN}"/><circle cx="150" cy="261" r="7" fill="{PINK}"/>
    <path d="M44 229 q-30 4 -26 34" fill="none" stroke="{t.wire}" stroke-width="7" stroke-linecap="round"/>
    <path d="M196 229 q30 4 26 34" fill="none" stroke="{t.wire}" stroke-width="7" stroke-linecap="round"/>
  </g>
</g>''')

    def save(self, name, w, h, title, desc, panel=True, fill=None):
        t = self.t
        defs = (f'<marker id="head" viewBox="0 0 10 10" refX="7" refY="5" markerWidth="5" markerHeight="5" '
                f'orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10z" fill="{t.soft}"/></marker>'
                + "".join(self.defs))
        back = ""
        if panel:
            back = (f'<rect x="1.5" y="1.5" width="{w - 3}" height="{h - 3}" rx="28" '
                    f'fill="{fill or t.panel}" stroke="{t.edge}" stroke-width="3"/>\n')
        style = f"<style>{self.style}</style>\n" if self.style else ""
        doc = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}" '
               f'role="img" aria-labelledby="t d">\n<title id="t">{escape(title)}</title>\n'
               f'<desc id="d">{escape(desc)}</desc>\n{style}<defs>{defs}</defs>\n'
               f'<g font-family="{FONT}">\n{back}' + "\n".join(self.body) + "\n</g>\n</svg>\n")
        path = os.path.join(ROOT, OUT, f"{name}{t.suffix}.svg")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            f.write(doc)
        print(f"wrote {OUT}/{name}{t.suffix}.svg ({w}x{h})")


# ---------- the graphics ----------

MOTION = (
    ".bob{animation:bob 3.2s ease-in-out infinite}"
    ".tw1{animation:tw 2.4s ease-in-out infinite}.tw2{animation:tw 2.4s ease-in-out .8s infinite}"
    ".tw3{animation:tw 2.4s ease-in-out 1.6s infinite}"
    ".blink{animation:blink 5s infinite;transform-origin:0 125px}"
    "@keyframes bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-10px)}}"
    "@keyframes tw{0%,100%{opacity:.3}50%{opacity:1}}"
    "@keyframes blink{0%,94%,100%{transform:scaleY(1)}97%{transform:scaleY(.1)}}"
    "@media (prefers-reduced-motion:reduce){.bob,.tw1,.tw2,.tw3,.blink{animation:none}}"
)


def hero(t: Theme):
    a = Art(t)
    w, h = 1280, 440
    a.style = MOTION
    a.defs.append(f'<linearGradient id="sky" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="{t.sky[0]}"/>'
                  f'<stop offset=".55" stop-color="{t.sky[1]}"/><stop offset="1" stop-color="{t.sky[2]}"/></linearGradient>')
    a.add(f'<rect x="1.5" y="1.5" width="{w - 3}" height="{h - 3}" rx="36" fill="url(#sky)" stroke="{t.edge}" stroke-width="3"/>')
    # floating bits: blocks, stars, a coin
    a.add(f'<g class="tw1"><rect x="790" y="64" width="26" height="26" rx="5" fill="{YELLOW}"/>'
          f'<rect x="816" y="64" width="26" height="26" rx="5" fill="#F2B33D"/></g>')
    a.add(f'<g class="tw2"><path d="M1202 84 l9 20 22 3 -16 15 4 22 -19 -11 -19 11 4 -22 -16 -15 22 -3z" fill="{PINK}"/></g>')
    a.add(f'<g class="tw3"><circle cx="1196" cy="360" r="16" fill="{YELLOW}" stroke="#E09B2D" stroke-width="5"/></g>')
    a.add(f'<g class="tw2"><path d="M856 352 l6 13 14 2 -10 10 3 14 -13 -7 -13 7 3 -14 -10 -10 14 -2z" fill="{GREEN}"/></g>')
    a.add(f'<g class="tw1"><rect x="1232" y="226" width="18" height="18" rx="4" fill="{ORANGE}"/></g>')
    # title: every word here is large enough to read on a phone
    a.rect(72, 52, 424, 48, 24, t.bar)
    a.text(284, 85, "CLAUDE CODE × GODOT 4", 24, True, t.bar_text, "middle", extra=' letter-spacing="2"')
    a.text(70, 196, "Godot Noob", 88, True)
    a.text(70, 290, "Accelerator", 88, True, ORANGE)
    a.text(72, 352, "Make a Godot game with Claude Code,", 40, False, t.soft)
    a.text(72, 402, "without the mess.", 40, False, t.soft)
    a.pip_full(940, 66, 1.0)
    a.save("hero", w, h, "Godot Noob Accelerator",
           "Pip, a friendly round robot holding a game controller, beside the title: Godot Noob "
           "Accelerator. Make a Godot game with Claude Code, without the mess.", panel=False)


def button(name, fill, small, big):
    """A call-to-action button. One file serves both themes: it carries its own colours."""
    a = Art(LIGHT)
    w, h = 520, 104
    a.rect(4, 10, w - 8, h - 14, 28, NAVY)
    a.rect(4, 4, w - 8, h - 14, 28, fill, NAVY, 4)
    a.text(34, 42, small, 21, True, ON[fill])
    a.text(34, 76, big, 28, True, ON[fill])
    a.circle(w - 56, 49, 25, NAVY)
    a.add(f'<path d="M{w - 67} 49 h20 M{w - 55} 40 l9 9 l-9 9" fill="none" stroke="#FFFFFF" stroke-width="4" '
          f'stroke-linecap="round" stroke-linejoin="round"/>')
    a.save(name, w, h, big, f"{small} {big}", panel=False)


def promises(t: Theme):
    a = Art(t)
    w, h = 880, 280
    cols = [(152, BLUE, "notebook", "It remembers", "where you stopped"),
            (440, GREEN, "shield", "It checks first", "before you see it"),
            (728, YELLOW, "sliders", "It asks first", "before it saves")]
    for cx, col, ic, title, sub in cols:
        a.circle(cx, 92, 58, col)
        a.icon(ic, cx - 37, 55, NAVY, 1.16)
        a.text(cx, 200, title, 38, True, anchor="middle")
        a.text(cx, 242, sub, 28, False, t.soft, "middle")
    a.save("promises", w, h, "Three habits the kit adds",
           "Three icons with labels. It remembers where you stopped. It checks first, before you "
           "see it. It asks first, before it saves.")


def session(t: Theme):
    """An illustrated session, drawn like a chat on a phone so it reads at any width."""
    a = Art(t)
    w = 760
    turns = [
        ("resume", ["Got 2 changes from your laptop.",
                    "Next up: the wall jump. One question:",
                    "should it push you off the wall?",
                    "1. Yes, a little (recommended)",
                    "2. Straight up"], None),
        ("APR", ["To try: open player.tscn, press F5 and jump at a wall twice."],
         "Built it. Checks: 4 passed, 0 failed."),
        ("feels floaty", ["That's a setting, not code.",
                          "I changed wall_jump_push from 220 to 160.",
                          "Try it again?"], None),
        ("better. save work", ["Commit \"Add the wall jump\"?", "Nothing is saved until you say yes."], None),
    ]
    size, lh, bw, bx = 26, 36, 590, 112
    y = 96
    for you, paras, lead in turns:
        pw = len(you) * 28 * 0.6 + 56
        a.rect(w - 36 - pw, y, pw, 60, 30, ORANGE)
        a.text(w - 36 - pw / 2, y + 40, you, 28, True, "#FFFFFF", "middle", mono=True)
        y += 60 + 18
        lines: list[tuple[str, bool]] = [(lead, True)] if lead else []
        for p in paras:
            lines += [(ln, False) for ln in wrap(p, bw - 52, size)]
        bh = 40 + len(lines) * lh
        a.pip_head(22, y - 2, 0.5)
        a.card(bx, y, bw, bh, 24)
        for i, (ln, bold) in enumerate(lines):
            a.text(bx + 26, y + 48 + i * lh, ln, size, bold)
        y += bh + 24
    h = y + 16
    # the window frame goes behind everything drawn so far
    frame = Art(t)
    frame.rect(1.5, 1.5, w - 3, h - 3, 28, t.well, t.edge, 3)
    frame.add(f'<path d="M1.5 30 a28 28 0 0 1 28 -28 h{w - 59} a28 28 0 0 1 28 28 v40 h-{w - 3}z" fill="{t.bar}"/>')
    frame.circle(40, 36, 9, PINK)
    frame.circle(68, 36, 9, YELLOW)
    frame.circle(96, 36, 9, GREEN)
    frame.text(w / 2, 45, "claude  ·  your-game", 22, True, t.bar_text, "middle", mono=True)
    a.body = frame.body + a.body
    a.save("session", w, h, "What a session looks like",
           "An illustrated chat. You type resume; Claude says it got two changes from your laptop, "
           "names the next task and asks one question with a recommended answer. You type APR; it "
           "builds it and reports 4 checks passed and what to try. You say it feels floaty; it "
           "changes one setting, not code. You say save work; it asks before committing.", panel=False)


def loop(t: Theme):
    a = Art(t)
    w, h = 880, 456
    xs, y1, y2 = [160, 440, 720], 84, 300
    # the road turns well clear of the labels under stops 3 and 4
    road = (f"M{xs[0]} {y1} H{xs[2] + 78} a40 40 0 0 1 40 40 V{y2 - 40} a40 40 0 0 1 -40 40 H{xs[0]}")
    a.add(f'<path d="{road}" fill="none" stroke="{t.road}" stroke-width="18" stroke-linecap="round"/>')
    a.add(f'<path d="{road}" fill="none" stroke="{t.panel}" stroke-width="3" stroke-dasharray="14 12"/>')
    stops = [(xs[0], y1, BLUE, "resume", "where you stopped"),
             (xs[1], y1, YELLOW, "one task", "one small job"),
             (xs[2], y1, PURPLE, "plan it", "your OK first"),
             (xs[2], y2, GREEN, "build + check", "checks run first"),
             (xs[1], y2, PINK, "you play it", "say how it feels"),
             (xs[0], y2, ORANGE, "save work", "only on your yes")]
    for i, (x, y, col, title, sub) in enumerate(stops):
        a.circle(x, y, 38, col, t.outline, 4)
        a.text(x, y + 12, str(i + 1), 34, True, ON[col], "middle")
        a.text(x, y + 80, title, 31, True, anchor="middle")
        a.text(x, y + 114, sub, 25, False, t.soft, "middle")
    a.save("loop", w, h, "How a session goes",
           "A loop of six steps: resume, one task, plan it, build and check, you play it, save "
           "work. Then a fresh session starts the loop again.")


def find_or_build(t: Theme):
    a = Art(t)
    w, h = 880, 452
    a.rect(40, 50, 296, 68, 34, ORANGE)
    a.text(188, 95, "\"I need some trees\"", 27, True, "#FFFFFF", "middle")
    a.arrow(346, 84, 376, 84)
    a.pip_head(382, 24, 0.72)
    a.card(508, 30, 332, 108, 24, t.ink, 4)
    a.text(674, 76, "Find a ready-made one,", 26, True, anchor="middle")
    a.text(674, 112, "or build it here?", 26, True, anchor="middle")
    a.text(440, 188, "It recommends neither. You pick:", 27, False, t.soft, "middle")
    for x, col, ic, title, body in [
        (40, BLUE, "magnify", "Find", "Up to five free options, each with its licence."),
        (460, GREEN, "hammer", "Build", "Claude makes it in your project."),
    ]:
        a.card(x, 216, 380, 196, 24, col, 4)
        a.circle(x + 58, 272, 34, col)
        a.icon(ic, x + 34, 248, NAVY, 0.75)
        a.text(x + 108, 284, title, 34, True)
        a.para(x + 28, 346, body, 330, 27)
    a.save("find-or-build", w, h, "Find or build: your call",
           "You ask for some trees. Pip, the kit's robot, asks: find a ready-made one, or build it "
           "here? It recommends neither. Find shows up to five free options, each with its licence. "
           "Build makes it in your project.")


def main():
    for t in (LIGHT, DARK):
        hero(t)
        promises(t)
        session(t)
        loop(t)
        find_or_build(t)
    button("btn-beginner", YELLOW, "New to all of this?", "Start the beginner's guide")
    button("btn-quickstart", BLUE, "Already use Claude Code?", "5-minute quick start")


if __name__ == "__main__":
    main()

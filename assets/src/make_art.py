#!/usr/bin/env python3
"""Draws every graphic in the README and the docs as SVG.

Run from anywhere: python3 assets/src/make_art.py. It rewrites the docs graphics below (listed in
ART at the bottom), then the README's, which live in readme_art.py and come in a light and a
dark version each. Never edit the SVGs by hand: change the words or the layout here.

The docs graphics: 1280 wide, body text at least 24 px, their words also on the page as text;
green is the kit's way, pink the problem, yellow a choice that's yours.
"""
from __future__ import annotations

import os
import textwrap
from html import escape

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))

INK = "#1E2A44"
SOFT = "#4A5878"
ORANGE = "#D97757"
BLUE = "#5FA3D6"
YELLOW = "#F5C24C"
GREEN = "#5CC8A8"
PINK = "#EE7FA0"
PURPLE = "#8E7CC3"
CREAM = "#FFF7EC"
SKY = "#EAF4FB"
WHITE = "#FFFFFF"
LINE = "#E6DCCB"
# Text colours that read on each fill.
ON = {BLUE: "#0E2C44", YELLOW: "#4A3300", GREEN: "#123B33", PINK: "#4A1024", PURPLE: "#241A44",
      ORANGE: "#3D1708", INK: CREAM}

FONT = "'Segoe UI', 'Helvetica Neue', Helvetica, Arial, 'Liberation Sans', sans-serif"
MONO = "'JetBrains Mono', 'Cascadia Code', Menlo, Consolas, 'Liberation Mono', monospace"


# ---------- primitives ----------

def wrap(s: str, width: float, size: float, bold: bool = False) -> list[str]:
    """Lines of s that fit width px at size px (an estimate of the average glyph width)."""
    per = size * (0.57 if bold else 0.5)
    lines: list[str] = []
    for para in s.split("\n"):
        lines += textwrap.wrap(para, max(4, int(width / per))) or [""]
    return lines


def text(x, y, s, size=24, bold=False, fill=INK, anchor="start", mono=False, extra=""):
    weight = ' font-weight="700"' if bold else ""
    fam = f' font-family="{MONO}"' if mono else ""
    return (f'<text x="{x}" y="{y}" font-size="{size}"{weight}{fam} fill="{fill}" '
            f'text-anchor="{anchor}"{extra}>{escape(s)}</text>')


def para(x, y, s, width, size=24, bold=False, fill=INK, lh=1.38, anchor="start", mono=False):
    """Wrapped text from baseline y; returns (svg, height used)."""
    out = []
    lines = wrap(s, width, size, bold)
    for i, ln in enumerate(lines):
        out.append(text(x, round(y + i * size * lh), ln, size, bold, fill, anchor, mono))
    return "\n".join(out), len(lines) * size * lh


def vpara(x, cy, s, width, size=24, bold=False, fill=INK, lh=1.38, anchor="start", mono=False):
    """Wrapped text centred vertically on cy."""
    n = len(wrap(s, width, size, bold))
    top = cy - (n * size * lh) / 2 + size * 0.85
    return para(x, top, s, width, size, bold, fill, lh, anchor, mono)[0]


def rect(x, y, w, h, r=20, fill=WHITE, stroke=None, sw=3, extra=""):
    st = f' stroke="{stroke}" stroke-width="{sw}"' if stroke else ""
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}"{st}{extra}/>'


def pill(x, y, s, size=22, fill=GREEN, color=None, anchor="start", pad=18):
    """A rounded label; x is its left edge (anchor start) or centre (anchor middle)."""
    w = len(s) * size * 0.6 + pad * 2
    h = size * 1.75
    left = x - w / 2 if anchor == "middle" else x
    return (rect(round(left), y, round(w), round(h), r=round(h / 2), fill=fill)
            + text(round(left + w / 2), round(y + h * 0.68), s, size, True, color or ON.get(fill, INK),
                   "middle")), w


def badge(cx, cy, r, fill, label, size=None):
    size = size or round(r * 1.1)
    return (f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}" stroke="{INK}" stroke-width="4"/>'
            + text(cx, round(cy + size * 0.36), label, size, True, ON.get(fill, INK), "middle"))


def tick(cx, cy, r=18, fill=GREEN):
    return (f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}"/>'
            f'<path d="M{cx - r * .45} {cy} l{r * .32} {r * .34} l{r * .6} {-r * .66}" fill="none" '
            f'stroke="{WHITE}" stroke-width="{max(3, r // 5)}" stroke-linecap="round" stroke-linejoin="round"/>')


def cross(cx, cy, r=18, fill=PINK):
    d = r * .38
    return (f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fill}"/>'
            f'<path d="M{cx - d} {cy - d} L{cx + d} {cy + d} M{cx + d} {cy - d} L{cx - d} {cy + d}" '
            f'stroke="{WHITE}" stroke-width="{max(3, r // 5)}" stroke-linecap="round"/>')


def arrow(x1, y1, x2, y2, color=SOFT, sw=4, dash=False):
    d = ' stroke-dasharray="10 9"' if dash else ""
    return (f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="{sw}" '
            f'stroke-linecap="round"{d} marker-end="url(#head)"/>')


def pip(x, y, s=1.0, mood="smile"):
    """Pip, the kit's robot, head and shoulders; (x, y) is the top-left, 160x150 at s=1."""
    mouth = ('<path d="M62 92 q18 15 36 0" fill="none" stroke="#1E2A44" stroke-width="6" '
             'stroke-linecap="round"/>') if mood == "smile" else \
        '<ellipse cx="80" cy="96" rx="9" ry="7" fill="#1E2A44"/>'
    return f'''<g transform="translate({x} {y}) scale({s})">
  <line x1="80" y1="6" x2="80" y2="28" stroke="{INK}" stroke-width="6" stroke-linecap="round"/>
  <circle cx="80" cy="8" r="11" fill="{ORANGE}"/>
  <rect x="10" y="26" width="140" height="104" rx="42" fill="{BLUE}" stroke="{INK}" stroke-width="6"/>
  <rect x="30" y="44" width="100" height="68" rx="28" fill="#FFF8EE"/>
  <ellipse cx="60" cy="74" rx="10" ry="13" fill="{INK}"/><ellipse cx="100" cy="74" rx="10" ry="13" fill="{INK}"/>
  <circle cx="63" cy="69" r="3.5" fill="#FFF"/><circle cx="103" cy="69" r="3.5" fill="#FFF"/>
  {mouth}
  <circle cx="40" cy="92" r="7" fill="{PINK}" opacity=".7"/><circle cx="120" cy="92" r="7" fill="{PINK}" opacity=".7"/>
</g>'''


# Simple line icons, 64x64, drawn at (x, y).
def icon(name, x, y, color=INK, s=1.0):
    p = {
        "notebook": '<rect x="12" y="6" width="40" height="52" rx="6"/><path d="M20 6 v52 M28 20 h16 M28 30 h16 M28 40 h10"/>',
        "shield": '<path d="M32 6 l22 8 v16 c0 14 -10 24 -22 28 c-12 -4 -22 -14 -22 -28 v-16z"/><path d="M22 32 l7 7 l13 -14"/>',
        "hand": '<path d="M10 22 h44 M10 42 h44"/><circle cx="24" cy="22" r="7"/><circle cx="40" cy="42" r="7"/>',
        "book": '<path d="M8 12 c8 -4 16 -4 24 2 c8 -6 16 -6 24 -2 v40 c-8 -4 -16 -4 -24 2 c-8 -6 -16 -6 -24 -2z M32 14 v40"/>',
        "gear": '<circle cx="32" cy="32" r="10"/><path d="M32 6 v8 M32 50 v8 M6 32 h8 M50 32 h8 M13 13 l6 6 M45 45 l6 6 M51 13 l-6 6 M19 45 l-6 6"/>',
        "folder": '<path d="M6 16 h18 l6 6 h28 v30 h-52z"/>',
        "brush": '<path d="M44 8 l12 12 l-22 22 l-12 -12z M22 30 c-10 0 -14 8 -14 18 c10 0 18 -4 18 -14"/>',
        "puzzle": '<path d="M10 20 h12 c0 -10 12 -10 12 0 h12 v12 c10 0 10 12 0 12 v12 h-36z"/>',
        "chat": '<path d="M8 12 h48 v30 h-28 l-12 10 v-10 h-8z"/><path d="M20 27 h2 M31 27 h2 M42 27 h2"/>',
        "box": '<path d="M8 20 l24 -12 l24 12 v26 l-24 12 l-24 -12z M8 20 l24 12 l24 -12 M32 32 v26"/>',
        "flag": '<path d="M14 58 v-50 M14 10 h34 l-8 10 l8 10 h-34"/>',
        "magnify": '<circle cx="26" cy="26" r="16"/><path d="M38 38 l16 16"/>',
        "hammer": '<path d="M8 18 l16 -10 l10 10 l-6 6 l22 26 l-6 6 l-26 -22 l-4 4z"/>',
    }[name]
    return (f'<g transform="translate({x} {y}) scale({s})" fill="none" stroke="{color}" stroke-width="4" '
            f'stroke-linecap="round" stroke-linejoin="round">{p}</g>')


# Graphics placed right under a page heading that says the same: drawn without their own title,
# shifted up by this many pixels.
BARE = {"assets/docs/docs-map.svg": 92, "assets/docs/homes.svg": 126, "assets/docs/checks.svg": 126}


def svg(path, w, h, title, desc, body, bg=CREAM):
    if path in BARE:
        dy = BARE[path]
        body = "\n".join(ln for ln in body.split("\n") if 'class="heading"' not in ln)
        body = f'<g transform="translate(0 -{dy})">\n{body}\n</g>'
        h -= dy
    defs = (f'<defs><marker id="head" viewBox="0 0 10 10" refX="7" refY="5" markerWidth="5" '
            f'markerHeight="5" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10z" fill="{SOFT}"/>'
            f'</marker></defs>')
    doc = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}" '
           f'role="img" aria-labelledby="t d">\n<title id="t">{escape(title)}</title>\n'
           f'<desc id="d">{escape(desc)}</desc>\n{defs}\n'
           f'<g font-family="{FONT}">\n{rect(0, 0, w, h, 32, bg)}\n{body}\n</g>\n</svg>\n')
    full = os.path.join(ROOT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8") as f:
        f.write(doc)
    print(f"wrote {path} ({w}x{h})")


def heading(title, sub=None, x=56, y=84):
    out = text(x, y, title, 46, True, extra=' class="heading"')
    if sub:
        out += "\n" + text(x, y + 44, sub, 26, False, SOFT, extra=' class="heading"')
    return out


# ---------- docs ----------

def docs_map(path="assets/docs/docs-map.svg"):
    cards = [
        (PINK, "flag", "Beginner's guide", "From nothing installed to a moving character. About an hour."),
        (BLUE, "gear", "How it works", "Every habit the kit gives Claude, and the failure behind it."),
        (GREEN, "folder", "Every file", "What the kit adds to your project, and why."),
        (YELLOW, "brush", "Make it yours", "Change rules, add steps, turn things off."),
        (PURPLE, "puzzle", "Companions", "Other plugins that work well beside it."),
    ]
    b = [heading("Where to next")]
    cw, ch, gap, y0 = 376, 230, 24, 130
    for i, (col, ic, t, body) in enumerate(cards):
        row, colm = divmod(i, 3)
        n = 3 if row == 0 else 2
        x0 = 52 if row == 0 else 52 + (cw + gap) // 2
        x = x0 + colm * (cw + gap)
        y = y0 + row * (ch + gap)
        b.append(rect(x, y, cw, ch, 24, WHITE, col, 4))
        b.append(f'<circle cx="{x + 52}" cy="{y + 56}" r="32" fill="{col}"/>')
        b.append(icon(ic, x + 24, y + 28, INK, 0.88))
        b.append(text(x + 100, y + 66, t, 29, True))
        p, _ = para(x + 28, y + 132, body, cw - 56, 23)
        b.append(p)
    svg(path, 1280, y0 + 2 * ch + gap + 44, "Where to next",
        "Five guides: the beginner's guide; how it works; every file the kit adds; make it yours "
        "(customising); companions. The links are listed below the picture.",
        "\n".join(b))


def journey():
    stops = [("What it all is", "5 min"), ("Accounts", "10 min"), ("Install the tools", "30 min"),
             ("Make the project", "5 min"), ("Start Claude", "5 min"), ("Install the kit", "5 min"),
             ("Set it up", "10 min"), ("Back it up", "5 min"), ("Make something", "your pace"),
             ("Every day", "")]
    cols = [BLUE, YELLOW, GREEN, PINK, PURPLE, BLUE, YELLOW, GREEN, ORANGE, INK]
    b = [heading("Your first hour", "Ten parts. Each ends with a check, so you know it worked.")]
    xs = [140 + i * 250 for i in range(5)]
    y1, y2 = 230, 470
    road = (f'<path d="M{xs[0]} {y1} H{xs[4]} a120 120 0 0 1 0 {y2 - y1} H{xs[0]}" fill="none" '
            f'stroke="#D8CDBA" stroke-width="22" stroke-linecap="round"/>'
            f'<path d="M{xs[0]} {y1} H{xs[4]} a120 120 0 0 1 0 {y2 - y1} H{xs[0]}" fill="none" '
            f'stroke="{WHITE}" stroke-width="4" stroke-dasharray="16 14"/>')
    b.append(road)
    for i, (t, m) in enumerate(stops):
        x = xs[i] if i < 5 else xs[9 - i]
        y = y1 if i < 5 else y2
        b.append(badge(x, y, 34, cols[i], str(i + 1), 30))
        b.append(text(x, y + 76, t, 24, True, INK, "middle"))
        if m:
            b.append(text(x, y + 108, m, 22, False, SOFT, "middle"))
    b.append(icon("flag", xs[0] - 120, y2 - 40, ORANGE, 1.1))
    svg("assets/docs/guide-journey.svg", 1280, 630, "Your first hour",
        "A road with ten stops: what it all is, 5 minutes; accounts, 10; install the tools, 30; make "
        "the project, 5; start Claude, 5; install the kit, 5; set it up, 10; back it up, 5; make "
        "something, at your pace; every day after.",
        "\n".join(b))


def three_words():
    words = [(BLUE, "resume", "to start a session"), (GREEN, "save work", "after each thing you like"),
             (ORANGE, "wrap up", "at the end of the day")]
    b = [heading("Three words to remember", "Everything else, Claude asks you.")]
    cw, gap, x0, y0 = 368, 28, 56, 160
    for i, (col, w, when) in enumerate(words):
        x = x0 + i * (cw + gap)
        b.append(rect(x, y0, cw, 180, 24, WHITE, col, 5))
        b.append(text(x + cw // 2, y0 + 82, w, 44, True, INK, "middle", mono=True))
        b.append(text(x + cw // 2, y0 + 136, when, 25, False, SOFT, "middle"))
    svg("assets/docs/three-words.svg", 1280, 380, "Three words to remember",
        "resume to start a session; save work after each thing you like; wrap up at the end of the day.",
        "\n".join(b))


def inside():
    b = [heading("Inside the kit", "What runs where, and who starts it.")]
    # You -> Claude Code
    b.append(rect(56, 150, 230, 120, 24, ORANGE))
    b.append(text(171, 204, "You", 34, True, WHITE, "middle"))
    b.append(text(171, 242, "say a few words", 22, False, WHITE, "middle"))
    b.append(arrow(292, 210, 380, 210))
    b.append(rect(386, 150, 838, 120, 24, INK))
    b.append(pip(408, 152, 0.7))
    b.append(text(560, 206, "Claude Code", 34, True, CREAM))
    b.append(text(560, 244, "reads the kit, works in your project", 23, False, CREAM))
    parts = [
        (BLUE, "Skills", "Recipes your words start: resume, plan-feature, save-work, update…"),
        (GREEN, "Hooks", "Run on their own: the start card, the file guard, lint, the stop check."),
        (YELLOW, "Rules", "How Claude behaves: CLAUDE.md and .claude/rules/."),
        (PINK, "Checks", "tools/dev.sh: check, run, lint, budget. Proof, not promises."),
    ]
    cw, gap, x0, y0 = 266, 24, 56, 330
    for i, (col, t, body) in enumerate(parts):
        x = x0 + i * (cw + gap)
        b.append(rect(x, y0, cw, 290, 24, WHITE, col, 4))
        b.append(rect(x, y0, cw, 64, 24, col))
        b.append(rect(x, y0 + 40, cw, 24, 0, col))
        b.append(text(x + 24, y0 + 44, t, 30, True, ON[col]))
        p, _ = para(x + 24, y0 + 108, body, cw - 48, 23)
        b.append(p)
        b.append(arrow(x + cw // 2, 280, x + cw // 2, y0 - 6, SOFT, 3, dash=True))
    b.append(rect(56, 670, 1168, 150, 24, SKY, BLUE, 4))
    b.append(icon("notebook", 84, 712, INK))
    b.append(text(170, 728, "Your project's notes", 30, True))
    p, _ = para(170, 772, "STATUS, plans, decisions, known bugs and memory: plain files in git, on every computer.", 1030, 24)
    b.append(p)
    b.append(arrow(640, 626, 640, 664, SOFT, 3))
    svg("assets/docs/inside.svg", 1280, 860, "Inside the kit",
        "You say a few words to Claude Code, which reads the kit. The kit has skills (recipes your "
        "words start, like resume and save-work), hooks (run on their own: the start card, the file "
        "guard, lint, the stop check), rules (CLAUDE.md and .claude/rules/) and checks (tools/dev.sh). "
        "Everything it learns goes into your project's notes: plain files in git, on every computer.",
        "\n".join(b))


def homes():
    rows = [
        (BLUE, "Where we are, what's next", "docs/STATUS.md"),
        (YELLOW, "Why it's that way", "docs/decisions/"),
        (GREEN, "What each system does now", "docs/systems/"),
        (PINK, "Bugs not fixed yet", "docs/known-bugs.md"),
        (PURPLE, "How you like to work", ".claude/memory/"),
        (ORANGE, "Rules for Claude", "CLAUDE.md, .claude/rules/"),
    ]
    b = [heading("One home per fact", "Written once, in one place. Everything else points there.")]
    y0, rh = 170, 92
    for i, (col, fact, home) in enumerate(rows):
        y = y0 + i * rh
        b.append(rect(56, y, 520, 70, 35, col))
        b.append(text(88, y + 45, fact, 26, True, ON[col]))
        b.append(arrow(586, y + 35, 690, y + 35))
        b.append(rect(700, y, 524, 70, 18, WHITE, LINE))
        b.append(text(728, y + 45, home, 26, False, INK, mono=True))
    svg("assets/docs/homes.svg", 1280, y0 + len(rows) * rh + 30, "One home per fact",
        "Each kind of fact has one file: where we are and what's next, docs/STATUS.md; why it's that "
        "way, docs/decisions/; what each system does now, docs/systems/; bugs not fixed yet, "
        "docs/known-bugs.md; how you like to work, .claude/memory/; rules for Claude, CLAUDE.md and "
        ".claude/rules/.",
        "\n".join(b))


def checks():
    rungs = [
        (GREEN, "Every edit", "Format and lint, automatically. A problem goes straight back to Claude."),
        (BLUE, "Before it stops", "The stop check asks for the checks that cover what changed."),
        (YELLOW, "Each small step", "The checks for that part, and a ten-second headless run."),
        (PINK, "Each task", "ship-check: every check, a play-test, and \"To try\" for you."),
        (PURPLE, "Each milestone", "A fresh reviewer that never sees Claude's own summary."),
    ]
    b = [heading("Checked before you see it", "Each step up runs less often and looks harder.")]
    y0, rh = 170, 112
    for i, (col, when, what) in enumerate(rungs):
        y = y0 + i * rh
        x = 56 + i * 40
        b.append(rect(x, y, 1168 - i * 80, 92, 22, WHITE, col, 4))
        b.append(rect(x, y, 260, 92, 22, col))
        b.append(rect(x + 230, y, 30, 92, 0, col))
        b.append(text(x + 26, y + 56, when, 27, True, ON[col]))
        b.append(vpara(x + 286, y + 46, what, 1168 - i * 80 - 320, 24))
    yb = y0 + len(rungs) * rh + 10
    b.append(rect(456, yb, 368, 80, 40, ORANGE))
    b.append(text(640, yb + 51, "Then you play it", 30, True, WHITE, "middle"))
    svg("assets/docs/checks.svg", 1280, yb + 120, "Checked before you see it",
        "Five levels of checks: every edit is formatted and linted; before Claude stops, the stop "
        "check asks for the checks; each small step runs its checks and a ten-second headless run; "
        "each task runs ship-check with a play-test; each milestone gets a fresh reviewer. Then you "
        "play it.",
        "\n".join(b))


def tree():
    items = [
        (0, "your-game/", None, ""),
        (1, "project.godot", None, "Godot's project file"),
        (1, "CLAUDE.md", BLUE, "Claude's instructions, read every session"),
        (1, ".claude/rules/", BLUE, "How Claude works, by topic"),
        (1, ".claude/memory/", BLUE, "What it learned about how you work"),
        (1, "docs/STATUS.md", YELLOW, "Where you stopped, what's next"),
        (1, "docs/plans/", YELLOW, "The roadmap, a plan per big feature"),
        (1, "docs/decisions/", YELLOW, "What you decided and why (first use)"),
        (1, "docs/known-bugs.md", YELLOW, "Bugs found, not fixed yet"),
        (1, "docs/guides/start-here.md", YELLOW, "Your everyday cheat sheet"),
        (1, "inbox/", YELLOW, "Your drop box between sessions"),
        (1, "tools/dev.sh", GREEN, "The checks, in one script"),
        (1, "tests/", GREEN, "The checks themselves"),
        (1, ".githooks/", GREEN, "Checks at commit time"),
    ]
    b = [heading("What it adds to your game")]
    leg = [(BLUE, "Claude reads it"), (YELLOW, "you read it too"), (GREEN, "runs on its own")]
    lx = 56
    for col, s in leg:
        b.append(f'<circle cx="{lx + 14}" cy="140" r="14" fill="{col}"/>')
        b.append(text(lx + 38, 149, s, 24, True, SOFT))
        lx += 60 + len(s) * 14
    y0, rh = 200, 56
    for i, (ind, name, col, what) in enumerate(items):
        y = y0 + i * rh
        x = 70 + ind * 44
        if ind:
            b.append(f'<path d="M{70 + 16} {y - rh + 18} V{y - 8} H{x - 8}" fill="none" stroke="#D8CDBA" stroke-width="3"/>')
        if col:
            b.append(f'<circle cx="{x + 10}" cy="{y - 8}" r="11" fill="{col}"/>')
        b.append(text(x + (34 if col else 0), y, name, 24, ind == 0, INK, mono=True))
        if what:
            b.append(text(640, y, what, 24, False, SOFT))
    H = y0 + len(items) * rh + 20
    svg("assets/docs/tree.svg", 1280, H, "What it adds to your game",
        "A file tree of a game with the kit. Claude reads CLAUDE.md, .claude/rules/ and "
        ".claude/memory/. You read docs/STATUS.md, docs/plans/, docs/decisions/, docs/known-bugs.md, "
        "docs/guides/start-here.md and use inbox/. tools/dev.sh, tests/ and .githooks/ run on their own.",
        "\n".join(b))


ART = [docs_map, journey, three_words, inside, homes, checks, tree]

if __name__ == "__main__":
    for f in ART:
        f()
    import readme_art

    readme_art.main()

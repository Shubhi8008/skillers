# Anti-slop UX

AI output fails in two ways: it looks like every other AI output, and it does more than was asked. Set a budget first, then cut to purpose, then score.

## 1. Set the budget (before generating, or before reviewing)
Defaults below. A brief can override a number, but must say so.

**Scope**
- Deliver what was asked. No extra pages, variants, features, sections or files.
- Options: 3 maximum, only when options were asked for.

**Layout (per screen)**
- 1 primary action. (Hick 1952, Von Restorff)
- Landing page: 7 sections or fewer. App screen: 1 main task.
- Content groups of 3 to 5 items. (Miller 1956, Cowan 2001)
- Navigation 7 items or fewer.

**Visual**
- 1 accent color, for the primary action and state only.
- 2 font families, 4 type sizes or fewer.
- 1 shadow level, 2 corner radius values or fewer.
- Decoration must carry meaning: no glow, blob, noise, gradient text, or stacked cards that encode nothing. (Nielsen #8, extraneous cognitive load)
- Motion that explains passes the purpose test: it shows a change over time (process, before and after, a decision, a flow), one change at a time, paced by the reader, captioned, with a still for reduced motion. Motion that only decorates fails it. (Tversky, Morrison, Betrancourt 2002; Mayer multimedia principles)
- Icons only where they speed recognition. No emoji as icons.
- Charts only with real data; remove ink that does not show data. (Tufte 1983)

**Copy**
- Above the fold: headline 10 words or fewer, sub line 25 words or fewer.
- Body blocks 60 words or fewer. People read only a small share of the words on a page (Nielsen 2008, How little do users read?), so every word competes.
- Omit needless words (Strunk 1918). Halve the draft, then cut again where possible (Krug, Don't Make Me Think).
- No invented facts: fake stats, logos, testimonials or names.

## 2. Cut to purpose
For every element answer:
1. Which user task does it serve?
2. Which law, heuristic or data supports its form?
3. What breaks if it is removed?
If 3 is "nothing" or 1 has no answer, delete it. If 2 has no answer, mark it "assumption" and keep it only with a planned test.

## 3. Remove the tells
**Visual**: default indigo or purple to blue gradients; one font for every role; everything centered; hero over three identical feature cards; glassmorphism without reason; glowing borders; rounded icon tile over every heading; cards inside cards; gray text on colored backgrounds; ALL-CAPS stat cards; fake dashboard screenshots; badge floating over the hero; uniform spacing with no rhythm; stock 3D blobs.

**Copy**: "not X, but Y" contrasts; reflexive lists of three; staged run-ups ("Here's the thing"); one line dramatic closers; inflated words (seamless, unlock, elevate, supercharge, game-changer, delve, robust, cutting-edge); em dashes; vague claims with no object ("transform your workflow"); rhetorical questions as openers; exclamation marks in UI.

**Volume**: summaries of what was just said; several CTAs with different wording on one screen; comments that restate code; "coming soon" placeholder sections; near-identical variants nobody asked for.

## 4. Refine for usability
Walk the main task from entry to success:
- First screen shows what this is and what to do? (NN/g scrolling and attention)
- Each step is one decision? (Hick, Nielsen #6)
- Feedback within 400 ms? (Doherty)
- Success state designed? (Peak-end)
Fix anything the cut broke. Cutting that hurts the task is not a win.

## 5. Score and gate
Start at 100. Floor failures block shipping: contrast below WCAG AA, no focus states, invented facts, broken mobile layout, more than one primary action per screen, false success states (UI says done when the action failed), and runtime-heavy delivery that blocks first paint (development builds, in-browser compilers like Babel standalone, CDN dev scripts, or scripts loaded but never used). Subtract 5 per budget overrun, 3 per visual or copy tell, 3 per element that failed the purpose test and stayed.
Ship at 85+ with no floor failures. Below 85, revise and score again.
Report: score, floor status, top 5 cuts, top 3 remaining risks.

## Works with
After base-work mode, before `impeccable` critique. Pair with `stop-slop` or `humanizer` for long prose.

## Sources
Nielsen 10 heuristics · Sweller cognitive load theory · Hick 1952 · Miller 1956 · Cowan 2001 · Nielsen 2008 (NN/g) · Tufte 1983 · Strunk 1918 · Krug · tells consolidated from Nutlope/hallmark, yetone/kill-ai-slop, Gesso-Build anti-slop, funboy322/avoid-ai-design, hardikpandya/stop-slop, blader/humanizer
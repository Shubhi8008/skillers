# Reference collage

Goal: references that match the meaning of the prompt, not its keywords, with a reason for every pick. Then let the user curate.

## 1. Read the prompt into a brief
Pull out: subject (page, screen, flow, brand, poster), product or niche, audience, mood words, must have, must avoid, platform. Do not ask questions unless the subject is missing. Write the brief in 3 lines at the top of the board note.

## 2. Plan queries (6 to 10)
Mix four kinds so results are not all the same:
1. **Literal:** the subject in plain words ("designer portfolio about page").
2. **Niche:** the product or audience ("interaction designer", "fintech onboarding").
3. **Structure:** layout pattern names ("split hero", "bento grid", "editorial spread", "pinned scrollytelling", "case study chapters").
4. **Mood:** 1 or 2 mood words max ("editorial", "warm", "brutalist").
Keep a list of must-avoid terms from the brief and from the anti-slop tells.

## 3. Gather (40 to 80 candidates, max 2 pages per source)
Record every item as `{id, source, title, author, page, img}` into `<board>/<source>.json`. Board folder: `{paths.boards}/<board-slug>/`.

| Source | How | Notes |
|---|---|---|
| Dribbble | Built-in browser: open `https://dribbble.com/search/<query-with-dashes>`, wait 4 s, run the extractor JS below | Works with the browser pane hidden. Drop ads (page not on dribbble.com/shots) and avatar images |
| Awwwards | `refs.ps1 -Mode awwwards -Query <category>` | Gives page links and image URLs. Its image CDN blocks script downloads: judge by a browser screenshot of the page instead |
| Godly | `refs.ps1 -Mode godly` | Latest items only |
| Any page | `refs.ps1 -Mode og -Urls "u1,u2"` | og:image of pages found by WebSearch (studio sites, case studies) |
| Pinterest, Cosmos, Behance | Built-in browser, only with the pane visible and the user signed in | Ask the user to show the pane (Ctrl+Shift+B) before using these |
| Inspo, Awwwards MCP, Refero, Mobbin | Use if connected | Mobbin needs a paid plan |

Dribbble extractor JS:
```js
JSON.stringify([...document.querySelectorAll('li.shot-thumbnail, li[id^=screenshot]')].map((li,k)=>{const a=li.querySelector('a.shot-thumbnail-link, a[href*="/shots/"]');const i=li.querySelector('img');const t=li.querySelector('.shot-title,[class*=title]');const by=li.querySelector('.display-name,[class*=user-information] a');return {id:'dr'+(k+1),source:'Dribbble',title:t?t.textContent.trim().slice(0,80):(i?i.alt:''),author:by?by.textContent.trim().slice(0,40):'',page:a?new URL(a.getAttribute('href'),location.origin).href:null,img:i?(i.getAttribute('data-src')||i.currentSrc||i.src):null}}).filter(s=>s.page&&s.img&&/\/shots\//.test(s.page)&&!/avatars/.test(s.img)))
```

Scripts live in `{paths.repo}/skills/skillers/scripts/`. `scripts/refs.ps1` needs Windows (run it with `{runner}`); `scripts/collage.py` needs Python 3 with Pillow on any machine that can see the board folder.
`powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File {paths.repo}\skills\skillers\scripts\refs.ps1 -Mode <mode> ...`
Only use sources marked true in `{sources}`.

## 4. Look before judging
1. Download thumbnails: `refs.ps1 -Mode thumbs -In <board>\<source>.json -OutDir <board>\_thumbs`.
2. Build a numbered contact sheet: `python3 collage.py sheet <board>` (run where the board folder is mounted, or stage the folder).
3. Read `_sheet.jpg` and judge what is actually in each image. Never score from titles alone.

## 5. Score every candidate (0 to 5 each)
- **Fit:** matches the subject, niche and mood of the brief.
- **Law fit:** one clear focal point in the first second, chunked content, clear grouping (proximity, common region), readable scanning path (F-pattern or layer cake), contrast that would pass WCAG AA, one accent for the primary action.
- **Purpose:** decoration and motion explain something. Motion that shows change over time passes.
- **Slop penalty (subtract):** indigo or purple gradients, centered "Hi, I'm" hero over three cards, stat-card rows, glassmorphism without reason, generic 3D mascots, emoji as icons, fake dashboards, template look.
Keep the top 10 to 16. Diversity rule: no more than 3 from one author or one source, and at least 3 different layout patterns.

## 6. Tag each pick
- `borrow`: the one pattern worth taking, in one line
- `why`: why it fits the brief, in plain words
- `laws`: the laws or studies it shows
- `avoid`: what not to copy
- `group`: Top picks, Layout, Type and colour, Motion, or Maybe

Save as `<board>\picks.json`.

## 7. Build the collage
1. `python3 collage.py palette <board> <top pick ids>` for measured colours.
2. `python3 collage.py canvas <board> <board>\picks.json` writes `board.canvas` (Obsidian canvas, one group per category, each card with image, credit link, borrow, why, laws, avoid).
3. Write `board.md`: brief, direction from the top picks (layout, first second, personality, type, measured palette), a rejected table with reasons, and liked and disliked tags in frontmatter.
4. Link the board from `{paths.vault}/Welcome.md` if it exists.

## 8. Refine with the user
Under autopilot, skip this step during the run: the Top picks group counts as chosen. Run it when the user reacts after the run.
Read their reaction in plain words and act on it:
- "keep 3 and 7" → move to Top picks, add their tags to `liked`.
- "drop dark ones" → remove them, add the trait to `disliked`, filter remaining candidates.
- "more like 5" → new queries from 5's title, borrow line and pattern name, gather, score, add up to 6 new cards to Maybe.
- "make the palette warmer" → re-run palette on a warmer subset or note the shift.
Re-run steps 5 to 7 on each change. Keep `liked` and `disliked` in the board note so the next session continues the same taste.

## 9. Hand off
Output the direction brief for base-work mode or a hi-fi pass: layout pattern, first second focal point, section order, type pairing direction, measured palette with one accent, motion cues, and the laws behind each.

## Rules
- Credit every reference with its source link. References are for study: never copy a layout whole, never rehost an image as your own.
- Browse as the user would: max 2 result pages per source per query, waits between requests, no login bypass, no scraping behind paywalls.
- Do not download or use photos of real people beyond the reference thumbnail in the private board.
- If a source blocks, say which one and move on.

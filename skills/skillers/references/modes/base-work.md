# UX base work

Produce structure before style. Output is a wireframe someone can critique, test and hand to hi-fi.

## 1. Intake
Pull from the brief: product, page or flow, audience, primary goal (one metric), platform, constraints, must haves, must avoids.
Ask at most 2 questions, and only if the primary goal or the page type is missing. Otherwise state assumptions in one line and continue. Never default the goal to contact or sign up. Name the goal in the first line of the output so the user can correct it early.

Write the problem statement:
> [User group] trying to [goal] currently [pain or workaround], because [cause]. This leads to [user impact] and [business impact].
One problem. No solution inside it.

## 2. References (optional, fast)
If a design reference tool is connected (Inspo MCP, Mobbin, Refero, Awwwards MCP), pull 3 to 5 references matching the brief. For each, note the one pattern worth borrowing. Never copy a layout whole. Skip if nothing is connected.

## 3. Information architecture
1. Content inventory: every block the page needs.
2. Rank by user task and business goal. Top 20% goes in the first screen (Pareto).
3. Order sections for scanning using the page type patterns below.

## 4. Three options
One HTML file, grayscale only, system font, real copy (no lorem ipsum), tabs to switch options.
- Option A, Familiar: the category's common pattern (Jakob's Law). Lowest risk.
- Option B, Conversion first: tightest path to the primary goal. Fewest choices, strongest CTA placement.
- Option C, Distinctive: a different structure (progressive disclosure, wizard, split view, hub and spoke, bento) that still passes every rule.

Each option carries small numbered markers on key elements. Under the wireframe, each marker explains the decision and names the law or study behind it. Show desktop and mobile frames side by side; mobile shows the primary action in thumb reach.

## 5. Rule pass
Run every option through the rule pack below. Fix failures before showing. Flag any rule deliberately broken and why.

## 6. Microcopy
Headline states the outcome in plain words. CTA names the outcome ("Get my quote", not "Submit"); first person is a test candidate. Say "free" if free. Doubt remover next to the primary CTA. Errors say what happened and how to fix it.

## 7. SEO block (web pages only)
Title (under ~60 chars), one H1 matching search intent, H2 outline, URL slug, meta description (under ~155 chars), alt text plan, notes for LCP, INP, CLS.

## 8. Decision log and recommendation
Table per option: decision, options considered, chosen, why (law, heuristic or data), how to test. Mark anything without evidence as "assumption" with a test.
Then Nielsen's 10 heuristics check: pass or flag, severity 0 to 4.
End with one recommended option and the single A/B test to run first.

## Output
1. Problem statement and assumptions (short)
2. The HTML wireframe file
3. Decision log, heuristics check, SEO block
4. Recommendation in 2 or 3 sentences

## Do not
- Add color, gradients or brand styling. That is the hi-fi step.
- Use dark patterns: fake scarcity, confirm shaming, pre ticked add-ons, hidden costs.
- Put more than one primary CTA in a screen.
- Bake text into images.

---

# Rule pack

## Choice and decision
- One primary CTA per screen, secondary actions visually weaker. (Hick 1952, Von Restorff)
- Top navigation 7 items or fewer. (Hick, Miller)
- Pricing 3 tiers or fewer, one marked recommended. (Choice overload)
- Every block has a job. (Occam's Razor, Nielsen #8)

## Motor
- Primary button at least 44 px tall on touch, full width on mobile forms. (Fitts 1954)
- Primary action next to the content it acts on. (Fitts)
- Feedback within 400 ms; show nothing under ~400 ms so no spinner flashes. (Doherty)

## Loading and motion
- Real speed first: a 0.1 s gain went with +8.4% retail conversion in Deloitte's 2020 study of 37 brands. Note LCP and INP targets on the wireframe.
- 0.4 to 2 s: skeleton only if it matches the final layout geometry exactly (protects CLS); spinner if layout is unknown. Skeletons are not a speed trick (Viget 2017 found them slowest).
- Over 2 s: determinate progress with a label. Front-load progress, never stall near the end (Harrison 2007, 2010).
- Loader motion at moderate speed, one motion only. Moderate beats none, slow and fast for perceived wait and conversion (Ding and Kyung 2025, JCR).
- Entering or responding elements use ease-out under ~300 ms; ease-in only for exits. Honour prefers-reduced-motion.

## Eye movement
- Design the first second: one high-contrast focal point that is the value proposition or primary action (bottom-up attention).
- Attention is not conversion: never add an eye-catching element just to win gaze (Schneckenleitner and Wild 2025).
- Fewer elements on the key path means fewer fixations and lower load (Rahman et al. 2026).
- AI attention prediction (saliency model or VLM) is an early check only; it misses first glances (UIGaze 2026).

## Memory and load
- Content chunked into groups of 3 to 5. (Miller 1956, Cowan 2001)
- No screen depends on info remembered from a previous screen. (Nielsen #6)
- Forms over 6 fields split into steps with progress. (Cognitive load, Goal gradient, Zeigarnik)
- Smart defaults and autofill. (Tesler)
- 4 type sizes or fewer, 1 accent reserved for the primary action. (Extraneous load)

## Perception
- Spacing tighter inside groups than between. (Proximity)
- Related items share a container. (Common region)
- Same function, same style. (Similarity, Nielsen #4)

## Expectations
- Logo top left links home; search and account where the category expects. (Jakob's Law)
- Labels in user words. (Mental model, Nielsen #2)
- Inputs accept loose formats. (Postel)
- Undo or back on destructive steps. (Nielsen #3, #5)

## Scanning and placement
- Value proposition and primary CTA in the first screen. (NN/g 2018: 57% of viewing time above the fold, 74% in first two screens)
- Main point in the first two paragraphs; headings lead with key words. (F-pattern, layer cake)
- Strong labels on the left edge. (F-pattern)
- Next section peeks above the fold; no false floor.
- CTA repeated after major proof blocks and at the end. (Serial position)
- Key content must not look like an ad. (Banner blindness)

## Conversion
- Motivation, ability and prompt all present at the CTA. (Fogg B = MAP)
- Social proof next to the decision point.
- Checkout or sign up shows minimum fields; about 7 fields for checkout. (Baymard)
- Single column forms, inline validation, data kept after errors, optional fields marked, guest path. (Baymard)
- Success and confirmation states designed. (Peak-end rule)

## Copy
- Descriptive link text, never "click here".
- Error text: what happened, how to fix, no blame. (Nielsen #9)

## SEO
- Unique title, one H1, logical H2s, readable slug, meta description, real text in HTML, alt text. (Google SEO Starter Guide)
- Hero media sized up front, no load popup. Targets LCP 2.5 s, INP 200 ms, CLS 0.1. (web.dev)

---

# Section order by page type
- Landing page: hero (outcome headline, sub, CTA, doubt remover, visual) > proof strip > problem and solution in 3 chunks > how it works in 3 steps > features > testimonials > pricing > FAQ > final CTA
- Product page: images, title, price, rating, variants, add to cart above the fold > delivery and returns > benefits > reviews > specs > related
- Checkout: single column; contact > shipping > payment > review; summary always visible; guest default; express pay on top
- Onboarding: value first, 3 to 5 steps with progress, skip where possible, early first success, clear next action
- Dashboard: key number top left, 4 to 6 summary cards, one primary action, drill down detail, teaching empty states
- Portfolio or case study: name and role, 3 to 6 projects as problem > process > outcome with a number, contact CTA
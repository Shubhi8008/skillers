---
title: Motion, loading and eye movement
created: 2026-11-07
tags: [research, motion, loading, eye-tracking, cro]
---

# Motion, loading and eye movement

## 1. Speed itself converts
- Deloitte and 55 for Google, *Milliseconds Make Millions* (2020): 37 brand sites, 30M+ mobile sessions. A 0.1 s gain across 4 speed metrics went with +8.4% conversion in retail and +10.1% in travel, and +21.6% form completion on lead gen sites. Correlational and commissioned by Google, so read it as direction, not exact lift.
- Rule: real speed beats every perceived speed trick. Fix LCP and INP first (SEO and Performance).

## 2. Loading screens
| Finding | Source | Strength |
|---|---|---|
| Skeleton screen felt slowest: 2.82 s perceived vs spinner 2.41 s vs blank 2.29 s, same real wait | Viget 2017, n=136 | small practitioner test |
| Other small studies found skeletons a little faster or easier | uxdesign.cc study, a thesis | mixed |
| Motion design cut perceived load by up to ~1 s (17.4%) vs a plain spinner | VMware Design 2021, 1,000+ users | practitioner |
| Progress bars that speed up near the end and avoid late pauses feel faster | Harrison et al. 2007, UIST | peer reviewed |
| Backward moving, decelerating ribbing cut perceived duration about 11% | Harrison, Yeo, Hudson 2010, CHI | peer reviewed |
| Faster countdowns feel shorter in the moment but are remembered as longer | Countdown Timer Speed 2020, ACM (paywalled) | peer reviewed |
| Slower spinning throbbers felt shorter for short waits (~5 s) | Throbber components 2020, MobileHCI (paywalled) | peer reviewed |
| **Moderate** animation speed minimises perceived wait; none, slow and fast are all worse. Effect carried into click-to-landing and conversion rates | Ding and Kyung 2025, *Journal of Consumer Research* | peer reviewed, newest |

**Theory behind it.** People judge time by how much attention goes to time itself. Motion draws attention away from the clock, and people also read motion speed as a clue for how long the wait is. Ding and Kyung show this is not linear: medium speed wins. Busy two-element animations or unusual animations weaken the effect because attention leaves the speed cue.

**Rules**
1. Under ~400 ms: show nothing (Doherty threshold). A flash of spinner feels broken.
2. 0.4 to 2 s: skeleton if the layout is known and the skeleton matches the final geometry exactly (also protects CLS). Spinner if the layout is unknown.
3. Over 2 s: determinate progress with a label of what is happening. Front-load progress, never stall near the end.
4. Loader animation at moderate speed, one motion, nothing fancy.
5. Treat skeletons as layout stability, not a speed trick.

## 3. Easing and motion
- Ease-out (fast start, slow end) for anything entering or responding to a tap. It shows feedback at the moment the user is watching. Keep UI transitions under ~300 ms. Ease-in only for things leaving. (Practitioner standard: Material motion, Emil Kowalski design engineering skills.)
- Binucci et al. 2023 user study: participants preferred eased (cubic Bézier) motion and rated slower speeds as nicer, while faster eased motion helped task accuracy. Pick an intermediate speed.
- Cachelin 2022 (JCGT, Apple): one timing curve model that covers ease, anticipation and overshoot for UI state transitions.
- Always honour `prefers-reduced-motion` (WCAG 2.3.3).

## 4. Eye movement: what is new
| Paper | Year | What it says |
|---|---|---|
| UEyes (Jiang, Leiva et al.), CHI | 2023 | 62 people, 1,980 screens, 4 UI types. Viewing patterns differ by UI type, and attention models trained on one type do worse on others. The main open benchmark. |
| EyeFormer, UIST | 2024 | Predicts a person's own scanpath from a few samples, used to personalise layouts. |
| AGD, graphic design attention | 2024 | Layout-aware model. New dataset of 41 people on 450 webpages. Predicting first fixations could let pages load what people look at first. |
| Emami et al., design decisions in scanpath modeling | 2024 | Small model settings swing the results a lot. Treat any heatmap tool as an estimate. |
| UIGaze (Song et al.) | 2026 | Vision language models (GPT-5.4 and others) match human gaze moderately, better at later exploration than first glances. Fine for early design checks, not a replacement for real eye tracking. |
| Rahman et al., cognitive load on e-commerce | 2026 | 48 people. Fixation count, fixation length and saccades track visual complexity, which shapes how shoppers judge a site. |
| Purchase intent from eye movement (CSWIM) | 2025 | Gaze data predicted purchase intent with AUC about 0.72. |
| Schneckenleitner and Wild, distractors in webshops | 2025 | n=24. Eye-catching elements got looked at but did not drive purchase. Price and taste decided. |
| Pšurný et al., Frontiers in Human Neuroscience | 2024 | EEG plus eye tracking on online purchase factors. |

**Theory now.** Two phases: the first ~1 s is bottom-up (contrast, size, faces, colour pull the eye); after that it is top-down (the task drives the eye). Inhibition of return means people rarely go back to what they already looked at. Hot spots on a heatmap can mean confusion, not interest.

**Rules**
1. Design the first second: one high-contrast focal point that is also the value proposition or primary action.
2. Attention is not conversion. Never add a flashy element just to win gaze; test it against the goal metric.
3. Fewer fixations and shorter saccade paths on the key task means lower load. Cut visual complexity (Cognitive Load and Memory).
4. Use AI attention prediction as an early check, then confirm with real tests.

## 5. For the reference search site
Add a predicted attention overlay on each result (saliency model trained on UEyes, or a VLM pass). It explains why a layout works and is a ranking signal. See Build Plan - AI Reference Search.

## Sources
web.dev Milliseconds make millions · Viget, A Bone to Pick with Skeleton Screens · VMware Design, Measuring the Value of Motion · chrisharrison.net progress bar papers · Stanford GSB, Ding and Kyung 2025, DOI 10.1093/jcr/ucaf037 · arXiv 2309.00456, 2404.10163, 2405.08981, 2407.02439, 2604.26352, 2605.02899 · userinterfaces.aalto.fi/ueyeschi23 · ink.library.smu.edu.sg (CSWIM 2025) · ideas.repec.org (Schneckenleitner and Wild) · Frontiers DOI 10.3389/fnhum.2024.1411685

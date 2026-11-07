---
name: "research-pdf-fetch"
description: "Find and download open-access research papers (arXiv, OpenAlex) as PDFs into the user's research folder and log them in Obsidian. Use when a design decision needs a source or when asked to download papers."
---

# Research PDF fetch

## Config
Read the skillers config first: `$SKILLERS_CONFIG`, else `./skillers.config.json`, else `~/.skillers/config.json`. If none exists, run the `skillers-setup` skill once, then continue. Values in `{braces}` below come from that file.

Legal sources only: arXiv, OpenAlex open-access locations, publisher open versions, author pages. Never Sci-Hub, LibGen, Anna's Archive or other shadow libraries, even if a tool offers them. Paid books and paywalled papers get listed with a buy or library note, not downloaded.

## Where things go
- PDFs: `{paths.papers}`
- Notes: the reading list `{paths.vault}/30 Papers and Books.md` (append a row), and one note per paper under `{paths.vault}/papers/` once read.

## 1. Find
- If a paper search tool is connected (paper-search-mcp with Sci-Hub off, arxiv-mcp-server), use it.
- Otherwise web search the title plus "arXiv" or "pdf" to get the arXiv id or DOI.

## 2. Download
Cloud shells often cannot reach arXiv or OpenAlex. Run the script on the machine named by `{runner}`:
- Windows (`runner: desktop-commander`): `powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -File {paths.repo}\skills\research-pdf-fetch\scripts\fetch-paper.ps1 -Query "<arXiv id | DOI | title>" -OutDir "{paths.papers}"`
- macOS, Linux or a cloud shell with access (`runner: shell`): `python3 {paths.repo}/skills/research-pdf-fetch/scripts/fetch_paper.py "<arXiv id | DOI | title>" "{paths.papers}"`
- Output: `OK <path>`, `EXISTS`, `NOT_PDF`, `NO_OPEN_PDF <title> <DOI>`, or `NOT_FOUND`.
- Title searches can match the wrong work. Compare the printed title with the one wanted. Prefer arXiv id or DOI.
- Wait 3 seconds between downloads.

## 3. Verify
Read page 1 of each new PDF to confirm title and authors. Rename as `YEAR_Short_title.pdf`.

## 4. Log
Add a row per paper: title, year, id, why it matters for the current design question, file path.
When read, write a note: claim, method, sample size, key numbers, limits, how it changes a design decision. Paraphrase. Quote at most one short line.

## 5. Report
What downloaded, what had no open copy (DOI and where to get it), any title mismatches.
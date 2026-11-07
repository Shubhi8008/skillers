#!/usr/bin/env python3
"""fetch_paper.py : download an OPEN ACCESS paper by arXiv id, DOI or title (macOS, Linux, cloud shells).
Sources: arXiv and OpenAlex open-access locations only. No shadow libraries.
Usage: python3 fetch_paper.py "<arXiv id | DOI | title>" <out_dir>
Prints OK <path> | EXISTS <path> | NOT_PDF <url> | NO_OPEN_PDF <title> (<year>) DOI <doi> | NOT_FOUND <query>
"""
import json, os, re, sys, urllib.parse, urllib.request

UA = {"User-Agent": "skillers-research-fetch/1.0"}

def get(url):
    return urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=30).read()

def safe(s):
    return re.sub(r"\s+", "_", re.sub(r"[^\w\- ]", "", s))[:80]

def save(url, name, out):
    path = os.path.join(out, name + ".pdf")
    if os.path.exists(path):
        print("EXISTS", path); return
    data = get(url)
    if not data.startswith(b"%PDF"):
        print("NOT_PDF", url); return
    open(path, "wb").write(data); print("OK", path)

def main(q, out):
    os.makedirs(out, exist_ok=True)
    if re.fullmatch(r"\d{4}\.\d{4,5}(v\d+)?", q):
        return save("https://arxiv.org/pdf/" + q, "arXiv_" + q, out)
    sel = "select=display_name,publication_year,doi,best_oa_location,locations,ids"
    if re.match(r"^10\.\d{4,}/", q):
        w = json.loads(get("https://api.openalex.org/works/doi:" + q + "?" + sel))
    else:
        r = json.loads(get("https://api.openalex.org/works?per_page=1&" + sel + "&search=" + urllib.parse.quote(q)))
        w = (r.get("results") or [None])[0]
    if not w:
        print("NOT_FOUND", q); return
    pdf = (w.get("best_oa_location") or {}).get("pdf_url")
    if not pdf:
        for loc in w.get("locations") or []:
            if loc.get("is_oa") and loc.get("pdf_url"):
                pdf = loc["pdf_url"]; break
    if not pdf and (w.get("ids") or {}).get("arxiv"):
        pdf = w["ids"]["arxiv"].replace("abs", "pdf")
    if pdf:
        save(pdf, f'{w.get("publication_year")}_{safe(w.get("display_name",""))}', out)
    else:
        print(f'NO_OPEN_PDF {w.get("display_name")} ({w.get("publication_year")}) DOI {w.get("doi")}')

if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])

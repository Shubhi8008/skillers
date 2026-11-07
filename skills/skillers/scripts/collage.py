#!/usr/bin/env python3
"""collage.py : helper for skillers references mode.

  sheet   BOARD_DIR                 -> numbered contact sheet _sheet.jpg from _thumbs + *.json (for Claude to look at)
  palette BOARD_DIR id1 id2 ...     -> dominant colours of the picked thumbnails, written to _palette.json
  canvas  BOARD_DIR picks.json      -> Obsidian board.canvas + board.md from scored picks

picks.json: [{ "id","source","title","author","page","img","group","why","borrow","laws":[..],"avoid" }]
groups: "Top picks", "Layout", "Type and colour", "Motion", "Maybe"
"""
import json, sys, os, glob, math
from PIL import Image, ImageDraw, ImageFont

def load_items(board):
    items = []
    for f in sorted(glob.glob(os.path.join(board, "*.json"))):
        if os.path.basename(f).startswith(("_", "picks")):
            continue
        try:
            items += json.load(open(f, encoding="utf-8-sig"))
        except Exception:
            pass
    return items

def thumb_path(board, iid):
    p = os.path.join(board, "_thumbs", iid + ".img")
    return p if os.path.exists(p) else None

def sheet(board, cols=6, w=320, h=240):
    items = [i for i in load_items(board) if thumb_path(board, i["id"])]
    rows = math.ceil(len(items) / cols)
    S = Image.new("RGB", (cols * w, rows * (h + 22)), "white")
    d = ImageDraw.Draw(S)
    try:
        font = ImageFont.truetype("DejaVuSans-Bold.ttf", 16)
    except Exception:
        font = ImageFont.load_default()
    for k, it in enumerate(items):
        x, y = (k % cols) * w, (k // cols) * (h + 22)
        try:
            im = Image.open(thumb_path(board, it["id"])).convert("RGB")
            im.thumbnail((w - 6, h - 6))
            S.paste(im, (x + 3, y + 3))
        except Exception:
            d.rectangle([x + 3, y + 3, x + w - 3, y + h - 3], outline="red")
        d.rectangle([x + 3, y + h, x + w - 3, y + h + 20], fill="black")
        d.text((x + 8, y + h + 2), f'{it["id"]}  {it.get("title","")[:28]}', fill="white", font=font)
    out = os.path.join(board, "_sheet.jpg")
    S.save(out, quality=82)
    print(out, len(items), "items")

def palette(board, ids, k=6):
    px = []
    for iid in ids:
        p = thumb_path(board, iid)
        if not p:
            continue
        im = Image.open(p).convert("RGB").resize((80, 60))
        px += list(im.getdata())
    if not px:
        print("no pixels"); return
    q = Image.new("RGB", (len(px), 1)); q.putdata(px)
    pal = q.quantize(colors=k, method=Image.Quantize.MEDIANCUT)
    counts = sorted(pal.getcolors(), reverse=True)
    raw = pal.getpalette()
    cols = [{"hex": "#%02x%02x%02x" % tuple(raw[i * 3:i * 3 + 3]), "share": round(c / len(px), 3)} for c, i in counts]
    json.dump(cols, open(os.path.join(board, "_palette.json"), "w"), indent=1)
    print(json.dumps(cols))

def canvas(board, picks_file):
    picks = json.load(open(picks_file, encoding="utf-8-sig"))
    order = ["Top picks", "Layout", "Type and colour", "Motion", "Maybe"]
    groups = {g: [p for p in picks if p.get("group", "Maybe") == g] for g in order}
    nodes, edges = [], []
    card_w, card_h, gap = 360, 420, 30
    x0 = 0
    for g in order:
        lst = groups[g]
        if not lst:
            continue
        cols = 2 if len(lst) > 3 else 1
        gw = cols * card_w + (cols + 1) * gap
        gh = math.ceil(len(lst) / cols) * (card_h + gap) + gap + 40
        nodes.append({"id": "grp_" + g.replace(" ", "_"), "type": "group", "label": g,
                      "x": x0, "y": 0, "width": gw, "height": gh})
        for n, p in enumerate(lst):
            cx = x0 + gap + (n % cols) * (card_w + gap)
            cy = 40 + gap + (n // cols) * (card_h + gap)
            img_local = os.path.join("refs", os.path.basename(board), "_thumbs", p["id"] + ".img")
            img_md = f'![]({p["img"]})' if p.get("img") else ""
            laws = ", ".join(p.get("laws", []))
            text = (f'{img_md}\n\n**{p.get("title","")}**  \n'
                    f'[{p.get("source","")}]({p.get("page","")}) {("· " + p["author"]) if p.get("author") else ""}\n\n'
                    f'**Borrow:** {p.get("borrow","")}\n\n**Why:** {p.get("why","")}\n\n'
                    f'**Laws:** {laws}\n\n**Avoid:** {p.get("avoid","")}')
            nodes.append({"id": p["id"], "type": "text", "text": text,
                          "x": cx, "y": cy, "width": card_w, "height": card_h})
        x0 += gw + 80
    json.dump({"nodes": nodes, "edges": edges}, open(os.path.join(board, "board.canvas"), "w", encoding="utf-8"), indent=1)
    print("canvas", len(nodes), "nodes")

if __name__ == "__main__":
    cmd, board = sys.argv[1], sys.argv[2]
    if cmd == "sheet": sheet(board)
    elif cmd == "palette": palette(board, sys.argv[3:])
    elif cmd == "canvas": canvas(board, sys.argv[3])

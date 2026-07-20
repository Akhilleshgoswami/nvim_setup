import { FILES, RECENT, iconFor, formatSize, formatMtime } from "./data.js";
import { scoreItem, highlightHtml } from "./fuzzy.js";
import { highlightCode, findRelevantLine } from "./syntax.js";

const $ = (sel, root = document) => root.querySelector(sel);

const els = {
  overlay: $("#overlay"),
  input: $("#search-input"),
  rows: $("#rows"),
  results: $("#results-list"),
  rowHighlight: $("#row-highlight"),
  previewA: $("#preview-a"),
  previewB: $("#preview-b"),
  previewTitle: $("#preview-title"),
  previewMeta: $("#preview-meta"),
  previewIcon: $("#preview-icon"),
  count: $("#result-count"),
  launch: $("#launch"),
};

let state = {
  open: false,
  query: "",
  results: [],
  selected: 0,
  previewFlip: false,
  lastTopId: null,
  mouseIndex: -1,
};

/** @param {string} query */
function computeResults(query) {
  if (!query.trim()) {
    return RECENT.map((item) => ({
      item,
      score: item.mtime,
      indices: [],
      display: item.path,
      field: "recent",
      filename: item.path.split("/").pop(),
      dir: item.path.includes("/") ? item.path.slice(0, item.path.lastIndexOf("/")) : "",
    }));
  }

  return FILES.map((item) => scoreItem(query, item))
    .filter((r) => r.score >= 0)
    .sort((a, b) => b.score - a.score);
}

function pathHtml(result) {
  const { filename, dir, indices, field, display } = result;
  if (field === "file") {
    const name = highlightHtml(filename, indices);
    return `<span class="dir">${dir ? highlightHtml(dir + "/", [], "match") : ""}</span><span class="name">${name}</span>`;
  }
  if (field === "dir") {
    return `<span class="dir">${highlightHtml(dir + "/", indices)}</span><span class="name">${filename}</span>`;
  }
  const parts = display.split("/");
  const name = parts.pop();
  const prefix = parts.length ? parts.join("/") + "/" : "";
  return `<span class="dir">${highlightHtml(prefix, field === "path" ? indices : [])}</span><span class="name">${highlightHtml(name, field === "path" ? indices.filter((i) => i >= prefix.length) : [])}</span>`;
}

function renderResults(flip = true) {
  const prevRects = flip ? captureRects() : new Map();
  const { results, selected, query } = state;

  els.rows.innerHTML = "";

  if (query.trim() && results.length === 0) {
    els.rowHighlight.style.opacity = "0";
    els.rows.innerHTML = `
      <div class="no-results">
        <div class="radar"></div>
        <div class="title">No signal</div>
        <p>No files match <em>${query}</em></p>
      </div>`;
    updatePreview(null);
    updateStatus();
    return;
  }

  if (!query.trim() && results.length) {
    const label = document.createElement("div");
    label.className = "pane-label";
    label.textContent = "Recent files";
    els.rows.appendChild(label);
  }

  results.forEach((result, index) => {
    const row = document.createElement("div");
    row.className = "result-row";
    row.dataset.index = String(index);
    row.dataset.path = result.item.path;
    if (index === 0 && result.item.path !== state.lastTopId && query.trim()) {
      row.classList.add("top-match-ping");
      state.lastTopId = result.item.path;
    }
    row.innerHTML = `
      <div class="icon">${iconFor(result.item.path)}</div>
      <div class="path">${pathHtml(result)}</div>
      <div class="tag">${formatMtime(result.item.mtime)} · ${formatSize(result.item.size)}</div>`;

    row.addEventListener("mouseenter", () => {
      state.mouseIndex = index;
      setSelected(index, false);
    });

    els.rows.appendChild(row);
  });

  if (flip) animateFlip(prevRects);
  moveRowHighlight();
  updatePreview(results[selected]?.item ?? null);
  updateStatus();
}

function captureRects() {
  const map = new Map();
  els.rows.querySelectorAll(".result-row").forEach((row) => {
    map.set(row.dataset.path, row.getBoundingClientRect());
  });
  return map;
}

function animateFlip(prevRects) {
  requestAnimationFrame(() => {
    els.rows.querySelectorAll(".result-row").forEach((row) => {
      const prev = prevRects.get(row.dataset.path);
      if (!prev) {
        row.style.opacity = "0";
        row.style.transform = "translateY(6px)";
        requestAnimationFrame(() => {
          row.style.opacity = "1";
          row.style.transform = "translateY(0)";
        });
        return;
      }
      const next = row.getBoundingClientRect();
      const dy = prev.top - next.top;
      if (Math.abs(dy) < 1) return;
      row.style.transform = `translateY(${dy}px)`;
      row.style.transition = "transform 0s";
      requestAnimationFrame(() => {
        row.style.transition = "transform 280ms cubic-bezier(0.22, 1, 0.36, 1)";
        row.style.transform = "translateY(0)";
      });
    });
  });
}

function moveRowHighlight() {
  const row = els.rows.querySelector(`.result-row[data-index="${state.selected}"]`);
  if (!row) {
    els.rowHighlight.style.opacity = "0";
    return;
  }
  const top = els.rows.offsetTop + row.offsetTop;
  els.rowHighlight.style.opacity = "1";
  els.rowHighlight.style.height = `${row.offsetHeight}px`;
  els.rowHighlight.style.transform = `translateY(${top}px)`;
  row.scrollIntoView({ block: "nearest" });
}

/** @param {typeof FILES[0] | null} item */
function updatePreview(item) {
  const active = state.previewFlip ? els.previewB : els.previewA;
  const idle = state.previewFlip ? els.previewA : els.previewB;

  active.classList.remove("visible");
  idle.classList.add("visible");

  if (!item) {
    els.previewTitle.textContent = "Preview";
    els.previewMeta.textContent = "—";
    els.previewIcon.textContent = "◇";
    idle.innerHTML = `<div class="preview-empty">Pick a file to preview</div>`;
    state.previewFlip = !state.previewFlip;
    return;
  }

  const filename = item.path.split("/").pop();
  els.previewTitle.textContent = filename;
  els.previewTitle.title = item.path;
  els.previewMeta.textContent = `${formatSize(item.size)} · ${formatMtime(item.mtime)}`;
  els.previewIcon.textContent = iconFor(item.path);

  const line = findRelevantLine(item.content, state.query);
  const lines = item.content.split("\n");
  const htmlLines = lines.map((ln, i) => {
    const hl = highlightCode(ln, item.lang);
    if (i === line && state.query.trim()) {
      return `<span class="line-marker">${hl || " "}</span>`;
    }
    return hl;
  });

  idle.innerHTML = `<pre>${htmlLines.join("\n")}</pre>`;

  requestAnimationFrame(() => {
    const marker = idle.querySelector(".line-marker");
    if (marker) marker.scrollIntoView({ block: "center" });
    else idle.scrollTop = 0;
  });

  state.previewFlip = !state.previewFlip;
}

function updateStatus() {
  const total = state.query.trim() ? FILES.length : RECENT.length;
  const shown = state.results.length;
  const idx = state.results.length ? state.selected + 1 : 0;
  els.count.innerHTML = shown
    ? `<strong>${idx}</strong> / ${shown}${state.query.trim() ? ` · ${total} indexed` : ""}`
    : "0 results";
}

function setSelected(index, scroll = true) {
  state.selected = Math.max(0, Math.min(index, Math.max(0, state.results.length - 1)));
  if (scroll) moveRowHighlight();
  updatePreview(state.results[state.selected]?.item ?? null);
  updateStatus();
}

function onInput() {
  state.query = els.input.value;
  state.selected = 0;
  state.mouseIndex = -1;
  state.results = computeResults(state.query);
  renderResults(true);
}

function openPalette() {
  state.open = true;
  state.query = "";
  state.selected = 0;
  state.lastTopId = null;
  state.results = computeResults("");
  els.input.value = "";
  els.overlay.classList.add("open");
  document.body.classList.add("demo-open");
  renderResults(false);
  requestAnimationFrame(() => els.input.focus());
}

function closePalette() {
  state.open = false;
  els.overlay.classList.remove("open");
  document.body.classList.remove("demo-open");
}

function onKeyDown(e) {
  if (!state.open) {
    if ((e.ctrlKey || e.metaKey) && e.key === "p") {
      e.preventDefault();
      openPalette();
    }
    return;
  }

  if (e.key === "Escape") {
    e.preventDefault();
    closePalette();
    return;
  }

  if (e.key === "ArrowDown" || (e.ctrlKey && e.key === "j")) {
    e.preventDefault();
    setSelected(state.selected + 1);
    return;
  }

  if (e.key === "ArrowUp" || (e.ctrlKey && e.key === "k")) {
    e.preventDefault();
    setSelected(state.selected - 1);
    return;
  }

  if (e.key === "Enter") {
    e.preventDefault();
    const item = state.results[state.selected]?.item;
    if (item) {
      closePalette();
      console.info("[demo] open", item.path);
    }
  }
}

els.launch.addEventListener("click", openPalette);
els.input.addEventListener("input", onInput);
document.addEventListener("keydown", onKeyDown);
els.overlay.addEventListener("click", (e) => {
  if (e.target === els.overlay) closePalette();
});

window.__palette = { open: openPalette, close: closePalette };

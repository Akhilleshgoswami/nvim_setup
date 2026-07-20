/** Lightweight fuzzy scorer — instant subsequence match with highlight indices. */

/**
 * @param {string} query
 * @param {string} text
 * @returns {{ score: number, indices: number[] }}
 */
export function fuzzyMatch(query, text) {
  const q = query.toLowerCase();
  const t = text.toLowerCase();
  if (!q) return { score: 1, indices: [] };
  if (q.length > t.length) return { score: -1, indices: [] };

  let qi = 0;
  let score = 0;
  let last = -1;
  const indices = [];

  for (let i = 0; i < t.length && qi < q.length; i++) {
    if (t[i] !== q[qi]) continue;
    indices.push(i);
    score += 10;
    if (last === i - 1) score += 14;
    if (i === 0 || "/._-".includes(t[i - 1])) score += 12;
    if (t[i] === q[qi] && text[i] === q[qi]) score += 2;
    last = i;
    qi++;
  }

  if (qi < q.length) return { score: -1, indices: [] };
  score -= (t.length - q.length) * 0.4;
  score -= indices[0] * 0.15;
  return { score, indices };
}

/**
 * @param {string} query
 * @param {{ path: string }} item
 */
export function scoreItem(query, item) {
  const filename = item.path.split("/").pop() ?? item.path;
  const dir = item.path.includes("/") ? item.path.slice(0, item.path.lastIndexOf("/")) : "";

  const file = fuzzyMatch(query, filename);
  const full = fuzzyMatch(query, item.path);
  const dirMatch = dir ? fuzzyMatch(query, dir) : { score: -1, indices: [] };

  let best = file.score >= full.score ? { ...file, field: "file", text: filename } : { ...full, field: "path", text: item.path };
  if (dirMatch.score > best.score) best = { ...dirMatch, field: "dir", text: dir };

  return {
    item,
    score: best.score,
    indices: best.indices,
    display: best.text,
    field: best.field,
    filename,
    dir,
  };
}

/**
 * @param {string} text
 * @param {number[]} indices
 * @param {string} wrapClass
 */
export function highlightHtml(text, indices, wrapClass = "match") {
  if (!indices.length) return escapeHtml(text);
  const set = new Set(indices);
  let out = "";
  for (let i = 0; i < text.length; i++) {
    const ch = escapeHtml(text[i]);
    if (set.has(i)) {
      out += `<span class="${wrapClass}">${ch}</span>`;
    } else {
      out += ch;
    }
  }
  return out;
}

export function escapeHtml(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

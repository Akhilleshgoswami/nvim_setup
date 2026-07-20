import { escapeHtml } from "./fuzzy.js";

const RULES = [
  { re: /(\/\/.*$|#.*$|--.*$)/gm, cls: "cm-comment" },
  { re: /("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/g, cls: "cm-string" },
  { re: /\b(import|export|from|return|async|await|function|const|let|var|class|interface|type|if|else|throw|new|require|local|return|end)\b/g, cls: "cm-keyword" },
  { re: /\b(\d+\.?\d*)\b/g, cls: "cm-number" },
  { re: /\b([A-Z][a-zA-Z0-9_]*)\b/g, cls: "cm-type" },
];

/**
 * @param {string} code
 * @param {string} lang
 */
export function highlightCode(code, lang) {
  let html = escapeHtml(code);
  if (lang === "json") {
    html = html.replace(/"([^"]+)":/g, '<span class="cm-key">"$1"</span>:');
    html = html.replace(/: "([^"]*)"/g, ': <span class="cm-string">"$1"</span>');
    html = html.replace(/: (\d+)/g, ': <span class="cm-number">$1</span>');
    return html;
  }
  if (lang === "markdown") {
    return html
      .replace(/^# (.+)$/gm, '<span class="cm-heading"># $1</span>')
      .replace(/`([^`]+)`/g, '<span class="cm-string">`$1`</span>');
  }
  for (const { re, cls } of RULES) {
    html = html.replace(re, (m) => `<span class="${cls}">${m}</span>`);
  }
  return html;
}

/**
 * @param {string} code
 * @param {string} query
 */
export function findRelevantLine(code, query) {
  if (!query.trim()) return 0;
  const lines = code.split("\n");
  let best = { line: 0, score: -1 };
  for (let i = 0; i < lines.length; i++) {
    const lower = lines[i].toLowerCase();
    if (lower.includes(query.toLowerCase())) {
      const score = 100 - i;
      if (score > best.score) best = { line: i, score };
    }
  }
  return best.line;
}

/** Demo dataset — 20 fake project files with content for preview. */
export const FILES = [
  {
    path: "src/modules/auth/services/authService.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 12,
    size: 4821,
    content: `import { hashPassword, verifyToken } from "./crypto";
import { UserRepository } from "../repositories/userRepo";

export class AuthService {
  constructor(private users: UserRepository) {}

  async login(email: string, password: string) {
    const user = await this.users.findByEmail(email);
    if (!user || !(await hashPassword.verify(password, user.hash))) {
      throw new Error("Invalid credentials");
    }
    return verifyToken.issue({ sub: user.id, role: user.role });
  }

  async refresh(sessionId: string) {
    return verifyToken.rotate(sessionId);
  }
}`,
  },
  {
    path: "src/modules/user/services/userService.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 60 * 3,
    size: 3910,
    content: `export async function getProfile(id: string) {
  const row = await db.query("SELECT * FROM users WHERE id = $1", [id]);
  return mapUser(row);
}

export async function updateProfile(id: string, patch: ProfilePatch) {
  await db.query("UPDATE users SET name = $1 WHERE id = $2", [patch.name, id]);
}`,
  },
  {
    path: "src/shared/utils/logger.js",
    lang: "javascript",
    mtime: Date.now() - 1000 * 60 * 60 * 26,
    size: 1240,
    content: `const levels = { debug: 0, info: 1, warn: 2, error: 3 };

export function createLogger(scope) {
  return levels.keys.reduce((acc, level) => {
    acc[level] = (...args) => {
      if (levels[level] >= levels.info) {
        console[level](\`[\${scope}]\`, ...args);
      }
    };
    return acc;
  }, {});
}`,
  },
  {
    path: "src/bootstrap.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 60 * 48,
    size: 2104,
    content: `import dotenv from "dotenv";
import { createServer } from "./server";
import { logger } from "@shared/utils/logger";

dotenv.config();

async function main() {
  const app = await createServer();
  app.listen(process.env.PORT ?? 3000, () => {
    logger.info("listening");
  });
}

main().catch((err) => {
  logger.error("bootstrap failed", err);
  process.exit(1);
});`,
  },
  {
    path: "package.json",
    lang: "json",
    mtime: Date.now() - 1000 * 60 * 60 * 72,
    size: 892,
    content: `{
  "name": "umbra-app",
  "version": "0.12.0",
  "scripts": {
    "dev": "tsx watch src/bootstrap.ts",
    "build": "tsc -p tsconfig.json",
    "test": "vitest run"
  },
  "dependencies": {
    "dotenv": "^16.4.5"
  }
}`,
  },
  {
    path: "README.md",
    lang: "markdown",
    mtime: Date.now() - 1000 * 60 * 60 * 96,
    size: 1560,
    content: `# Umbra

A handcrafted Neovim environment with a distinctive terminal-glass palette.

## Quick start

\`\`\`bash
nvim .
\`\`\`

## Features

- Fuzzy finder with live preview
- Modular Lua configuration
- Theme-aware UI components`,
  },
  {
    path: "docker-compose.yml",
    lang: "yaml",
    mtime: Date.now() - 1000 * 60 * 60 * 120,
    size: 640,
    content: `services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://app:app@db:5432/app
  db:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:`,
  },
  {
    path: "lua/plugins/navigation.lua",
    lang: "lua",
    mtime: Date.now() - 1000 * 60 * 8,
    size: 5200,
    content: `return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    },
  },
}`,
  },
  {
    path: "lua/features/runner.lua",
    lang: "lua",
    mtime: Date.now() - 1000 * 60 * 45,
    size: 2890,
    content: `local M = {}

function M.run(cmd, opts)
  opts = opts or {}
  vim.system(cmd, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.notify(obj.stderr, vim.log.levels.ERROR)
      return
    end
    if opts.on_stdout then opts.on_stdout(obj.stdout) end
  end)
end

return M`,
  },
  {
    path: "lua/themes/umbra/palette.lua",
    lang: "lua",
    mtime: Date.now() - 1000 * 60 * 60 * 5,
    size: 3400,
    content: `local M = {}

M.bg = {
  base = "#1A1E27",
  float = "#252B3B",
  active = "#2F3850",
}

M.fg = {
  base = "#E5E9F0",
  muted = "#8B95A7",
}

return M`,
  },
  {
    path: "colors/umbra.lua",
    lang: "lua",
    mtime: Date.now() - 1000 * 60 * 60 * 6,
    size: 180,
    content: `require("themes.umbra").apply()`,
  },
  {
    path: "docs/MIGRATION.md",
    lang: "markdown",
    mtime: Date.now() - 1000 * 60 * 60 * 200,
    size: 4200,
    content: `# Migration guide

Move your old init.vim settings into \`lua/\` modules.

## Telescope

Use \`:Telescope find_files\` after lazy-load completes.`,
  },
  {
    path: "src/server/routes/health.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 60 * 14,
    size: 512,
    content: `import { Router } from "express";

export const health = Router();

health.get("/", (_req, res) => {
  res.json({ ok: true, uptime: process.uptime() });
});`,
  },
  {
    path: "src/server/middleware/cors.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 60 * 30,
    size: 780,
    content: `export function cors(allowed: string[]) {
  return (req, res, next) => {
    const origin = req.headers.origin;
    if (origin && allowed.includes(origin)) {
      res.setHeader("Access-Control-Allow-Origin", origin);
    }
    next();
  };
}`,
  },
  {
    path: "tests/auth/login.spec.ts",
    lang: "typescript",
    mtime: Date.now() - 1000 * 60 * 60 * 18,
    size: 1340,
    content: `import { describe, it, expect } from "vitest";
import { AuthService } from "../../src/modules/auth/services/authService";

describe("login", () => {
  it("returns a token for valid credentials", async () => {
    const svc = new AuthService(fakeRepo);
    const token = await svc.login("a@b.c", "secret");
    expect(token).toBeTruthy();
  });
});`,
  },
  {
    path: "tests/fixtures/users.json",
    lang: "json",
    mtime: Date.now() - 1000 * 60 * 60 * 40,
    size: 320,
    content: `[
  { "id": "u1", "email": "dev@umbra.local", "role": "admin" },
  { "id": "u2", "email": "guest@umbra.local", "role": "viewer" }
]`,
  },
  {
    path: "public/index.html",
    lang: "html",
    mtime: Date.now() - 1000 * 60 * 60 * 80,
    size: 960,
    content: `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Umbra</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>`,
  },
  {
    path: "scripts/sync-dotfiles.sh",
    lang: "shell",
    mtime: Date.now() - 1000 * 60 * 60 * 55,
    size: 410,
    content: `#!/usr/bin/env bash
set -euo pipefail
rsync -av --delete ./nvim/ "$HOME/.config/nvim/"`,
  },
  {
    path: ".github/workflows/ci.yml",
    lang: "yaml",
    mtime: Date.now() - 1000 * 60 * 60 * 22,
    size: 1180,
    content: `name: ci
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test`,
  },
  {
    path: "tsconfig.json",
    lang: "json",
    mtime: Date.now() - 1000 * 60 * 60 * 100,
    size: 540,
    content: `{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "strict": true,
    "rootDir": "src",
    "outDir": "dist"
  },
  "include": ["src", "tests"]
}`,
  },
];

export const RECENT = [...FILES]
  .sort((a, b) => b.mtime - a.mtime)
  .slice(0, 8);

export function iconFor(path) {
  const ext = path.split(".").pop()?.toLowerCase() ?? "";
  const map = {
    ts: "TS",
    js: "JS",
    lua: "Lua",
    md: "Md",
    json: "{ }",
    yml: "Yml",
    yaml: "Yml",
    html: "◇",
    sh: "$",
  };
  return map[ext] ?? "·";
}

export function formatSize(bytes) {
  if (bytes < 1024) return `${bytes} B`;
  return `${(bytes / 1024).toFixed(1)} KB`;
}

export function formatMtime(ts) {
  const mins = Math.floor((Date.now() - ts) / 60000);
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 48) return `${hrs}h ago`;
  return `${Math.floor(hrs / 24)}d ago`;
}

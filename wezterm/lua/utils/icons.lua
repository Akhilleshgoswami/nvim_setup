-- Single glyph language for process / status chrome.

local M = {}

M.process = {
  nvim = "",
  vim = "",
  zsh = "󰞷",
  bash = "",
  fish = "",
  node = "󰎙",
  npm = "󰎙",
  pnpm = "󰎙",
  yarn = "󰎙",
  docker = "󰡨",
  python = "",
  go = "",
  rust = "",
  cargo = "",
  lazygit = "󰊢",
  git = "󰊢",
  lua = "",
  ssh = "󰣀",
  default = "󰆍",
}

M.ui = {
  folder = "󰉋",
  branch = "",
  clock = "󰥔",
  battery = "󰁹",
  battery_charging = "󰂄",
  host = "󰒋",
  workspace = "󰉼",
  separator = "│",
}

return M

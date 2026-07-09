# Flutter Tools (Dart)

## Why it exists

`nvim-flutter/flutter-tools.nvim` provides Dart/Flutter LSP, widget guides, and dev tooling when editing `ft=dart` files — beyond what generic `ts_ls` offers.

## Features

- Flutter/Dart LSP via flutter-tools (loads on `ft = dart`)
- Color rendering in widget trees
- Todo highlighting in Dart code
- Auto-complete function call parentheses
- Integrates with mason-lspconfig stack

## Configuration

`lua/plugins/dart.lua`

Lazy-loads only for `dart` filetype.

## Commands

Flutter-tools exposes commands dynamically — common ones:

| Command | Action |
|---------|--------|
| `:FlutterRun` | Run Flutter app |
| `:FlutterDevices` | List devices |
| `:FlutterLog` | Open Flutter log |
| `:DartFmt` | Format Dart file |

Run `:Flutter` and tab-complete for full list after opening a Dart file.

## Keymaps

No custom keymaps in this config. Standard LSP keymaps apply when attached (`gd`, `K`, `Space ca`, etc.).

## Usage

Open a `.dart` file in a Flutter project — LSP attaches automatically. Use `gd` for definition, Flutter outline via Snacks `Space ss` (document symbols).

## Troubleshooting

- **LSP not starting:** Install Flutter SDK and ensure `flutter` is in PATH.
- **Wrong root:** Open project at pubspec.yaml level.
- **Conflict with other Dart LSP:** Only flutter-tools should manage Dart — don't enable separate `dartls` manually.

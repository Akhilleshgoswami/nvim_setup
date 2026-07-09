# Spider (nvim-spider)

## Why it exists

`chrisgrieser/nvim-spider` replaces `w`, `e`, `b`, `ge` with smarter word motions — camelCase-aware, punctuation-sensitive, consistent in operator-pending mode.

## Features

- Subword movement (`helloWorld` → `hello` | `World`)
- `skipInsignificantPunctuation = false` — punctuation counts
- `consistentOperatorPending = true` — `o`/`x` modes behave like normal
- Overrides default `w`/`e`/`b`/`ge` globally

## Configuration

`lua/plugins/spider.lua`

## Commands

None.

## Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `w` | n, o, x | Spider forward word |
| `e` | n, o, x | Spider end of word |
| `b` | n, o, x | Spider backward word |
| `ge` | n, o, x | Spider backward end |

## Usage

Use `w`/`e`/`b` as normal — spider handles camelCase and symbols automatically. In operator mode (`daw` etc.), spider motions apply consistently.

## Troubleshooting

- **Feels different from Vim:** Expected — punctuation and camelCase boundaries differ.
- **Too granular in snake_case:** Subword mode splits on underscores too; adjust `subwordMovement` in opts if needed.
- **Plugin not active:** Lazy-loads on `VeryLazy` — should be active after startup.

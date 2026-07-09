# Groq AI (groq-nvim)

## Why it exists

`cdreetz/groq-nvim` integrates the Groq LLM API for inline code generation and editing — generate at cursor, rewrite selections, or use file context.

## Features

- Groq API via `GROQ_API_KEY` environment variable
- Model: `llama3-70b-8192`
- Generate, edit, and context-aware generate commands
- Lazy-loaded on `VeryLazy`

## Configuration

`lua/plugins/gorq-ai.lua`

```lua
api_key = vim.env.GROQ_API_KEY
model = "llama3-70b-8192"
```

## Commands

| Command | Action |
|---------|--------|
| `:GroqGenerate <prompt>` | Generate code at cursor |
| `:GroqGenerateWithContext <prompt> <file>` | Generate using file context |
| `:GroqEdit <prompt>` | Rewrite visual selection |

### Examples

```
:GroqGenerate write a python function that prints hello world
:GroqEdit add error handling and logging
:GroqGenerateWithContext refactor this method ./src/utils.lua
```

## Keymaps

No default keymaps in this config. Bind commands manually if desired:

```lua
vim.keymap.set("v", "<leader>gi", ":GroqEdit ", { desc = "Groq edit selection" })
```

## Usage

1. Export API key: `export GROQ_API_KEY=gsk_...`
2. Visual-select code → `:GroqEdit improve readability`
3. Or at cursor → `:GroqGenerate create a REST handler for GET /users`

## Troubleshooting

- **API errors:** Verify `echo $GROQ_API_KEY` is set in the shell Neovim inherits.
- **Model deprecated:** Update `model` in `gorq-ai.lua` to a current Groq model name.
- **Slow response:** Large prompts/context increase latency; trim context file size.

-- Inline image viewing (WezTerm / Kitty / Sixel) + markdown embeds.

local viewer = require("features.image_viewer")

return {
  {
    "3rd/image.nvim",
    build = false,
    cmd = { "ImageReport" },
    ft = {
      "markdown", "png", "jpg", "jpeg", "gif", "webp", "avif", "bmp", "svg", "ico", "tiff", "tif",
    },
    keys = {
      { "<leader>vi", function() viewer.preview_cursor() end, desc = "View image under cursor" },
      { "<leader>vI", function() viewer.preview_file() end, desc = "View current image file" },
      { "<leader>vr", "<cmd>ImageReport<cr>", desc = "Image.nvim diagnostics" },
    },
    opts = function()
      local backend = viewer.detect_backend()
      return {
        backend = backend,
        processor = "magick_cli",
        max_height_window_percentage = 80,
        max_width_window_percentage = 90,
        scale_factor = 1.0,
        window_overlap_clear_enabled = true,
        editor_only_render_when_focused = true,
        hijack_file_patterns = {
          "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif",
          "*.bmp", "*.svg", "*.ico", "*.tiff", "*.tif",
        },
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = "popup",
            floating_windows = true,
            filetypes = { "markdown", "vimwiki", "quarto" },
          },
          asciidoc = {
            enabled = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = "popup",
          },
        },
      }
    end,
    config = function(_, opts)
      local missing = viewer.check_deps()
      if #missing > 0 then
        vim.notify(
          "image.nvim: install " .. table.concat(missing, ", ") .. " then restart Neovim",
          vim.log.levels.WARN
        )
      end

      require("image").setup(opts)

      vim.api.nvim_create_user_command("ImageView", function(args)
        viewer.preview(args.args ~= "" and args.args or nil, { float = true })
      end, {
        nargs = "?",
        complete = "file",
        desc = "Preview an image file in a float",
      })
    end,
  },
}

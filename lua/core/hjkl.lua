-- Credits to https://github.com/folke/dot (enhanced)
local id
local lockout_timer = nil

for _, key in ipairs({ "h", "j", "k", "l" }) do
  local count = 0
  local messages = {
    [10] = { msg = "Easy there...",                          icon = "🤨" },
    [15] = { msg = "Use motions, not arrow keys with letters!", icon = "😤" },
    [20] = { msg = "w, b, e, f, t exist. Use them.",         icon = "📚" },
    [25] = { msg = "I'm serious. Stop.",                     icon = "😠" },
    [30] = { msg = "ONE MORE AND I LOCK YOU OUT.",           icon = "🚨" },
    [31] = { msg = "That's it. No hjkl for 10 seconds.",     icon = "🔒" },
  }

  vim.keymap.set("n", key, function()
    if lockout_timer then
      vim.notify("LOCKED. Think about what you've done.", vim.log.levels.ERROR, {
        icon = "⛔",
        replace = id,
        keep = function() return lockout_timer ~= nil end,
      })
      return ""
    end

    count = count + 1
    vim.defer_fn(function() count = math.max(0, count - 1) end, 5000)

    local msg_data = messages[count]
    if msg_data then
      id = vim.notify(msg_data.msg, vim.log.levels.WARN, {
        icon = msg_data.icon,
        replace = id,
        keep = function() return count >= 10 end,
      })

      -- lockout at 31
      if count >= 31 then
        lockout_timer = vim.defer_fn(function()
          lockout_timer = nil
          count = 0
          vim.notify("Fine. But use proper motions next time.", vim.log.levels.INFO, {
            icon = "🧙",
          })
        end, 10000) -- 10 second lockout
        return ""
      end
    end

    return key
  end, { expr = true })
end

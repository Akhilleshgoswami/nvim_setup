-- ============================================================
--  lua/akhilesh/plugins/spider.lua
-- ============================================================

return {
  "chrisgrieser/nvim-spider",
  event = "VeryLazy",

  opts = {
    skipInsignificantPunctuation = false,
    consistentOperatorPending    = true,  -- o/x behave like n for w/e/b
    subwordMovement              = true,  -- treat camelCase parts as words
  },

  keys = {
    { "w",  function() require("spider").motion("w")  end, mode = { "n", "o", "x" }, desc = "Spider w"  },
    { "e",  function() require("spider").motion("e")  end, mode = { "n", "o", "x" }, desc = "Spider e"  },
    { "b",  function() require("spider").motion("b")  end, mode = { "n", "o", "x" }, desc = "Spider b"  },
    { "ge", function() require("spider").motion("ge") end, mode = { "n", "o", "x" }, desc = "Spider ge" },
  },
}

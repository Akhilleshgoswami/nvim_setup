-- Compat shim. The canonical glyph language now lives in umbra.icons; this
-- keeps existing `require("utils.icons")` call sites working.
return require("umbra.icons")

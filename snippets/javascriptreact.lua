local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


return {


-- Full React component
s("rfc", {

t("import React from 'react';"),

t({"",""}),

t("export default function "),
i(1,"Component"),

t({"(){",""}),

t({"  return (",""}),

t({"    <div>",""}),

t({"    </div>",""}),

t({"  )",""}),

t("}")

}),



-- useState ONLY
s("us", {

t("const ["),

i(1,"state"),

t(", set"),

i(2,"State"),

t("] = useState("),

i(3),

t(")")

}),



-- useEffect ONLY
s("ue", {

t({
"useEffect(()=>{",
"",
"} ,[])"
})

}),



-- useRef ONLY
s("ur", {

t("const "),

i(1,"ref"),

t(" = useRef(null)")

}),



-- Hook imports
s("rihooks", {

t("import { useState, useEffect, useRef } from 'react';")

}),



-- React import
s("ri", {

t("import React from 'react';")

}),



-- Tailwind div
s("tw", {

t('<div className="'),

i(1),

t('">'),

i(2),

t("</div>")

}),



-- Tailwind flex
s("flex", {

t('<div className="flex items-center justify-center">'),

i(1),

t("</div>")

})

}

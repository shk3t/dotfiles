local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local sql_generic_snippets = {
  -- select all
  s("sa", fmt("select *\nfrom {}", { i(1) })),
}

ls.add_snippets("sql", sql_generic_snippets)
ls.add_snippets("mysql", sql_generic_snippets)

ls.add_snippets("markdown", {
  s("jp", fmt("```python\n{}\n```", { i(1) })),
})

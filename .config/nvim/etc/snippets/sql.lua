local ls = require("luasnip")


-- ls.add_snippets("tex", {[27;5;106~	-- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many[27;5;106~	-- \item as necessary by utilizing a choiceNode.[27;5;106~	s("ls", {[27;5;106~		t({ "\\begin{itemize}", "\t\\item " }),[27;5;106~		i(1),[27;5;106~		d(2, rec_ls, {}),[27;5;106~		t({ "", "\\end{itemize}" }),[27;5;106~	}),[27;5;106~}, {[27;5;106~	key = "tex",[27;5;106~})
--
--
--
-- *cmp.setup* (config: cmp.ConfigSchema)[27;5;106~  Setup global configuration. See configuration options.[27;5;106~

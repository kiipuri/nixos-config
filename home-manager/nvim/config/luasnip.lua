local ls = require("luasnip")
local snippet = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("typescript", {
    snippet("exd", {
        t("export default "),
    }),
    snippet("<>", {
        t("<>"),
        i(1),
        t("</>"),
    }),
})

ls.filetype_extend("typescriptreact", { "typescript" })

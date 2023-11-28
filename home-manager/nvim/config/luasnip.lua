local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

ls.add_snippets("typescript", {
    snippet("exd", {
        text("export default "),
    }),
})

ls.filetype_extend("typescriptreact", { "typescript" })

vim.diagnostic.config({ virtual_text = false })

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- lualine

local sl_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = sl_hl.background })
vim.api.nvim_set_hl(0, "SLTermIcon", { fg = "#b668cd", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLBranchName", { fg = "#abb2bf", bg = sl_hl.background, bold = false })
vim.api.nvim_set_hl(0, "SLProgress", { fg = "#b668cd", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLLocation", { fg = "#519fdf", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLFilename", { fg = "#009933", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLFT", { fg = "#46a6b2", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLIndent", { fg = "#c18a56", bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLLSP", { fg = "#6b727f", bg = sl_hl.background })
vim.api.nvim_set_hl(0, "SLSep", { fg = colors.base02, bg = "NONE" })
vim.api.nvim_set_hl(0, "SLFG", { fg = "#abb2bf", bg = sl_hl.background })
-- vim.api.nvim_set_hl(0, "SLSeparator", { fg = colors.base02, bg = sl_hl.background, italic = true })
vim.api.nvim_set_hl(0, "SLSeparator", { fg = "#6b727f", bg = sl_hl.background, italic = true })
-- vim.api.nvim_set_hl(0, "SLError", { fg = "#bf616a", bg = sl_hl.background })
-- vim.api.nvim_set_hl(0, "SLWarning", { fg = "#D7BA7D", bg = sl_hl.background })
vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = sl_hl.background })

local left_pad = {
    function()
        return " "
    end,
    padding = 0,
    color = function()
        return { fg = colors.base02, bg = "NONE" }
    end,
}

local right_pad = {
    function()
        return " "
    end,
    padding = 0,
    color = function()
        return { fg = colors.base02, bg = "NONE" }
    end,
}

local space = {
    function()
        return " "
    end,
    padding = 0,
}

M = {}
function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

hl_str = function(str, hl)
    return "%#" .. hl .. "#" .. str .. "%*"
end

language_servers = {
    function()
        local buf_ft = vim.bo.filetype
        local ui_filetypes = {
            "help",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "DressingSelect",
            "TelescopePrompt",
            "lspinfo",
            "lsp-installer",
            "",
        }

        if contains(ui_filetypes, buf_ft) then
            if M.language_servers == nil then
                return ""
            else
                return M.language_servers
            end
        end

        local clients = vim.lsp.buf_get_clients()
        local client_names = {}
        local copilot_active = false

        -- add client
        for _, client in pairs(clients) do
            if client.name ~= "copilot" and client.name ~= "null-ls" then
                table.insert(client_names, client.name)
            end
            if client.name == "copilot" then
                copilot_active = true
            end
        end

        -- add formatter
        local s = require("null-ls.sources")
        local available_sources = s.get_available(buf_ft)
        local registered = {}
        for _, source in ipairs(available_sources) do
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end

        local formatter = registered["NULL_LS_FORMATTING"]
        local linter = registered["NULL_LS_DIAGNOSTICS"]
        if formatter ~= nil then
            vim.list_extend(client_names, formatter)
        end
        if linter ~= nil then
            vim.list_extend(client_names, linter)
        end

        -- join client names with commas
        local client_names_str = table.concat(client_names, ", ")

        -- check client_names_str if empty
        local language_servers = ""
        local client_names_str_len = #client_names_str
        if client_names_str_len ~= 0 then
            language_servers = hl_str("", "SLSep")
                .. hl_str(client_names_str, "SLSeparator")
                .. hl_str("", "SLSep")
        end
        if copilot_active then
            language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
        end

        -- check client_names_str if empty
        local language_servers = ""
        local client_names_str_len = #client_names_str
        if client_names_str_len ~= 0 then
            language_servers = hl_str("", "SLSep")
                .. hl_str(client_names_str, "SLSeparator")
                .. hl_str("", "SLSep")
        end
        if copilot_active then
            language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
        end

        if client_names_str_len == 0 and not copilot_active then
            return ""
        else
            M.language_servers = language_servers
            return language_servers:gsub(", anonymous source", "")
        end
    end,
    padding = 0,
    cond = hide_in_width,
}

local mode_color = {
    n = "#519fdf",
    i = "#c18a56",
    v = "#b668cd",
    V = "#b668cd",
    -- c = '#B5CEA8',
    -- c = '#D7BA7D',
    c = "#46a6b2",
    no = "#D16D9E",
    s = "#88b369",
    S = "#c18a56",
    ic = "#d05c65",
    R = "#D16D9E",
    Rv = "#d05c65",
    cv = "#519fdf",
    ce = "#519fdf",
    r = "#d05c65",
    rm = "#46a6b2",
    ["r?"] = "#46a6b2",
    ["!"] = "#46a6b2",
    t = "#d05c65",
}

local mode = {
    -- mode component
    function()
        -- return "▊"
        return " "
        -- return "  "
    end,
    color = function()
        -- auto change color according to neovims mode
        return { fg = mode_color[vim.fn.mode()], bg = colors.base02 }
    end,
    padding = 0,
}

vim.api.nvim_set_hl(0, "SLError", { fg = colors.base08, bg = colors.base02 })
vim.api.nvim_set_hl(0, "SLWarning", { fg = colors.base0E, bg = colors.base02 })
local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = {
        error = "%#SLError#" .. "" .. "%*" .. " ",
        warn = "%#SLWarning#" .. "" .. "%*" .. " ",
    },
    colored = false,
    update_in_insert = false,
    always_visible = true,
    padding = 0,
}

local spaces = {
    function()
        local buf_ft = vim.bo.filetype

        local ui_filetypes = {
            "help",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "DressingSelect",
            "",
        }
        local space = ""

        if contains(ui_filetypes, buf_ft) then
            space = " "
        end

        local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")

        if shiftwidth == nil then
            return ""
        end

        -- TODO: update codicons and use their indent
        return hl_str(" " .. shiftwidth .. space, "SLIndent")
    end,
    padding = 0,
    -- separator = "%#SLSeparator#" .. " │" .. "%*",
    -- cond = hide_in_width_100,
}

local filetype = {
    "filetype",
    fmt = function(str)
        local ui_filetypes = {
            "help",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "DressingSelect",
            "",
            "nil",
        }

        local return_val = function(str)
            return hl_str(str, "SLFT")
        end

        if str == "TelescopePrompt" then
            return return_val(icons.ui.Telescope)
        end

        local function get_term_num()
            local t_status_ok, toggle_num = pcall(vim.api.nvim_buf_get_var, 0, "toggle_number")
            if not t_status_ok then
                return ""
            end
            return toggle_num
        end

        if str == "toggleterm" then
            -- 
            local term = "%#SLTermIcon#" .. " " .. "%*" .. "%#SLFT#" .. get_term_num() .. "%*"

            return return_val(term)
        end

        if contains(ui_filetypes, str) then
            return ""
        else
            return return_val(str)
        end
        return return_val(str)
    end,
    icons_enabled = false,
    padding = 0,
}

local filename = {
    "filename",
    fmt = function(str)
        -- return "▊"
        return hl_str(str, "SLFilename")
        -- return "  "
    end,
    padding = 0,
}

local progress = {
    "progress",
    fmt = function(str)
        -- return "▊"
        return hl_str("%P/%L", "SLProgress")
        -- return "  "
    end,
    -- color = "SLProgress",
    padding = 0,
}

local branch = {
    "branch",
    icons_enabled = true,
    icon = "%#SLGitIcon#" .. " " .. "%*" .. "%#SLBranchName#",
    -- color = "Constant",
    colored = false,
    padding = 0,
    -- cond = hide_in_width_100,
    fmt = function(str)
        if str == "" or str == nil then
            return "!=vcs"
        end

        return str
    end,
}

require("lualine").setup({
    options = {
        theme = "base16",
        -- sectionSeparators = { left = "", right = "" },
        -- componentSeparators = { left = "", right = "" },
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_a = { left_pad, mode, branch, right_pad },
        lualine_b = { left_pad, diagnostics, right_pad },
        lualine_c = { left_pad, filename, right_pad },
        lualine_d = { left_pad, spaces, right_pad },
        lualine_x = { language_servers, space, left_pad, spaces, right_pad },
        lualine_y = { left_pad, filetype, right_pad },
        lualine_z = { left_pad, progress, right_pad },
    },
})

vim.api.nvim_set_hl(0, "lualine_c_normal", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_insert", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_visual", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_terminal", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_replace", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_inactive", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "lualine_c_command", { fg = "NONE", bg = "NONE" })

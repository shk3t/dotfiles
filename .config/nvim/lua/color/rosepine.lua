local consts = require("consts")

require("rose-pine").setup({
  variant = "main",
  styles = {
    italic = false,
  },
  highlight_groups = {
    BlinkCmpKindText = { link = "@comment" },
    BlinkCmpKindMethod = { link = "@method" },
    BlinkCmpKindFunction = { link = "@function" },
    BlinkCmpKindConstructor = { link = "@constructor" },
    BlinkCmpKindField = { link = "@field" },
    BlinkCmpKindVariable = { link = "@variable" },
    BlinkCmpKindClass = { link = "@class" },
    BlinkCmpKindInterface = { link = "@interface" },
    BlinkCmpKindModule = { link = "@module" },
    BlinkCmpKindProperty = { link = "@property" },
    BlinkCmpKindUnit = { link = "@keyword" },
    BlinkCmpKindValue = { link = "@number" },
    BlinkCmpKindKeyword = { link = "@keyword" },
    BlinkCmpKindSnippet = { link = "@string.regexp" },
    BlinkCmpKindColor = { link = "Error" },
    BlinkCmpKindFile = { link = "@text" },
    BlinkCmpKindReference = { link = "@parameter" },
    BlinkCmpKindFolder = { link = "@class" },
    BlinkCmpKindEnum = { link = "@lsp.type.enum" },
    BlinkCmpKindEnumMember = { link = "@lsp.type.enum" },
    BlinkCmpKindConstant = { link = "@constant" },
    BlinkCmpKindStruct = { link = "Structure" },
    BlinkCmpKindEvent = { link = "@constant" },
    BlinkCmpKindOperator = { link = "@operator" },
    BlinkCmpKindTypeParameter = { link = "@type" },
    BlinkCmpKindCodeium = { link = "Error" },
    BlinkCmpKindCopilot = { link = "Error" },
    BlinkCmpKindSupermaven = { link = "Error" },
    BlinkCmpKindTabNine = { link = "Error" },
  },
})

vim.cmd.colorscheme(consts.COLORSCHEME)

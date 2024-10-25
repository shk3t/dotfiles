local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local quarto = require("quarto")

-- local diff = require("mini.diff")
-- diff.setup({
--   source = diff.gen_source.none(),
-- })

require("codecompanion").setup({
  display = {
    action_palette = {
      provider = "telescope",
    },
    chat = {
      separator = "=",
      show_settings = true,
    },
    -- diff = {
    -- enabled = false,
    -- provider = "mini_diff",
    -- },
  },
  strategies = {
    chat = {
      adapter = "deepseek2coder",
    },
    inline = {
      adapter = "deepseek2coder",
    },
    agent = {
      adapter = "deepseek2coder",
    },
  },
  adapters = {
    qwen25coder = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "qwen25coder",
        schema = {
          model = {
            default = "qwen2.5-coder:7b-instruct",
          },
          num_ctx = {
            default = 16384,
          },
        },
      })
    end,
    qwen25 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "qwen25",
        schema = {
          model = {
            default = "qwen2.5:7b",
          },
          num_ctx = {
            default = 16384,
          },
        },
      })
    end,
    deepseek2coder = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "deepseek2coder",
        schema = {
          model = {
            default = "deepseek-coder-v2:16b-lite-instruct-q4_0",
          },
          num_ctx = {
            default = 16384,
          },
        },
      })
    end,
    yicoder = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "yicoder",
        schema = {
          model = {
            default = "yi-coder:9b",
          },
          num_ctx = {
            default = 16384,
          },
        },
      })
    end,
  },
})

-- https://github.com/olimorris/codecompanion.nvim?tab=readme-ov-file#gear-configuration
keymap({ "n", "v" }, "<Space>ai", function()
  vim.cmd([[CodeCompanionChat Toggle]])
end)
keymap("n", "<Space>ac", vim.cmd.CodeCompanionActions)
keymap("v", "<Space>ac", vim.cmd.CodeCompanionActions)
keymap("v", "<Space>aa", function()
  vim.cmd([[CodeCompanionChat Add]])
end)

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[abbreviate cc CodeCompanion]])

autocmd("FileType", {
  pattern = "codecompanion",
  callback = function()
    keymap({ "n", "v" }, "<F5>", vim.cmd.MarkdownPreviewToggle, { buffer = true })
    quarto.activate()
  end,
})

-- require("codeium").setup({
--   enable_chat = false,
-- })

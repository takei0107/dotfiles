local sources = require("plugins.cmp.nvim-cmp-sources") or {}
local cmpType = require("plugins.cmp.cmp-type")

-- resolve dependencies for 'lazy.nvim'
---@return LazySpec[]
local function resolve_deps()
  ---@type table<string, LazySpec>
  local deps = { "L3MON4D3/LuaSnip" }
  for _, source in ipairs(sources) do
    ---@type LazySpec
    local spec = {
      [1] = source.name,
      lazy = true,
    }
    if source.config then
      spec.config = source.config
    end
    table.insert(deps, spec)
  end
  return deps
end

local function emulate_esc_input()
  vim.api.nvim_feedkeys(termcodes("<Esc>"), "n", false)
end

---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  --cond = false,
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  keys = { "/", "?" },
  ---@type LazySpec[]
  dependencies = resolve_deps(),
  ---@type fun(self:LazyPlugin, opts:table)
  config = function()
    local cmp = require("cmp")
    local types = require("cmp.types")

    -- mappings for insert mode completion
    cmp.setup({
      enabled = true,

      -- required
      ---@type cmp.SnippetConfig
      snippet = {
        ---@type fun(args: cmp.SnippetExpansionParams)
        ---@param args cmp.SnippetExpansionParams
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      ---@type table<string, cmp.Mapping>
      mapping = {
        -- 'ctrl-n' to select next item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "i" }),

        -- 'ctrl-p' to select prev item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "i" }),

        -- 'enter' to accept item
        ---@param fallback function
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
            emulate_esc_input()
          else
            fallback()
          end
        end, { "i" }),

        -- 'ESC/ctrl-[' to abort completion
        ---@param fallback function
        ["<C-e>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.get_selected_entry() then
              cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
              emulate_esc_input()
            else
              cmp.abort()
              emulate_esc_input()
            end
          else
            fallback()
          end
        end, { "i" }),
      },

      ---@type cmp.SourceConfig[]
      sources = sources(cmpType.EDITOR) or {},

      -- :h cmp-config.formatting.format
      ---@type cmp.FormattingConfig
      formatting = {
        ---@type fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem
        format = function(entry, vim_item)
          local source = sources[entry.source.name]
          if source and source.format then
            return source.format(vim_item)
          end
          return vim_item
        end,
      },
    })

    -- keymap for searchmode completion
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = {
        -- 'ctrl-n' to select next item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "c" }),

        -- 'ctrl-p' to select prev item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "c" }),

        -- 'enter' to accept item
        ---@param fallback function
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
            emulate_esc_input()
          else
            fallback()
          end
        end, { "c" }),

        ["<C-e>"] = function()
          cmp.abort()
        end,
      },

      sources = sources(cmpType.CMD_SEARCH),
    })

    -- keymap for exmode completion
    cmp.setup.cmdline(":", {
      mapping = {
        -- 'ctrl-n' to select next item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "c" }),

        -- 'ctrl-p' to select prev item
        ---@param fallback function
        ---@diagnostic disable-next-line: unused-local
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end, { "c" }),

        -- 'enter' to accept item
        ---@param fallback function
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
            emulate_esc_input()
          else
            fallback()
          end
        end, { "c" }),

        -- pathの補完を'/'区切りで入力していけるように
        ---@diagnostic disable-next-line: unused-local
        ["<C-e>"] = cmp.mapping(function(fallback)
          cmp.close()
        end, { "c" }),
      },

      sources = sources(cmpType.CMD_EX),
    })
  end,
}

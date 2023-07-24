---@diagnostic disable
---------------------------// lazy.nvim //---------------------------------//

---@see https://github.com/folke/lazy.nvim/blob/main/lua/lazy/types.lua

---@alias LazyPluginKind "normal"|"clean"|"disabled"

---@class LazyPluginState
---@field loaded? {[string]:string}|{time:number}
---@field installed boolean
---@field tasks? LazyTask[]
---@field dirty? boolean
---@field updated? {from:string, to:string}
---@field is_local boolean
---@field updates? {from:GitInfo, to:GitInfo}
---@field cloned? boolean
---@field kind? LazyPluginKind
---@field dep? boolean True if this plugin is only in the spec as a dependency
---@field cond? boolean
---@field super? LazyPlugin

---@alias PluginOpts table|fun(self:LazyPlugin, opts:table):table?

---@class LazyPluginHooks
---@field init? fun(self:LazyPlugin) Will always be run
---@field deactivate? fun(self:LazyPlugin) Unload/Stop a plugin
---@field config? fun(self:LazyPlugin, opts:table)|true Will be executed when loading the plugin
---@field build? string|fun(self:LazyPlugin)|(string|fun(self:LazyPlugin))[]
---@field opts? PluginOpts

---@class LazyPluginHandlers
---@field event? string[]
---@field cmd? string[]
---@field ft? string[]
---@field keys? (string|LazyKeys)[]
---@field module? false

---@class LazyPluginRef
---@field branch? string
---@field tag? string
---@field commit? string
---@field version? string
---@field pin? boolean
---@field submodules? boolean Defaults to true

---@class LazyPluginBase
---@field [1] string?
---@field name string display name and name used for plugin config files
---@field main? string Entry module that has setup & deactivate
---@field url string?
---@field dir string
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field optional? boolean If set, then this plugin will not be added unless it is added somewhere else
---@field lazy? boolean
---@field priority? number Only useful for lazy=false plugins to force loading certain plugins first. Default priority is 50
---@field dev? boolean If set, then link to the respective folder under your ~/projects

---@class LazyPlugin: LazyPluginBase,LazyPluginHandlers,LazyPluginHooks,LazyPluginRef
---@field dependencies? string[]
---@field _ LazyPluginState

---@class LazyPluginSpecHandlers
---@field event? string[]|string|fun(self:LazyPlugin, event:string[]):string[]
---@field cmd? string[]|string|fun(self:LazyPlugin, cmd:string[]):string[]
---@field ft? string[]|string|fun(self:LazyPlugin, ft:string[]):string[]
---@field keys? string|string[]|LazyKeys[]|fun(self:LazyPlugin, keys:string[]):(string|LazyKeys)[]
---@field module? false

---@class LazyPluginSpec: LazyPluginBase,LazyPluginSpecHandlers,LazyPluginHooks,LazyPluginRef
---@field dependencies? string|string[]|LazyPluginSpec[]

---@alias LazySpec string|LazyPluginSpec|LazySpecImport|LazySpec[]

---@class LazySpecImport
---@field import string spec module to import
---@field enabled? boolean|(fun():boolean)

---------------------------------------------------------------------------//

---------------------------// nvim-cmp //----------------------------------//

-- vim -----------------------------------------------------------------//
---@see https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/vim.lua

---@class vim.CompletedItem
---@field public word string
---@field public abbr string|nil
---@field public kind string|nil
---@field public menu string|nil
---@field public equal 1|nil
---@field public empty 1|nil
---@field public dup 1|nil
---@field public id any
---@field public abbr_hl_group string|nil
---@field public kind_hl_group string|nil
---@field public menu_hl_group string|nil

---@class vim.Position 1-based index
---@field public row integer
---@field public col integer

---@class vim.Range
---@field public start vim.Position
---@field public end vim.Position

---@class cmp.ContextOption
---@field public reason cmp.ContextReason|nil

---@class cmp.ConfirmOption
---@field public behavior cmp.ConfirmBehavior
---@field public commit_character? string

---@class cmp.SelectOption
---@field public behavior cmp.SelectBehavior

---@class cmp.SnippetExpansionParams
---@field public body string
---@field public insert_text_mode integer

---@class cmp.CompleteParams
---@field public reason? cmp.ContextReason
---@field public config? cmp.ConfigSchema

---@class cmp.SetupProperty
---@field public buffer fun(c: cmp.ConfigSchema)
---@field public global fun(c: cmp.ConfigSchema)
---@field public cmdline fun(type: string|string[], c: cmp.ConfigSchema)
---@field public filetype fun(type: string|string[], c: cmp.ConfigSchema)

-- cmp -----------------------------------------------------------------//
---@see https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/cmp.lua

---@class cmp.Entry
---@field public id integer
---@field public cache cmp.Cache
---@field public match_cache cmp.Cache
---@field public score integer
---@field public exact boolean
---@field public matches table
---@field public context cmp.Context
---@field public source cmp.Source
---@field public source_offset integer
---@field public source_insert_range lsp.Range
---@field public source_replace_range lsp.Range
---@field public completion_item lsp.CompletionItem
---@field public resolved_completion_item lsp.CompletionItem|nil
---@field public resolved_callbacks fun()[]
---@field public resolving boolean
---@field public confirmed boolean

---@class cmp.Source
---@field public id integer
---@field public name string
---@field public source any
---@field public cache cmp.Cache
---@field public revision integer
---@field public incomplete boolean
---@field public is_triggered_by_symbol boolean
---@field public entries cmp.Entry[]
---@field public offset integer
---@field public request_offset integer
---@field public context cmp.Context
---@field public completion_context lsp.CompletionContext|nil
---@field public status cmp.SourceStatus
---@field public complete_dedup function

---@alias cmp.Setup cmp.SetupProperty | fun(c: cmp.ConfigSchema)

---@class cmp.SourceApiParams: cmp.SourceConfig

---@class cmp.SourceCompletionApiParams : cmp.SourceConfig
---@field public offset integer
---@field public context cmp.Context
---@field public completion_context lsp.CompletionContext

---@alias  cmp.MappingFunction fun(fallback: function): nil

---@class cmp.MappingClass
---@field public i nil|cmp.MappingFunction
---@field public c nil|cmp.MappingFunction
---@field public x nil|cmp.MappingFunction
---@field public s nil|cmp.MappingFunction

---@alias cmp.Mapping cmp.MappingFunction | cmp.MappingClass

---@class cmp.ConfigSchema
---@field private revision integer
---@field public enabled boolean | fun(): boolean
---@field public performance cmp.PerformanceConfig
---@field public preselect cmp.PreselectMode
---@field public completion cmp.CompletionConfig
---@field public window cmp.WindowConfig|nil
---@field public confirmation cmp.ConfirmationConfig
---@field public matching cmp.MatchingConfig
---@field public sorting cmp.SortingConfig
---@field public formatting cmp.FormattingConfig
---@field public snippet cmp.SnippetConfig
---@field public mapping table<string, cmp.Mapping>
---@field public sources cmp.SourceConfig[]
---@field public view cmp.ViewConfig
---@field public experimental cmp.ExperimentalConfig

---@class cmp.PerformanceConfig
---@field public debounce integer
---@field public throttle integer
---@field public fetching_timeout integer
---@field public confirm_resolve_timeout integer
---@field public async_budget integer Maximum time (in ms) an async function is allowed to run during one step of the event loop.
---@field public max_view_entries integer

---@class cmp.WindowConfig
---@field completion cmp.WindowConfig
---@field documentation cmp.WindowConfig|nil

---@class cmp.CompletionConfig
---@field public autocomplete cmp.TriggerEvent[]|false
---@field public completeopt string
---@field public get_trigger_characters fun(trigger_characters: string[]): string[]
---@field public keyword_length integer
---@field public keyword_pattern string

---@class cmp.WindowConfig
---@field public border string|string[]
---@field public winhighlight string
---@field public zindex integer|nil
---@field public max_width integer|nil
---@field public max_height integer|nil
---@field public scrolloff integer|nil
---@field public scrollbar boolean|true

---@class cmp.ConfirmationConfig
---@field public default_behavior cmp.ConfirmBehavior
---@field public get_commit_characters fun(commit_characters: string[]): string[]

---@class cmp.MatchingConfig
---@field public disallow_fuzzy_matching boolean
---@field public disallow_fullfuzzy_matching boolean
---@field public disallow_partial_fuzzy_matching boolean
---@field public disallow_partial_matching boolean
---@field public disallow_prefix_unmatching boolean

---@class cmp.SortingConfig
---@field public priority_weight integer
---@field public comparators function[]

---@class cmp.FormattingConfig
---@field public fields cmp.ItemField[]
---@field public expandable_indicator boolean
---@field public format fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem

---@class cmp.SnippetConfig
---@field public expand fun(args: cmp.SnippetExpansionParams)

---@class cmp.ExperimentalConfig
---@field public ghost_text cmp.GhostTextConfig|boolean

---@class cmp.GhostTextConfig
---@field hl_group string

---@class cmp.SourceConfig
---@field public name string
---@field public option table|nil
---@field public priority integer|nil
---@field public trigger_characters string[]|nil
---@field public keyword_pattern string|nil
---@field public keyword_length integer|nil
---@field public max_item_count integer|nil
---@field public group_index integer|nil
---@field public entry_filter nil|function(entry: cmp.Entry, ctx: cmp.Context): boolean

---@class cmp.ViewConfig
---@field public entries cmp.EntriesConfig

---@alias cmp.EntriesConfig cmp.CustomEntriesConfig|cmp.NativeEntriesConfig|cmp.WildmenuEntriesConfig|string

---@class cmp.CustomEntriesConfig
---@field name 'custom'
---@field selection_order 'top_down'|'near_cursor'

---@class cmp.NativeEntriesConfig
---@field name 'native'

---@class cmp.WildmenuEntriesConfig
---@field name 'wildmenu'
---@field separator string|nil
-----------------------------------------------------------------------------

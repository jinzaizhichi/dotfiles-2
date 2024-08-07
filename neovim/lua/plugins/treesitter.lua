return {
    {
        'HiPhish/rainbow-delimiters.nvim',
        branch = 'use-children',
        lazy = false,
        config = function()
            -- This module contains a number of default definitions
            local rainbow_delimiters = require('rainbow-delimiters')

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterRed',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        enabled = false,
        cmd = 'TSContextToggle',
        ft = { 'lua', 'go' },
        config = function()
            require('treesitter-context').setup({
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        'class',
                        'function',
                        'method',
                        'for',
                        'while',
                        'if',
                        'switch',
                        'case',
                        'interface',
                        'struct',
                        'enum',
                    },
                    -- Patterns for specific filetypes
                    -- If a pattern is missing, *open a PR* so everyone can benefit.
                    tex = { 'chapter', 'section', 'subsection', 'subsubsection' },
                    haskell = { 'adt' },
                    rust = { 'impl_item' },
                    terraform = { 'block', 'object_elem', 'attribute' },
                    scala = { 'object_definition' },
                    vhdl = {
                        'process_statement',
                        'architecture_body',
                        'entity_declaration',
                    },
                    markdown = { 'section' },
                    elixir = {
                        'anonymous_function',
                        'arguments',
                        'block',
                        'do_block',
                        'list',
                        'map',
                        'tuple',
                        'quoted_content',
                    },
                    json = { 'pair' },
                    typescript = { 'export_statement' },
                    yaml = { 'block_mapping_pair' },
                },
                exact_patterns = {
                    -- Example for a specific filetype with Lua patterns
                    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
                    -- exactly match "impl_item" only)
                    -- rust = true,
                },

                -- [!] The options below are exposed but shouldn't require your attention,
                --     you can safely ignore them.

                zindex = 20, -- The Z-index of the context window
                mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufReadPost',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'bash',
                    'c',
                    'cmake',
                    -- "comment", -- comments are slowing down TS bigtime, so disable for now
                    'cpp',
                    'css',
                    'diff',
                    'fish',
                    'gitignore',
                    'go',
                    'graphql',
                    'html',
                    'http',
                    'java',
                    'javascript',
                    'jsdoc',
                    'jsonc',
                    'latex',
                    'lua',
                    'markdown',
                    'markdown_inline',
                    'meson',
                    'ninja',
                    'nix',
                    'norg',
                    'org',
                    'php',
                    'python',
                    'query',
                    'regex',
                    'rust',
                    'scss',
                    'sql',
                    'svelte',
                    'teal',
                    'toml',
                    'tsx',
                    'typescript',
                    'vhs',
                    'vim',
                    'vue',
                    'wgsl',
                    'yaml', -- "wgsl",
                    'json',
                    -- "markdown",
                    'groovy',
                },
                sync_install = false,
                auto_install = false,
                highlight = { enable = true },
                rainbow = {
                    enable = true,
                    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil, -- Do not enable for files with more than n lines, int
                    -- termcolors = {} -- table of colour name strings
                },
                indent = { enable = false },
                context_commentstring = { enable = true, enable_autocmd = false },
                incremental_selection = {
                    -- TODO: error
                    enable = false,
                    keymaps = {
                        init_selection = '<CR>',
                        node_incremental = '<CR>',
                        scope_incremental = '<S-CR>',
                        node_decremental = '<BS>',
                    },
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { 'BufWrite', 'CursorHold' },
                },
                textsubjects = {
                    enable = true,
                    keymaps = {
                        ['.'] = 'textsubjects-smart',
                        [';'] = 'textsubjects-container-outer',
                    },
                },
                textobjects = {
                    select = {
                        enable = false,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    move = {
                        enable = false,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']f'] = '@function.outer',
                            [']c'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']F'] = '@function.outer',
                            [']C'] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[f'] = '@function.outer',
                            ['[c'] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[F'] = '@function.outer',
                            ['[C'] = '@class.outer',
                        },
                    },
                    lsp_interop = {
                        enable = false,
                        peek_definition_code = { ['gD'] = '@function.outer' },
                    },
                },
            })
            local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
            parser_config.markdown.filetype_to_parsername = 'octo'
        end,
    },
    -- { 'nvim-treesitter/playground', lazy = false, enable = false },
}

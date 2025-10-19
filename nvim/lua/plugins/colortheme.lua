return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup {
            flavour = 'auto',
            background = {
                light = 'latte',
                dark = 'mocha',
            },
            transparent_background = true,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {
                enabled = false,
                shade = 'dark',
                percentage = 0.15,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { 'italic' },
                conditionals = { 'italic' },
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = {
                    enabled = true,
                    indentscope_color = '',
                },
            },
            highlight_overrides = {
                all = function(colors)
                    return {
                        LineNr = { fg = colors.lavender },
                        MatchParen = { bg = colors.maroon, fg = colors.mantle },
                    }
                end,
            },
        }

        vim.cmd.colorscheme 'catppuccin'
    end,
}

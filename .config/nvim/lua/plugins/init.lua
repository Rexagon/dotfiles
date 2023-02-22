return {
    -- Colorscheme
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.fn.sign_define("DiagnosticSignError", {text='¤', texthl='red', linehl='', numhl=''})
            vim.fn.sign_define("DiagnosticSignWarn", {text='•', texthl='yellow', linehl='', numhl=''})
            vim.fn.sign_define("DiagnosticSignHint", {text='»', texthl='green', linehl='', numhl=''})
            vim.fn.sign_define("DiagnosticSignInfo", {text='i', texthl='gray', linehl='', numhl=''})

            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_diagnostic_text_highlight = 1
            vim.g.gruvbox_material_diagnostic_line_highlight = 1
            vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
            vim.cmd [[ colorscheme gruvbox-material ]]

        end
    },
    "RRethy/vim-illuminate",
    --[[{
        "folke/lsp-colors.nvim",
        config = function()
            require("lsp-colors").setup({
                Error = "#db4b4b",
                Warning = "#e0af68",
                Information = "#0db9d7",
                Hint = "#10B981"
            })
        end
    },]]--
    -- Tabs
    "romgrk/barbar.nvim",
    -- Read .editorconfig
    "editorconfig/editorconfig-vim",
    -- Terminal stuff
    {
        'akinsho/toggleterm.nvim',
        config = true
    },
    -- Typing helpers
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    },
    -- Running tests
    {
        "klen/nvim-test",
        config = function()
            require('nvim-test').setup()
        end,
    },
    "tpope/vim-abolish",
    -- Sign column:
    "airblade/vim-gitgutter",
    "lukas-reineke/indent-blankline.nvim",
    -- Git helpers
    {
        "tpope/vim-fugitive",
        config = function()
            vim.cmd [[ command! Gblame Git blame ]]
        end
    },
    -- HTML helpers
    {
        "mattn/emmet-vim",
        config = function()
            vim.g.user_emmet_expandabbr_key = "<C-y>y"
        end,
    },
    -- Start page
    {
        "mhinz/vim-startify",
        dependencies = { "ryanoasis/vim-devicons" },
        config = function()
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
            vim.cmd [[
            function! StartifyEntryFormat()
                return 'WebDevIconsGetFileTypeSymbol(absolute_path) . "  " . entry_path'
            endfunction
            ]]
        end
     },
    -- GPG
    'jamessan/vim-gnupg',
    -- Global search & replace
    -- 'nvim-pack/nvim-spectre',
}

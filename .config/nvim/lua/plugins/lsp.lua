local function setup_lsp()
    local lspconfig = require 'lspconfig'

    --[[
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        signs = false,
        severity_sort = true,
    })

    vim.diagnostic.config {
        virtual_text = false,
    }
    ]]--

    local map = vim.keymap.set
    map('n', '<leader>r', ':IncRename ', { silent = true })
    map('n', '<leader>k', vim.lsp.buf.hover, { silent = true })
    map('n', '<leader>a', vim.lsp.buf.code_action, { silent = true })
    map('n', '<leader><space>', function() vim.lsp.buf.format { async = true } end, { silent = true })
    -- map('n', '<leader>s', require('lsp_lines').toggle)

    -- Disable lsp-lines in insert mode
    --[[
    local lsp_lines_helper = vim.api.nvim_create_augroup('LspLinesHelper', {})
    local last_lsp_lines_status = true
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = lsp_lines_helper,
        pattern = "*",
        callback = function()
            last_lsp_lines_status = vim.diagnostic.config().virtual_lines
            vim.diagnostic.config {
                virtual_text = false,
                virtual_lines = false,
            }
            vim.cmd [[ normal "hl" ]]
    --[[    end
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
        group = lsp_lines_helper,
        pattern = "*",
        callback = function()
            vim.diagnostic.config {
                virtual_text = false,
                virtual_lines = last_lsp_lines_status,
            }
        end
    })
    ]]--
    

    local function capabilities()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        return capabilities
    end

    local navic = require 'nvim-navic'
    local function on_attach(client, bufnr)
        navic.attach(client, bufnr)

        -- Semantic tokens
        local hi = vim.api.nvim_set_hl
        hi(0, '@unsafe',   { underdashed = true })
        hi(0, '@trait',    { italic = true })
        hi(0, '@callable', { link = 'Function'})

        -- Show diagnostic popup on cursor hover
        local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, { focusable = false })
            end,
            group = diag_float_grp,
        })
    end

    if executable('rust-analyzer') then
        local rustc_source = nil
        if vim.env.RUSTC_SRC ~= nil then
            rustc_source = vim.env.RUSTC_SRC
        end

        require('rust-tools').setup {
            tools = {
                runnables = {
                    use_telescope = true,
                },
                inlay_hints = {
                    parameter_hints_prefix = "← ",
                    other_hints_prefix = ": ",
                },
                hover_actions = {
                    border = "none",
                },
            },
            server = {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        completion = {
                            autoimport = {
                                enable = true,
                            },
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                        assist = {
                            importMergeBehaviour = "crate",
                            importPrefix = "by_crate",
                        },
                        inlayHints = {
                            expressionAdjustmentHints = {
                                enable = true,
                            },
                        },
                        rustc = {
                            source = rustc_source,
                        },
                    },
                },
                capabilities = capabilities(),
                on_attach = on_attach,
            }
        }
    end

    if executable('clangd') then
        lspconfig.clangd.setup{
            capabilities = capabilities(),
            on_attach = on_attach,
        }
    end

    if executable('pyright') then
        lspconfig.pyright.setup{
            capabilities = capabilities(),
            on_attach = on_attach,
        }
    end

    if executable('typescript-language-server') then
        lspconfig.tsserver.setup {
            capabilities = capabilities(),
            on_attach = on_attach,
        }
    end

    if executable('haskell-language-server') then
        if executable('fourmolu') then
            lspconfig.hls.setup {
                capabilities = capabilities(),
                settings = {
                    haskell = {
                        formattingProvider = "fourmolu",
                    },
                },
                on_attach = on_attach,
            }
        else
            lspconfig.hls.setup {
                capabilities = capabilities(),
                on_attach = on_attach,
            }
        end
    end
end

local function setup_null_ls()
    local null_ls = require 'null-ls'
    null_ls.setup {
        sources = {
            null_ls.builtins.diagnostics.shellcheck.with {
                runtime_condition = function()
                    return vim.fn.executable('shellcheck') == 1
                end
            },
            null_ls.builtins.code_actions.shellcheck.with {
                runtime_condition = function()
                    return vim.fn.executable('shellcheck') == 1
                end
            },
            null_ls.builtins.formatting.jq.with {
                runtime_condition = function()
                    return vim.fn.executable('jq') == 1
                end,
            },
        }
    }
end

return {
    {
        'neovim/nvim-lspconfig',
        config = setup_lsp,
        dependencies = { 'SmiteshP/nvim-navic', 'simrat39/rust-tools.nvim' },
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }, 
        config = setup_null_ls,
    },
    --[[{
        'folke/lsp-colors.nvim',
        config = function()
            require("lsp-colors").setup({
                Error = "#db4b4b",
                Warning = "#e0af68",
                Information = "#0db9d7",
                Hint = "#10B981"
            })
        end
    },]]--

    --[[{
        url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require('lsp_lines').setup()
        end
    },]]--
    {
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup{} end
    },
    {
        'stevearc/dressing.nvim',
        config = function() require('dressing').setup {
            input = {
                enabled = false,
            },
        } end,
    },
    {
        'smjonas/inc-rename.nvim',
        config = function() require('inc_rename').setup{} end,
    },
    {
        'saecki/crates.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'jose-elias-alvarez/null-ls.nvim' },
        config = function()
            require('crates').setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                }
            })
        end
    }
}

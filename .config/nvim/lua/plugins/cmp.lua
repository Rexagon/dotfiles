local function setup_cmp()
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    local function feed(keys)
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), true)
    end

    local function border(hl_name)
      return {
            { "╭", hl_name },
            { "─", hl_name },
            { "╮", hl_name },
            { "│", hl_name },
            { "╯", hl_name },
            { "─", hl_name },
            { "╰", hl_name },
            { "│", hl_name },
        }
    end

    local cmp = require 'cmp'
    cmp.setup {
        --[[
        completion = {
            autocomplete = false
        },
        ]]--

        --[[window = {
            completion = {
                border = border "CmpBorder",
                winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            },
            documentation = {
                border = border "CmpDocBorder",
            },
        },]]--
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end,
        },

        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'latex_symbols' },
            { name = 'path' },
            --{ name = 'buffer' },
            --{ name = 'calc' },
        },

        experimental = {
            ghost_text = true,
        },

        mapping = {
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 's' }),
            ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    local line = vim.fn.getline('.')
                    line = string.sub(line, 1, vim.fn.col('.') - 1)
                    if string == nil or string.match(line, "%S") == nil then
                        fallback()
                    else
                        feed('<C-Space>')
                    end
                end
            end, { 'i', 's' }),
            ['<C-j>'] = cmp.mapping(function(fallback)
                if vim.fn['vsnip#jumpable'](1) == 1 then
                    feed('<Plug>(vsnip-jump-next)')
                else
                    fallback()
                end
            end),
            ['<CR>'] = cmp.mapping(
                cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
                { 'i', 's' }
            ),
            ['<C-e>'] = cmp.mapping.close(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
        }
    }

    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
            cmp.setup.buffer({ sources = { { name = "crates" } } })
        end,
    })

    local map = vim.keymap.set
    map({'i', 's'}, '<M-Tab>', '<Plug>(vsnip-jump-next)', { remap = true })
    map({'i', 's'}, '<M-l>', '<Plug>(vsnip-jump-next)', { remap = true })
    map({'i', 's'}, '<M-h>', '<Plug>(vsnip-jump-prev)', { remap = true })
end

return {
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        config = setup_cmp,
        dependencies = {
            'windwp/nvim-autopairs',
            'hrsh7th/vim-vsnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'kdheepak/cmp-latex-symbols',
        },
    }
}

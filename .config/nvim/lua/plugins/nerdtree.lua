function setup_nvim_tree()
    local nvim_tree = require('nvim-tree')

    vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", { silent = true, noremap = true })

    nvim_tree.setup({
    })
end

return {
    {
        "nvim-tree/nvim-tree.lua",
        config = setup_nvim_tree,
    }
}

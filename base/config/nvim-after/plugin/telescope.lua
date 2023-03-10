local telescope = require("telescope")
telescope.load_extension("ag") 
telescope.setup{
  pickers = {
    find_files = {
      theme = "ivy",
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })

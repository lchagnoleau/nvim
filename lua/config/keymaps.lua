-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move bloc to the up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move bloc to the down" })
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "[R]eplace current [W]ord" })

vim.keymap.set("n", "<leader>ho", ":%!xxd<CR>:set ft=xxd<CR>", { desc = "[H]ex mode [O]pen" })
vim.keymap.set("n", "<leader>hc", ":%!xxd -r<CR>", { desc = "[H]ex mode [C]lose" })
vim.keymap.set("n", "<leader>hc", ":%!xxd -r<CR>", { desc = "[H]ex mode [C]lose" })

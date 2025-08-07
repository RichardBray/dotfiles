require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Move selected lines up and down with Shift+K and Shift+J
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })

-- Buffer navigation with Shift-h and Shift-l
map("n", "<leader>x", "<CMD>bd<CR>", { desc = "Close buffer" })

-- Buffer navigation with Alt-arrows
map("n", "<M-Left>", "<CMD>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<M-Right>", "<CMD>bnext<CR>", { desc = "Next buffer" })
map("n", "<M-Up>", "<CMD>bfirst<CR>", { desc = "First buffer" })
map("n", "<M-Down>", "<CMD>blast<CR>", { desc = "Last buffer" })

-- Add buffer navigation in insert mode as well
map("i", "<M-Left>", "<ESC><CMD>bprevious<CR>", { desc = "Previous buffer" })
map("i", "<M-Right>", "<ESC><CMD>bnext<CR>", { desc = "Next buffer" })
map("i", "<M-Up>", "<ESC><CMD>bfirst<CR>", { desc = "First buffer" })
map("i", "<M-Down>", "<ESC><CMD>blast<CR>", { desc = "Last buffer" })

-- Telescope shortcuts
local builtin = require("telescope.builtin")

map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic message" })
map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss noice message" })

-- Remap delete operations to use blackhole register
map("n", "d", '"_d', { desc = "Delete to blackhole register" })
map("n", "dd", '"_dd', { desc = "Delete line to blackhole register" })
map("v", "d", '"_d', { desc = "Delete selection to blackhole register" })
map("n", "D", '"_D', { desc = "Delete to end of line to blackhole register" })
-- map("n", "x", '"_x', { desc = "Delete character to blackhole register" })
-- map("n", "X", '"_X', { desc = "Delete character before cursor to blackhole register" })
map("n", "C", '"_C', { desc = "Change to end of line to blackhole register" })
map("n", "cc", '"_cc', { desc = "Change whole line to blackhole register" })

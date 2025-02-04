return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- New mapping for toggling current line blame
      map("n", "<leader>gt", gs.toggle_current_line_blame, "[T]oggle Git blame")
    end,
  },
}

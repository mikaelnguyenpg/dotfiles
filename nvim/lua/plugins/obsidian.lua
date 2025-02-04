return {
  -- add Obsidian
  {
    -- https://github.com/epwalsh/obsidian.nvim
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = "VimEnter",
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/01_Projects/71_obsidianvault",
        },
        -- {
        --   name = "work",
        --   path = "~/vaults/work",
        -- },
      },

      -- see below for full list of options 👇
      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "02_Inbox",

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "03_Journal",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },

      -- Optional, for templates (see below).
      templates = {
        folder = "00_Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["-"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
          ["<"] = { char = "≡", hl_group = "ObsidianSchedule" },
          ["/"] = { char = "○", hl_group = "ObsidianPartial" },
          -- ["/"] = { char = "◧", hl_group = "ObsidianPartial" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        -- -- Use bullet marks for non-checkbox lists.
        -- bullets = { char = "•", hl_group = "ObsidianBullet" },
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- -- Replace the above with this if you don't have a patched font:
        -- -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- reference_text = { hl_group = "ObsidianRefText" },
        -- highlight_text = { hl_group = "ObsidianHighlightText" },
        -- tags = { hl_group = "ObsidianTag" },
        -- block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "98_Files/imgs", -- This is the default

        -- -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
        -- ---@return string
        -- img_name_func = function()
        --   -- Prefix image names with timestamp.
        --   return string.format("%s-", os.time())
        -- end,
        --
        -- -- A function that determines the text to insert in the note when pasting an image.
        -- -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- -- This is the default implementation.
        -- ---@param client obsidian.Client
        -- ---@param path obsidian.Path the absolute path to the image file
        -- ---@return string
        -- img_text_func = function(client, path)
        --   path = client:vault_relative_path(path) or path
        --   return string.format("![%s](%s)", path.name, path)
        -- end,
      },
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      -- explorer = {
      --   enabled = true,
      --   replace_netrw = true, -- disable netrw
      --
      --   auto_close = false, -- close explorer after opening file
      --   follow_file = true, -- highlight current file
      --   hidden = true, -- show hidden files
      -- },

      dashboard = {
        width = 60,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = [[
welcome
 ▄▄▄       ███▄ ▄███▓▓█████ ▓█████  ███▄    █ 
▒████▄    ▓██▒▀█▀ ██▒▓█   ▀ ▓█   ▀  ██ ▀█   █ 
▒██  ▀█▄  ▓██    ▓██░▒███   ▒███   ▓██  ▀█ ██▒
░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄ ▒▓█  ▄ ▓██▒  ▐▌██▒
 ▓█   ▓██▒▒██▒   ░██▒░▒████▒░▒████▒▒██░   ▓██░
 ▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░░░ ▒░ ░░ ▒░   ▒ ▒ 
  ▒   ▒▒ ░░  ░      ░ ░ ░  ░ ░ ░  ░░ ░░   ░ ▒░
  ░   ▒   ░      ░      ░      ░      ░   ░ ░ 
      ░  ░       ░      ░  ░   ░  ░         ░ 
          ]],
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and item.icon == "file" or item.icon == "directory" then
              return Snacks.dashboard.icon(item.file, item.icon)
            end
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },

      -- picker = {
      --   sources = {
      --     explorer = {
      --       layout = {
      --         position = "Right",
      --       },
      --     },
      --   },
      -- },

      -- picker = {
      --   explorer = {
      --     layout = {
      --       layout = {
      --         position = "right", -- left | right
      --         width = 30,
      --       },
      --     },
      --   },
      -- },
    },

    keys = {
      {
        "<leader>e",
        function()
          local explorer_win = nil

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "snacks_picker_list" then
              explorer_win = win
              break
            end
          end

          if vim.api.nvim_get_current_win() ~= explorer_win and explorer_win then
            vim.api.nvim_set_current_win(explorer_win)
          else
            Snacks.explorer()
          end
        end,
        desc = "Snacks File Explorer",
      },
    },
  },
}

return {
  {
    "folke/flash.nvim",
    keys = {
      -- 1. Disable the default 's' keybinding so it returns to native behavior
      { "s", mode = { "n", "x", "o" }, false },
      
      -- 2. Map Ctrl+f to the Flash search function
      { 
        "<c-f>", 
        mode = { "n", "x", "o" }, 
        function() require("flash").jump() end, 
        desc = "Flash Search" 
      },
    },
  },
}

# hugin.nvim

A Yu-Gi-Oh! card and EDOPro script lookup tool for Neovim.

Brings up a picker window to search for card scripts by name and open their file.

## Installation

```lua
-- lua/plugins/hugin.lua
return {
  "ksm2p/hugin.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>fy", function() require("hugin").pick() end, desc = "Find EDOPro script" },
  },
  opts = {
    game_folder = "C:/ProjectIgnis"
  },
}
```

![UI screenshot](https://github.com/user-attachments/assets/71dbfa2e-b962-4c92-8baf-44334784f0f1)

Currently just for my own use, but should anyone stumble upon this plugin and decide to try it, shoot me a message on the Project Ignis Discord!

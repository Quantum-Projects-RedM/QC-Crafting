# QC-Craft

A complete crafting system designed for use with [RSG Framework](https://github.com/Rexshack-RedM). This script allows players to craft items using required materials and integrates with ox_target for interactive crafting tables.
---
### Need Support? join our discord!

- Discord: https://discord.gg/kJ8ZrGM8TS
---

# Information

- Ensure all dependencies are installed and started before using QC-Craft.
- Players interact with crafting props set in the configuration to open the crafting menu.
- Crafting options and required materials are fully configurable in `config.lua`.
- Item images should be added to your inventory images folder for proper display.
- Crafting timers are set in seconds in the configuration.
---

# Developer Information

- To add more crafting recipes, edit the `Config.CraftingOptions` table in `config.lua`.
- Each recipe can have its own required items, crafting time, and output item.
- Make sure to add new items to `rsg-core/shared/items.lua` and provide corresponding images.
---
```lua
Config = {
  CraftingOptions = {
    ["Example Item"] = {
      crafttimer = 60, -- Craft time in seconds
      required = {
        [1] = { item = "wood", amount = 10 },
        [2] = { item = "iron", amount = 1 },
      },
      receive = "weapon_example"
    },
  }
}
```

## Support
[Quantum Projects Discord](https://discord.gg/kJ8ZrGM8TS)

## Dependencies
- rsg-core
- rsg-menu
- bln_notify
- ox_target

# Installation

1. Ensure all dependencies are installed and started.
2. Add `QC-Craft` to your `resources` folder.
3. Add required items to your `rsg-core/shared/items.lua`.
4. Add item images to your `rsg-inventory/html/images` folder.
5. Adjust `config.lua` as needed for your server.

# Starting the Resource

Add the following to your `server.cfg`:
```
ensure QC-Craft
```

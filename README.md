# Primordial Custom Model Changer ⭐

A lightweight and fully featured custom player model changer for **Primordial CS:GO**.

This project allows you to replace your local player model with custom `.mdl` models through a clean and efficient implementation built specifically for the Primordial Lua API.

Originally inspired by the GameSense player model changer concept, this project has been rewritten for Primordial with its own architecture, initialization flow, caching system, menu implementation, and engine interaction.

---

## Preview

Below is an in-game screenshot demonstrating the script in action.

<p align="center">
    <img src="INGAME.png" alt="In-Game Preview" width="900">
</p>

---

## Features

- ✔️ Custom player model replacement
- ✔️ Automatic model precaching
- ✔️ Cached model indices for improved performance
- ✔️ Lightweight and optimized implementation
- ✔️ Clean and easy-to-edit configuration
- ✔️ Simple in-game menu
- ✔️ Stable interface initialization
- ✔️ Graceful error handling

---

## Installation

1. Place the Lua script into your Primordial scripts folder.
2. Copy your custom `.mdl` files into your game directory (for example `models/player/...`).
3. Open the script and add your models to the `model_list` table.
4. Load the script in Primordial.
5. Enable **Model Changer** and select your desired model.

---

## Adding Custom Models

Add a new entry to the `model_list` table:

```lua
local model_list = {
    {
        name = "My Custom Model",
        path = "models/player/custom/my_model/player.mdl"
    }
}
```

Always use forward slashes (`/`) in model paths.

---

## Notes

- Custom models must exist inside your game directory.
- Servers must allow custom content (for example `sv_pure 0`) for models to render correctly.
- This script only changes the local player's model.

---

## Credits

### Original Inspiration

The original concept of a Lua-based player model changer for GameSense was created by **@gabrielzenly**.

Special thanks for the original idea that inspired this project.

### Primordial Version

Developed by **@l_sanikey_l**.

This version was written specifically for the Primordial Lua API and features its own implementation, including interface initialization, model caching, menu system, update flow, and overall project architecture.

---

## License

You are free to modify this project for personal use.

If you redistribute this project or publish modified versions, please preserve the original credits.

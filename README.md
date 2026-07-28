# Primordial Custom Model Changer

A lightweight and fully featured custom player model changer for **Primordial CS:GO**.

This project allows you to replace your local player model with custom `.mdl` models through a clean and efficient implementation built specifically for the Primordial Lua API.

Unlike the original GameSense implementation that inspired this project, this version was rewritten for Primordial with its own architecture, menu system, initialization flow, caching logic, and engine integration.

---

## Features

* ✔️ Custom player model replacement
* ✔️ Automatic model precaching
* ✔️ Model index caching for improved performance
* ✔️ Lightweight implementation
* ✔️ Clean and easy-to-edit configuration
* ✔️ Simple in-game menu
* ✔️ Stable interface initialization
* ✔️ Graceful error handling

---

## Installation

1. Place the Lua script into your Primordial scripts folder.
2. Put your custom player models into your game directory (for example `models/player/...`).
3. Open the script and add your models to the `model_list` table.
4. Load the script in Primordial.
5. Enable the Model Changer and select your desired model.

---

## Adding Custom Models

Simply add a new entry to the `model_list` table.

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

* Custom models must exist inside your game directory.
* Servers must allow custom assets (for example `sv_pure 0`) for models to render correctly.
* The script only changes the local player's model.

---

## Credits

### Original Inspiration

The original concept of a Lua-based player model changer for GameSense was created by **@gabrielzenly**.

This project would likely not exist without that original idea.

### Primordial Version

The Primordial version was developed by **@l_sanikey_l**.

While inspired by the original concept, this project was rewritten specifically for the Primordial Lua API and follows its own implementation, including interface initialization, menu system, model caching, update flow, and overall project structure.

---

## License

You are free to modify this project for personal use.

If you redistribute this project or publish modified versions, please preserve the original credits.

# 🌌 Hyprland Dotfiles

Welcome to my **Hyprland** configuration! This setup uses Lua as the primary configuration language (via the Hyprland Lua integration), making it modular, readable, and highly extensible. It provides a beautiful, productive, and modern Linux desktop experience.

## ✨ Features
- **Lua-Driven Configuration**: Replaces the default `hyprland.conf` with a powerful, split Lua structure (`hyprland.lua`, `keybind.lua`, `windowrules.lua`, etc.).
- **Dynamic Theming**: Integrated with the **Noctalia** theme manager for seamless, beautiful system-wide color palettes.
- **Scrolling Layout**: Utilizes a smooth scrolling layout for intuitive window stacking.
- **Mission Control & Expo**: Uses plugins like `hymission` and `hyprexpo` for workspace overviews.
- **Advanced Screenshots**: Powered by `hyprcapture` and `satty` for region captures, window snapshots, and quick annotations.

## 📦 Core Applications
- **Terminal:** Kitty
- **Web Browser:** Brave (primary) & Google Chrome
- **File Manager:** Thunar
- **Code Editor:** VS Code (`code`)
- **App Launcher / UI:** Noctalia panel & Caelestia launcher
- **Screen Locker:** Caelestia shell
- **Media Players:** MPV (video) & Quod Libet (music)

## ⌨️ Keybindings

The `SUPER` key is the primary modifier for most shortcuts.

### 🚀 Launchers & Apps
| Keybind | Action |
| --- | --- |
| `SUPER + Enter` | Open Kitty Terminal |
| `SUPER + E` | Open Thunar File Manager |
| `SUPER + B` | Open Brave Browser |
| `SUPER + V` | Open VS Code |
| `SUPER + D` | Toggle Noctalia App Launcher |
| `SUPER + X` | Toggle Caelestia Launcher |
| `SUPER + T` | Toggle Noctalia Settings |
| `SUPER + L` | Lock Screen |

### 🪟 Window Management
| Keybind | Action |
| --- | --- |
| `SUPER + Q` | Close Active Window |
| `SUPER + W` | Toggle Floating Window |
| `SUPER + F` | Toggle Fullscreen |
| `SUPER + Arrows` | Focus Left/Right/Up/Down |
| `SUPER + Shift + Arrows` | Resize Active Window |
| `SUPER + Ctrl + Shift + Arrows` | Move or Swap Window |
| `Alt + Tab` | Cycle Windows |

### 🌐 Workspaces & Overviews
| Keybind | Action |
| --- | --- |
| `SUPER + 1-9` | Switch to Workspace 1-9 |
| `SUPER + Shift + 1-9` | Move Active Window to Workspace 1-9 |
| `SUPER + Ctrl + Left/Right` | Switch to Prev/Next Workspace |
| `SUPER + Z` | Open Mission Control (`hymission`) |
| `SUPER + G` | Open Workspace Overview (`hyprexpo`) |

### 📸 Screenshots
| Keybind | Action |
| --- | --- |
| `Print` | Capture Region (`hyprcapture`) |
| `SUPER + Print` | Capture Window (`hyprcapture`) |
| `Alt + Print` | Capture Monitor Fullscreen (`hyprcapture`) |
| `SUPER + A` | Annotate Screenshot (`grim` + `satty`) |

### 🔉 Media & Hardware
| Keybind | Action |
| --- | --- |
| `XF86AudioRaise/Lower` | Increase/Decrease Volume |
| `XF86AudioMute` | Toggle Mute |
| `XF86MonBrightnessUp/Down` | Increase/Decrease Brightness |
| `XF86AudioPlay/Next/Prev` | Media Controls (`playerctl`) |

## 📂 Configuration Structure

The configuration is modularized into easily digestible files inside `~/.config/hypr/`:

* `hyprland.lua` — The main entry point that requires and initializes all modules.
* `keybind.lua` — All keyboard shortcuts and mouse binds.
* `windowrules.lua` — Rules for forcing windows to float, pinning, or opacity.
* `animations.lua` — Bezier curves and animation styling.
* `startup.lua` — Autostart applications and daemons.
* `workspace_mode.lua` — Specific rules for workspaces and layouts.
* `monitors.lua` — Screen resolution and placement configuration.
* `themes/` & `noctalia/` — Centralized styles, colors, and theming engines.
* `Scripts/` — Bash scripts for browsers and workspaces.

## 🛠️ Requirements & Dependencies

To get the most out of this setup, ensure you have the following installed:
* **Hyprland** (compiled with the Lua plugin or using a Lua wrapper).
* Plugins: `hymission`, `hyprexpo`, `hyprcapture`.
* Utilities: `kitty`, `thunar`, `playerctl`, `brightnessctl`, `wpctl` (WirePlumber), `jq`.
* Theming tools: Noctalia and Caelestia packages (if applicable to your distro/setup).

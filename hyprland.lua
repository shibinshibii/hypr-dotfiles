local config_dir = (os.getenv("HOME") or "") .. "/.config/hypr"
package.path = table.concat({
    config_dir .. "/?.lua",
    config_dir .. "/?/init.lua",
    package.path,
}, ";")

-- Clear cached modules so they re-execute on reload (ensures binds/rules re-register)
for _, mod in ipairs({"monitors", "inputs", "keybind", "windowrules", "animations", "themes.theme"}) do
    package.loaded[mod] = nil
end

require("monitors")
require("startup")
require("inputs")
require("keybind")
require("windowrules")
require("animations")
require("themes.theme")
local colors = require("noctalia.noctalia-colors")
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
	scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.75,
        focus_fit_method = 1,
        follow_focus = true,
        follow_min_visible = 0.4,

        explicit_column_widths = "0.333, 0.5, 0.667, 0.75, 1.0",

        wrap_focus = true,
        wrap_swapcol = true,

        direction = "right",
},
    misc = {
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        anr_missed_pings = 5,
        allow_session_lock_restore = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    general = {
	layout = "scrolling",
	border_size = 0,
        col = colors.general.col,
        snap = {
            enabled = true,
        },
    },
    group = colors.group,
})
-- Hymission configuration
hl.config({
    plugin = {
        hymission = {
            layout_engine = "natural",

            -- Show all workspaces in Mission Control
            only_active_workspace = 0,
            only_active_monitor = 0,

            -- Keep overview open when changing workspace
            workspace_change_keeps_overview = 1,

            -- Make the hovered window expand
            overview_focus_follows_mouse = 1,
            expand_selected_window = 1,

            -- Show window borders/decoration in overview
            window_decoration_enabled = 1,

            -- Optional: nicer spacing
            outer_padding_top = 92,
            outer_padding_right = 32,
            outer_padding_bottom = 32,
            outer_padding_left = 32,
            row_spacing = 32,
            column_spacing = 32,
        },
    },
})
hl.config({
    plugin = {
        hyprcapture = {
            default_mode = "region",
            fullscreen_scope = "all",
            overlay_scope = "fix",
            window_background = "follow-system",
            window_border = "keep",
            window_shadow = "keep",
            notification_backend = "hyprland",
            screenshot_notification = false,
            notification_title_template = "Screenshot captured",
            notification_body_template = "Saved {filename} ({window_title})",
            save = false,
            clipboard = true,
            show_thumbnail = true,
            allow_quick = false,
            confirm_before_capture = false,
            fusion_mode = false,
            capture_fullscreen_clients_as_monitor = false,
            dynamic_window_metadata = true,
            window_wheel_scroll = true,
            window_wheel_scope = "workspace",
            fullscreen_preview_rounding = "auto",
            save_dir = "$XDG_PICTURES_DIR/Screenshots",
            filename_template = "Screenshot-%Y-%m-%d-%H%M%S.png",
            record_save_dir = "$XDG_VIDEOS_DIR/Screenrecords",
            record_filename_template = "Recording-%Y-%m-%d-%H%M%S.mp4",
            record_format = "mp4",
            record_transparent_format = "webm",
            record_fps = 30,
            record_fps_options = "15 24 30 60",
            record_window_fps_limit = 12,
            record_window_real_bg_fps_limit = 8,
            record_codec = "libx264",
            record_transparent_codec = "auto",
            record_solid_alpha = false,
            record_preset = "veryfast",
            record_gsr_flags = "",
            record_window_backend = "compositor",
            record_max_seconds = 0,
            record_countdown_seconds = 0,
            include_cursor = false,
            thumbnail_timeout_ms = 5000,
            thumbnail_monitor = "active",
            watermark = "",
            watermark_position = "central",
            watermark_width = "20%",
            watermark_offset = "0 0",
        },
    },
})
-- hl.config({
--     plugin = {
--         hyprexpo = {
--             columns = 3,
--             gaps_in = 5,
--             gaps_out = 0,
--             bg_col = "rgb(111111)",
--             workspace_method = "center current",
--             gesture_distance = 200,
--             cancel_key = "escape",
--             show_cursor = 1,
--             drag_drop_enable = 1, 
--         },
--     },
-- })

-- For Noctalia Color templates
require("noctalia").apply_theme()

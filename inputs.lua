hl.config({
    input = {
        kb_layout = "us",
        kb_options = "",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        accel_profile = "flat",
        sensitivity = 0.75,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.5,
        },

        special_fallthrough = true,
        follow_mouse = 1,
    },
})
-- 3-finger horizontal swipe → scroll windows in scrolling layout
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
})
-- 4-finger horizontal swipe → switch workspace
hl.plugin.hymission.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
})

hl.plugin.hymission.gesture({
    fingers = 3,
    direction = "vertical",
    action = "toggle",
})

-- Hymission gestures
if hl.plugin.hymission ~= nil then
	
    -- 4-finger vertical swipe: Mission Control
    hl.plugin.hymission.gesture({
        fingers = 4,
        direction = "vertical",
        action = "toggle",
        args = "onlycurrentworkspace",
    })

end

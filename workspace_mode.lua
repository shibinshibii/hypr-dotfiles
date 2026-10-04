local modes = {}

local TAG_PREFIX = "wsfloat_"
local DWINDLE_TAG_PREFIX = "wsdwindle_"


local function get_workspace_id(workspace)
    if not workspace then
        return nil
    end

    return workspace.id
end


local function get_tag(workspace_id)
    return TAG_PREFIX .. tostring(workspace_id)
end


local function get_dwindle_tag(workspace_id)
    return DWINDLE_TAG_PREFIX .. tostring(workspace_id)
end


local function get_workspace_selector(workspace)
    if workspace.special then
        return tostring(workspace.name)
    end

    return "name:" .. tostring(workspace.name)
end


local function set_workspace_layout(workspace, layout)
    if not workspace then
        return
    end

    local workspace_id = workspace.id

    if not workspace_id then
        return
    end

    hl.workspace_rule({
        workspace = get_workspace_selector(workspace),
        layout = layout,
    })
end


-- IMPORTANT:
-- These helpers must be defined BEFORE mark_workspace_dwindle()
local function has_tag(window, wanted_tag)
    for _, tag in ipairs(window.tags or {}) do
        if tag == wanted_tag then
            return true
        end
    end

    return false
end


local function tag_window(window, tag)
    hl.dispatch(
        hl.dsp.window.tag({
            tag = "+" .. tag,
            window = window,
        })
    )
end


local function untag_window(window, tag)
    hl.dispatch(
        hl.dsp.window.tag({
            tag = "-" .. tag,
            window = window,
        })
    )
end


local function mark_workspace_dwindle(workspace)
    local workspace_id = workspace.id

    if not workspace_id then
        return
    end

    local tag = get_dwindle_tag(workspace_id)

    for _, window in ipairs(hl.get_workspace_windows(workspace)) do
        if not has_tag(window, tag) then
            tag_window(window, tag)
        end
    end
end


local function unmark_workspace_dwindle(workspace)
    local workspace_id = workspace.id

    if not workspace_id then
        return
    end

    local tag = get_dwindle_tag(workspace_id)

    for _, window in ipairs(hl.get_workspace_windows(workspace)) do
        if has_tag(window, tag) then
            untag_window(window, tag)
        end
    end
end


local function notify(title, message)
    hl.exec_cmd(
        "notify-send -a 'Hyprland' '"
        .. title
        .. "' '"
        .. message
        .. "'"
    )
end


local function make_floating(window, tag)
    if not window then
        return
    end

    if window.fullscreen and window.fullscreen ~= 0 then
        return
    end

    -- Don't take ownership of manually floating windows.
    if window.floating then
        return
    end

    hl.dispatch(
        hl.dsp.window.float({
            action = "set",
            window = window,
        })
    )

    tag_window(window, tag)
end


local function make_tiled(window, tag)
    if not window then
        return
    end

    -- Only undo windows that this module floated.
    if not has_tag(window, tag) then
        return
    end

    hl.dispatch(
        hl.dsp.window.float({
            action = "unset",
            window = window,
        })
    )

    untag_window(window, tag)
end


local function enable_workspace(workspace)
    local workspace_id = get_workspace_id(workspace)

    if not workspace_id then
        return
    end

    local tag = get_tag(workspace_id)

    modes[workspace_id] = true

    local windows = hl.get_workspace_windows(workspace)

    for _, window in ipairs(windows) do
        make_floating(window, tag)
    end

    notify(
        "Floating Mode",
        "Enabled on workspace " .. tostring(workspace_id)
    )
end


local function disable_workspace(workspace, opts)
    opts = opts or {}

    local workspace_id = get_workspace_id(workspace)

    if not workspace_id then
        return
    end

    local tag = get_tag(workspace_id)

    modes[workspace_id] = false

    local windows = hl.get_workspace_windows(workspace)

    for _, window in ipairs(windows) do
        make_tiled(window, tag)
    end

    if opts.showNotification then
        notify(
            "Floating Mode",
            "Disabled on workspace " .. tostring(workspace_id)
        )
    end
end


local function toggle_workspace_floating()
    local workspace = hl.get_active_workspace()

    if not workspace then
        return
    end

    local workspace_id = get_workspace_id(workspace)

    if not workspace_id then
        return
    end

    if modes[workspace_id] then
        disable_workspace(workspace, {
            showNotification = true,
        })
    else
        enable_workspace(workspace)
    end
end


--
-- Toggle floating mode
--
hl.bind(
    "SUPER + SHIFT + SPACE",
    toggle_workspace_floating,
    {
        description = "Toggle floating mode for current workspace",
    }
)


--
-- Toggle scrolling <-> dwindle
--
hl.bind(
    "SUPER + SHIFT + T",
    function()
        local workspace = hl.get_active_workspace()

        if not workspace then
            return
        end

        -- Disable our floating mode first.
        disable_workspace(workspace, {
            showNotification = false,
        })

        local current_layout = workspace.tiled_layout
        local next_layout

        if current_layout == "dwindle" then
            next_layout = "scrolling"
        else
            next_layout = "dwindle"
        end

        -- Set the layout only once.
        set_workspace_layout(workspace, next_layout)

        if next_layout == "dwindle" then
            mark_workspace_dwindle(workspace)
        else
            unmark_workspace_dwindle(workspace)
        end

        notify(
            "Layout",
            "Switched to " .. next_layout
        )
    end,
    {
        description = "Toggle current workspace between scrolling and dwindle",
    }
)


--
-- New windows opened while floating mode is enabled
--
hl.on("window.open", function(window)
    if not window or not window.workspace then
        return
    end

    local workspace_id = window.workspace.id

    if not workspace_id or not modes[workspace_id] then
        return
    end

    local tag = get_tag(workspace_id)

    make_floating(window, tag)
end)


--
-- Restore floating-mode state after config reload
--
for _, window in ipairs(hl.get_windows()) do
    for _, tag in ipairs(window.tags or {}) do
        local workspace_id = tag:match("^" .. TAG_PREFIX .. "(.+)$")

        if workspace_id then
            modes[tonumber(workspace_id) or workspace_id] = true
            break
        end
    end
end


--
-- Restore per-workspace Dwindle state after config reload
--
hl.on("config.reloaded", function()
    local restored = {}

    for _, window in ipairs(hl.get_windows()) do
        local workspace = window.workspace

        if workspace and workspace.id then
            local workspace_id = workspace.id
            local dwindle_tag = get_dwindle_tag(workspace_id)

            if has_tag(window, dwindle_tag)
                and not restored[workspace_id] then

                restored[workspace_id] = true

                set_workspace_layout(workspace, "dwindle")
            end
        end
    end


end)

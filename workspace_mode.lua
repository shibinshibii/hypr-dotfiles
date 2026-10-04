
local modes = {}

local TAG_PREFIX = "wsfloat_"


local function get_workspace_id(workspace)
    if not workspace then
        return nil
    end

    return workspace.id
end


local function get_tag(workspace_id)
    return TAG_PREFIX .. tostring(workspace_id)
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


local function make_floating(window, tag)
    if not window then
        return
    end

    -- Don't touch fullscreen windows.
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

    -- Only undo windows that THIS module floated.
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

    -- hl.notification.create({
    --     text = "Floating mode: ON  •  Workspace " .. tostring(workspace_id),
    --     timeout = 1800,
    -- })

    notify(
        "Floating Mode",
        "Enabled on workspace ".. tostring(workspace_id))
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
        notify("Floating Mode", "Disabled on workspace " .. tostring(workspace_id))
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
        disable_workspace(workspace, { showNotification = true })
    else
        enable_workspace(workspace)
    end
end


-- Toggle current workspace
hl.bind(
    "SUPER + SHIFT + SPACE",
    toggle_workspace_floating,
    {
        description = "Toggle floating mode for current workspace",
    }
)


hl.bind(
    "SUPER + SHIFT + T",
    function()
        local workspace = hl.get_active_workspace()

        if not workspace then
            return
        end

        -- Turn off our floating mode first.
        disable_workspace(workspace,{ showNotification=false })

        local current_layout = workspace.tiled_layout
        local next_layout

        if current_layout == "dwindle" then
            next_layout = "scrolling"
        else
            next_layout = "dwindle"
        end

        hl.workspace_rule({
            workspace = "name:" .. tostring(workspace.name),
            layout = next_layout,
        })

       notify(
        "Layout",
        "Switched to " .. next_layout
        )
    end,
    {
        description = "Toggle current workspace between scrolling and dwindle",
    }
)


-- New windows opened while floating mode is enabled
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


-- Restore floating-mode state after config reload
for _, window in ipairs(hl.get_windows()) do
    for _, tag in ipairs(window.tags or {}) do
        local workspace_id = tag:match("^" .. TAG_PREFIX .. "(.+)$")

        if workspace_id then
            modes[tonumber(workspace_id) or workspace_id] = true
            break
        end
    end
end

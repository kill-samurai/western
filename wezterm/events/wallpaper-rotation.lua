local wezterm = require('wezterm')

local M = {}

local ROTATION_INTERVAL = 5 * 60

function M.setup(backdrops)
    wezterm.on('update-status', function(window, pane)
        if #backdrops.images == 0 then
            return
        end

        local window_id = tostring(window:window_id())
        local now = os.time()

        local state = wezterm.GLOBAL.wallpaper_rotation or {}

        if not state[window_id] then
            state[window_id] = now
            wezterm.GLOBAL.wallpaper_rotation = state
            return
        end

        if now - state[window_id] >= ROTATION_INTERVAL then
            local idx = math.random(#backdrops.images)

            backdrops:set_img(window, idx)

            state[window_id] = now
            wezterm.GLOBAL.wallpaper_rotation = state
        end
    end)
end

return M

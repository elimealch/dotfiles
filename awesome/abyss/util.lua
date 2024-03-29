-- this function will check if the applications 
-- we are trying to launch aren't already running,
-- otherwise it will not launch the already running application
local function spawn_once(apps)
    local spawn = require("awful.spawn")

    for _, val in next, apps, nil do
        local app = ""
        local options = ""

        if type(val) == "table" then
            for i, v in next, val, nil do
                if i == "cmd" or i == 1 then
                    app = v
                elseif i == "options" or i == 2 then
                    options = v
                end
            end
        elseif type(val) == "string" then
            app = val
        end

        -- pipe commands to bash to allow command to be shell agnostic
        --spawn.with_shell(
        --    string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -",
        --    app, app .. options),
        --    false
        --)
        --spawn.with_shell("echo 'pgrep -u $USER -x " .. app .. " > /dev/null || (" .. app .. options .. ") | bash -")
        spawn.with_line_callback("pgrep -u $USER -x " .. app, {
            stderr = function()
                local cmd = app .. " " .. options
                --error(cmd)
                spawn.with_shell(cmd)
            end
        })
     end
end

-- Configuration directory under the configuration directory of linux
local config_dir = os.getenv("HOME") .. "/.config/awesome/mmushrooms/config/"

-- Apps to launch on awesome startup 
local on_startup = {
    -- Compositor
    {
        cmd = "picom",
        options = "--experimental-backends --config " .. config_dir .. "picom2.conf"
    },
    -- Authenticator agent
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
    -- screen color temperature control
    --"redshift-gtk",
}

spawn_once(on_startup)

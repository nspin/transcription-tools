local mp = require 'mp'

local function handle(table)
    mp.command("seek 10 absolute")
end

mp.add_forced_key_binding("RIGHT", "foo", handle, {})

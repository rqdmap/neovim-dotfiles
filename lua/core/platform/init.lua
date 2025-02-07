local utils = require("core.utils")

local platform = utils.get_platform()
if platform == "mac" then
    require("core.platform.mac").setup()
elseif platform == "linux" then
    require("core.platform.linux").setup()
else

end

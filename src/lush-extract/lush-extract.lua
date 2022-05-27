--

local theme_name = "slate"

local lush_rtp = os.getenv('HOME')..'/.local/share/nvim/site/pack/packer/start/lush.nvim/lua/?.lua;'
local theme_rtp = os.getenv('HOME')..'/code/slate/lua/lush_theme/?.lua;'

package.path = theme_rtp..package.path
package.path = lush_rtp..package.path

local theme = require('slate')

for k, v in pairs(theme.X.lush) do
   print(k..'="'..v..'"')
end

-- local function nvim_rtp()
--    local file = assert(io.popen('nvim --headless -c "set runtimepath" -c "q"', 'r'))
--    local out = file:read('*a')
--    return out
-- end
--
-- local function lush_rtp()
--    local rtp = ','..nvim_rtp()..','
--    for k, _ in rtp:gmatch('([^,]+)') do
--       if k:find('lush.nvim$') then
--          do end
--       end
--       print(k, v)
--    end
-- end
--
-- lush_rtp()

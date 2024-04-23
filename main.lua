--[[
  Test build.

  # Information:
    This is for main entry point for project folder. 
    Love2D will look two files by default. As well other files by default preset name files.


]]

-- this is app module 
-- https://www.lua.org/manual/5.4/manual.html#6.3
local app = require 'app'

local text, pos
-- https://opensource.com/article/22/11/lua-command-arguments
-- https://github.com/mpeterv/argparse


-- This is set up application
function love.load(args)
  local msg = args[1] or 'no arguments'

  for l = 1, #arg do
    print(l," ",arg[l])
  end

  text = love.graphics.newText(love.graphics.getFont(), msg)
  pos = {
    x = 50,
    y = 50,
  }

  app:initialize()
end
-- this update game or app logic
function love.update(dt)
  ---
  app:update()
end
-- this is for render draw to display window render image
function love.draw()
  love.graphics.draw(text, pos.x, pos.y)
  ---
  app:draw()
end

function love.quit()
  app:cleanup()
end

--function love.mousepressed(x, y, mouse_button, is_touch)
  --layouter.processMouse(x, y, mouse_button, is_touch)
--end
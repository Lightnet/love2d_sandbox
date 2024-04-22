--[[
  Test build.
]]

--main
local app = require 'app'
local text, pos
-- https://opensource.com/article/22/11/lua-command-arguments
-- https://github.com/mpeterv/argparse
-- 
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

function love.update(dt)
  ---
  app:update()
end

function love.draw()
  love.graphics.draw(text, pos.x, pos.y)
  ---
  app:draw()
end

--function love.mousepressed(x, y, mouse_button, is_touch)
  --layouter.processMouse(x, y, mouse_button, is_touch)
--end
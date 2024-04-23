local love = require 'love'

function Player(debugging)
  local SIZE = 30
  local ANGLE = math.rad(90)

  debugging = debugging or false

  return {
    x = 0,
    y = 0,
    size = SIZE,
    angle = ANGLE,
    draw = function(self)
      local opacity = 1
      love.graphics.setColor(1,1,1, opacity)
    end
  }
end

return Player
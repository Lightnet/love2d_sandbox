---https://love2d.org/wiki/Config_Files
---https://love2d.org/forums/viewtopic.php?t=91415
---works
function love.conf(t)
  print("config...")
  ---t.window.width = 200
  ---t.window.height = 200
  ---t.identity = nil            -- The name of the save directory (string)
  t.console = true
end
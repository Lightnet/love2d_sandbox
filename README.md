# love2d_sandbox

# Created by: Lightnet

# Information:

Work in progress.

Create a rpg card game and network test build?

# Notes paths:
 Love2D has some path fixed to format.

 On windows OS it fixed to project folder and %AppData%  > /Roaming/love/<projectname if set in config>
 
 The reason is the Androind and IOS path is fixed to their own app folder not allow out their app folder without permission access.

 * https://love2d.org/wiki/love.filesystem.getRealDirectory
 * https://love2d.org/forums/viewtopic.php?t=91415

# vscode shortcut keys:
  Note ext plugins need for easy to read lua.
```
Crtl + Shift + B
```
 Run task build.

# Windows Data APP:
```
%appData/Love/*game identity*/
```

conf.lua
```lua
function love.conf(t)
  t.identity = "ok" --name of the application
end
```
# Note file:
 * LÖVE has it's own love.filesystem.
 * io.open (not use use love api)
 * https://love2d.org/wiki/love.filesystem.read

# run (windows):

```
./love.exe .
```
  Current Project folder. Run game that has file name main.lua.

```
zip file = main.love
```

# Links:

- https://love2d.org/wiki/L%C3%96VE_Game_File
- https://codeberg.org/1414codeforge/yui
- https://love2d.org/wiki/Main_Page
- https://love2d.org/wiki/Getting_Started
- https://love2d.org/forums/viewtopic.php?t=91336

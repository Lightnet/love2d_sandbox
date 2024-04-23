-- https://www.youtube.com/watch?v=wttKHL90Ank
-- https://www.youtube.com/watch?v=vMSjVuJ6wDs
-- https://github.com/semanticdata/love2d-mmbn-combat-boilerplate
-- https://www.youtube.com/watch?v=d-geCesItCc
-- https://love2d.org/wiki/lua-enet

local network = require 'libraries/network'
local enet = require "enet"
local World = require 'World'
local Component = require 'Component'
local System = require 'System'
local coms = require 'common_components'

print("init app...")
local app = {
  _NAME = "app",
  _DESCRIPTION = 'Library for LÖVE 2D Game Engine',
  _VERSION = "0.0.1",
  _LICENSE = "MIT",
  _LOVE = 11.5,
}

--///////////////////////////////////////////////
--///////////////////////////////////////////////
-- function setPaused()
--   game:changeGameState("paused")
-- end
-- function setPaused()
--   game:changeGameState("running")
-- end

local host = nil
local server = nil
local network_type = "none"

local enet_server = {}
local enet_client = {}

function enet_server:setup()
  -- establish host for receiving msg
  host = enet.host_create("localhost:6750")
  network_type = "server"
end

function enet_server:update()
  local event = host:service(100)
  if event then
    print("Server detected message type: " .. event.type)
    if event.type == "connect" then
      print(event.peer, "connected.")
    end
    if event.type == "receive" then
      print("Received message: ", event.data, event.peer)
      --event.peer:send(event.data)
    end
    if event.type == "disconnect" then
      print(event.peer, "disconnected.")
    end
  end
end

function enet_server:send(msg)
  print(host)
  for peerIndex = 1, host:peer_count() do
    local peer = host:get_peer(peerIndex)
    if peer then
      peer:send(msg)
    end
  end
end

--send disconnect message to clients?
function enet_server:cleanup()
  for peerIndex = 1, host:peer_count() do
    local peer = host:get_peer(peerIndex)
    if peer then
      peer:disconnect_now()
    end
  end
  host:flush()
end

function enet_client:setup()
  -- establish a connection to host on same PC
  host = enet.host_create()
  server = host:connect("localhost:6750")
  network_type = "client"
end

function enet_client:update()
  local event = host:service(100)
  if event then
    print("Server detected message type: " .. event.type)
    if event.type == "connect" then
      print("Connected to", event.peer)
      --event.peer:send("hello world")
    end
    if event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      --done = true
    end
    if event.type == "disconnect" then
      print(event.peer, "disconnected.")
    end
  end
end

function enet_client:send(msg)
  if server then
    host:service(100)
    server:send(msg)
  end
end

function enet_client:cleanup()
  server:disconnect()
  host:flush()
end

function NetworkSend(msg)
  if network_type == "server" then
    enet_server:send(msg)
  end
  if network_type == "client" then
    enet_client:send(msg)
  end
end



BUTTON_HEIGHT = 64

local function newButton(text, fn)
  return {
    text = text,
    fn = fn,
    now = false,
    last = false
  }
end

local buttons = {}
local font = nil
local menu_state = "network"

function init_main_menu()
  font = love.graphics.newFont(32)
  --reddice1 = love.graphics.newImage("assets/kenney_boardgame-pack/PNG/Dice/dieRed1.png")

  table.insert(buttons, newButton(
    "Start Game",
    function()
      print("Starting Game")
    end
  ))

  table.insert(buttons, newButton(
    "Loading Game",
    function()
      print("Loading Game")
    end
  ))
  table.insert(buttons, newButton(
    "Settings",
    function()
      print("Settings Menu")
    end
  ))
  table.insert(buttons, newButton(
    "Quit",
    function()
      print("Quit")
      love.event.quit(0)
    end
  ))
end

function draw_main_menu()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  local button_width = ww * (1 / 3)

  --love.graphics.print('Hello World!', 400, 300)
  --love.graphics.draw(reddice1, 300, 200)
  --love.graphics.draw(reddice1, 300, 250)
  local margin = 16
  local total_height = (BUTTON_HEIGHT + margin) * #buttons
  local cursor_y = 0

  for i, button in ipairs(buttons) do
    button.last = button.now
    local bx = (ww * 0.5) - (button_width * 0.5)
    local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

    local color = { 0.4, 0.4, 0.5, 1.0 }

    local mx, my = love.mouse.getPosition()

    local hot = mx > bx and mx < bx + button_width and
        my > by and my < by + BUTTON_HEIGHT

    if hot then
      color = { 0.8, 0.8, 0.9, 1.0 }
    end

    button.now = love.mouse.isDown(1)
    if button.now and not button.last and hot then
      button.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
      "fill",
      bx,
      by,
      button_width,
      BUTTON_HEIGHT
    )
    love.graphics.setColor(0, 0, 0, 1)

    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)

    love.graphics.print(
      button.text,
      font,
      (ww * 0.5) - textW * 0.5,
      by + textH * 0.5
    )

    cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
  end
end

--[[
  CHAT MENU
]]

local font_chat = nil
local chat_buttons = {}
local net_buttons = {}

local function uiButton(text, fn)
  return {
    text = text,
    fn = fn,
    now = false,
    last = false
  }
end

function init_network_menu()
  font_chat = love.graphics.newFont(24)
  table.insert(net_buttons, uiButton(
    "Host",
    function()
      print("Host")
      menu_state = "chat"
      enet_server:setup()
    end
  ))

  table.insert(net_buttons, uiButton(
    "Join",
    function()
      print("Join")
      menu_state = "chat"
      enet_client:setup()
    end
  ))

  table.insert(net_buttons, uiButton(
    "Exit",
    function()
      print("Exit")
    end
  ))
end

function draw_network_menu()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  local button_width = ww * (1 / 3)

  --love.graphics.print('Hello World!', 400, 300)
  --love.graphics.draw(reddice1, 300, 200)
  --love.graphics.draw(reddice1, 300, 250)
  local margin = 16
  local total_height = (BUTTON_HEIGHT + margin) * #net_buttons
  local cursor_y = 0

  for i, button in ipairs(net_buttons) do
    button.last = button.now
    local bx = (ww * 0.5) - (button_width * 0.5)
    local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

    local color = { 0.4, 0.4, 0.5, 1.0 }

    local mx, my = love.mouse.getPosition()

    local hot = mx > bx and mx < bx + button_width and
        my > by and my < by + BUTTON_HEIGHT

    if hot then
      color = { 0.8, 0.8, 0.9, 1.0 }
    end

    button.now = love.mouse.isDown(1)
    if button.now and not button.last and hot then
      button.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
      "fill",
      bx,
      by,
      button_width,
      BUTTON_HEIGHT
    )
    love.graphics.setColor(0, 0, 0, 1)

    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)

    love.graphics.print(
      button.text,
      font,
      (ww * 0.5) - textW * 0.5,
      by + textH * 0.5
    )

    cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
  end
end

function init_chat_menu()
  table.insert(chat_buttons, uiButton(
    "Ping",
    function()
      print("Ping")
      NetworkSend("pingme")
    end
  ))
  table.insert(chat_buttons, uiButton(
    "Send",
    function()
      print("Send")
      NetworkSend("send")
    end
  ))
  table.insert(chat_buttons, uiButton(
    "Exit",
    function()
      print("Exit")
    end
  ))
end

function draw_chat_menu()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  local button_width = ww * (1 / 3)

  --love.graphics.print('Hello World!', 400, 300)
  --love.graphics.draw(reddice1, 300, 200)
  --love.graphics.draw(reddice1, 300, 250)
  local margin = 16
  local total_height = (BUTTON_HEIGHT + margin) * #chat_buttons
  local cursor_y = 0

  for i, button in ipairs(chat_buttons) do
    button.last = button.now
    local bx = (ww * 0.5) - (button_width * 0.5)
    local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

    local color = { 0.4, 0.4, 0.5, 1.0 }

    local mx, my = love.mouse.getPosition()

    local hot = mx > bx and mx < bx + button_width and
        my > by and my < by + BUTTON_HEIGHT

    if hot then
      color = { 0.8, 0.8, 0.9, 1.0 }
    end

    button.now = love.mouse.isDown(1)
    if button.now and not button.last and hot then
      button.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
      "fill",
      bx,
      by,
      button_width,
      BUTTON_HEIGHT
    )
    love.graphics.setColor(0, 0, 0, 1)

    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)

    love.graphics.print(
      button.text,
      font,
      (ww * 0.5) - textW * 0.5,
      by + textH * 0.5
    )

    cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
  end
end

function new_renderer_system()
  local renderer = System.new {"body", "rect"}

  function renderer:load(entity)
    print "found one!"
  end

  function renderer:draw(entity)
    local body = entity:get "body"
    love.graphics.rectangle('fill', body.x,body.y,32,32)
  end

  return renderer
end

function new_functional_system()
  local system = System.new {"functional"}

  function system:load(entity)
    print "found one!"
  end

  function system:update(dt, entity)
    local fn = entity:get("functional").fn
    fn(entity, dt)
  end

  return system
end

-- @param table options
function app:initialize(options)

  World:register(new_renderer_system())
  World:register(new_functional_system())

  -- local entity0 = World:create()
  -- entity0:add(new_body(100,100))
  -- entity0:add(new_rectangle_component())

  -- local entity1 = World:create()
  -- entity1:madd(new_body(100,100))
  --   :madd(new_rectangle_component())
  World:create()
  :madd(coms.new_body(100,100))
  :madd(coms.new_rectangle_component())

  --local test = World:assemble(player_type)

  local test2 = World:assemble {
    {coms.new_body, 300, 100},
    {coms.new_rectangle_component}
  }

  test2:add(coms.functional(function(self, dt)
    --print("hello world")
    local body = self:get "body"
    body.x = body.x + dt * 10
  end))


  --init_main_menu()
  font = love.graphics.newFont(24)
  init_network_menu()
  init_chat_menu()
end

function app:update(dt)

  World:update(dt)

  -- if game.state.running then
  -- end

  if network_type == "server" then
    enet_server:update()
  end
  if network_type == "client" then
    enet_client:update()
  end
end

function app:draw()
  World:draw()
  --draw_main_menu()

  if menu_state == "network" then
    draw_network_menu()
  end

  if menu_state == "chat" then
    draw_chat_menu()
  end
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.print(network_type)
end

function app:cleanup()
  print("clean up")
  if network_type == "server" then
    enet_server:cleanup()
  end
  if network_type == "client" then
    enet_client:cleanup()
  end
end

return app

-- local tiny = require("tiny")
-- local function test_stuff()
--   a = {}    -- new array
--   for i=1, 1000 do
--     a[i] = 0
--   end
--   print(a)

-- end

-- function love.load()
--   reddice1 = love.graphics.newImage("assets/kenney_boardgame-pack/PNG/Dice/dieRed1.png")
--   test_stuff()
-- end

-- function love.update(dt)
--   ---ui:update(dt)
--   ---world:update(1)
-- end

-- function love.draw()
--   love.graphics.print('Hello World!', 400, 300)
--   love.graphics.draw(reddice1, 300, 200)
--   --layouter.draw()
-- end

-- function love.mousepressed(x, y, mouse_button, is_touch)
--   --
-- end

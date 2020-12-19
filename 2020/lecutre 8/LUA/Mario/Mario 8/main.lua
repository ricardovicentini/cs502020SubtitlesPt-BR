WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'packages/class'
push = require 'packages/push'


require 'Map'

function love.load()
  
  math.randomseed(os.time())
  map = Map()

  --apply a pixilation filter 
  love.graphics.setDefaultFilter('nearest','nearest')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  love.keyboard.keysPressed[key] = true
end

function love.update(dt)
  map:update(dt)
  love.keyboard.keysPressed = {}
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.draw()
  love.graphics.clear(108/255, 140/255, 255/255, 255/255)
  --love.graphics.print('x: '.. -map.camX .. ', y: ' .. -map.camY)
  
  

  push:start()
  
  love.graphics.translate(math.floor(-map.camX + 0.5),math.floor(-map.camY + 0.5))
  
  map:render()
  push:finish()
  
end
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'packages/class'
push = require 'packages/push'

require 'Util'
require 'Map'

function love.load()
  map = Map()

  --apply a pixilation filter 
  love.graphics.setDefaultFilter('nearest','nearest')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.update(dt)
  map:update(dt)
  
end

function love.draw()
  love.graphics.clear(108/255, 140/255, 255/255, 255/255)
  love.graphics.print('x: '.. -map.camX .. ', y: ' .. -map.camY)
  

  push:start()
  
  love.graphics.translate(math.floor(-map.camX + 0.5),math.floor(-map.camY + 0.5))
  
  map:render()
  push:finish()
  
end
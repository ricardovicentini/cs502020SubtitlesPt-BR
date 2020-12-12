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

end

function love.draw()
  push:start()
  love.graphics.clear(108/255, 140/255, 1, 1)
  map:render()
  push:finish()
end
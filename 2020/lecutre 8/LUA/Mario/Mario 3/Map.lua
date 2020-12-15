require 'Util'
require 'Player'

Map = Class{}



TILE_BRICK = 1
TILE_EMPTY = 4

CLOUD_LEFT = 6
CLOUD_RIGHT = 7

BUSH_LEFT = 2
BUSH_RIGHT = 3

MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

JUMP_BLOCK = 5

local SCROLL_SPEED = 62

function Map:init()
  self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
  self.tileWidth = 16
  self.tileHeight = 16
  self.mapWidth = 30
  self.mapHeight = 28
  self.tiles = {}

  self.player = Player(self)

  self.camX = 0
  self.camY = -3

  self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

  self.mapWidthPixels = self.mapWidth * self.tileWidth
  self.mapHeightPixels = self.mapHeight * self.tileHeight

  --filling the game map with empty tiles
  for y = 1, self.mapHeight do
    for x = 1, self.mapWidth do
      self:setTile(x, y, TILE_EMPTY)
    end
  end

  --Terrain generation
  local x = 1
  while x < self.mapWidth do
        
    -- 2% chance to generate a cloud
    -- make sure we're 2 tiles from edge at least
    if x < self.mapWidth - 2 then
      if math.random(20) == 1 then
          
        -- choose a random vertical spot above where blocks/pipes generate
        local cloudStart = math.random(self.mapHeight / 2 - 6)

        self:setTile(x, cloudStart, CLOUD_LEFT)
        self:setTile(x + 1, cloudStart, CLOUD_RIGHT)
      end
    end

    -- 5% chance to generate a mushroom
    if math.random(20) == 1 then
      -- left side of pipe
      self:setTile(x, self.mapHeight / 2 - 2, MUSHROOM_TOP)
      self:setTile(x, self.mapHeight / 2 - 1, MUSHROOM_BOTTOM)

      -- creates column of tiles going to bottom of map
      self:createBrickColumn(x)
      
      -- next vertical scan line
      x = x + 1

    -- 10% chance to generate bush, being sure to generate away from edge
    elseif math.random(10) == 1 and x < self.mapWidth - 3 then
      local bushLevel = self.mapHeight / 2 - 1

      -- place bush component and then column of bricks
      self:setTile(x, bushLevel, BUSH_LEFT)
      self:createBrickColumn(x)
      x = x + 1

      self:setTile(x, bushLevel, BUSH_RIGHT)
      self:createBrickColumn(x)
      x = x + 1

    -- 10% chance to not generate anything, creating a gap
    elseif math.random(10) ~= 1 then
        
      -- creates column of tiles going to bottom of map
      self:createBrickColumn(x)

      -- chance to create a block for Mario to hit
      if math.random(15) == 1 then
          self:setTile(x, self.mapHeight / 2 - 4, JUMP_BLOCK)
      end

      -- next vertical scan line
      x = x + 1
    else
        -- increment X so we skip two scanlines, creating a 2-tile gap
      x = x + 2
    end
  end
  

end

function Map:update(dt)
  if love.keyboard.isDown('w') then
    self.camY = math.max(0, self.camY + dt * -SCROLL_SPEED)
  elseif love.keyboard.isDown('a') then
    self.camX = math.max(0, self.camX + dt * -SCROLL_SPEED)
  elseif love.keyboard.isDown('s') then
    self.camY = math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, self.camY + dt * SCROLL_SPEED)
  elseif love.keyboard.isDown('d') then
    self.camX = math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.camX + dt * SCROLL_SPEED)
  end
  
  self.player:update(dt)
end

function Map:setTile(x, y, tile)
  self.tiles[(y - 1) * self.mapWidth + x] = tile
end

function Map:getTile(x, y)
  return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:render()
  for y = 1, self.mapHeight do
    for x = 1, self.mapWidth do
      love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
        (x - 1) * self.tileWidth, (y - 1) * self.tileHeight
      )
    end
  end

  self.player:render()
end

function Map:createBrickColumn(column)
  for y = self.mapHeight / 2, self.mapHeight do
    self:setTile(column, y, TILE_BRICK)
  end
end


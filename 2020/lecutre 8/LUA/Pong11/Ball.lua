Ball = Class{}

local sounds = {
  ['paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
  ['point_score'] = love.audio.newSource('goal.wav', 'static'),
  ['wall_hit'] = love.audio.newSource('hit edge.wav', 'static')
  
}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height 

  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50)
end

function Ball:collides(box)
  if self.x > box.x + box.width or self.x + self.width < box.x then
      return false
  end

  if self.y > box.y + box.height or self.y + self.height < box.y then
    return false
  end

  return true

end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50)
  sounds['point_score']:play()
end

function Ball:deflect()
  self.dx = - self.dx * 1.03
  if(self.dy < 0) then
    self.dy = - math.random(10, 150)
  else
    self.dy = math.random(10, 150)
  end
  sounds['paddle_hit']:play()
end


function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if ball.y <= 0 then
    ball.dy = - ball.dy
    sounds['wall_hit']:play()
  end

  if ball.y >= VIRTUAL_HEIGHT - 4 then
    ball.dy = - ball.dy
    sounds['wall_hit']:play()
  end
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
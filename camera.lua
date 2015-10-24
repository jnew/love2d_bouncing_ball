camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.world = {xmin = 0, ymin = 0, xmax = 1750, ymax = 1050}

function camera:set()
  self:boundry_check()
  local cx,cy = love.graphics.getWidth()*((1-self.scaleX)/2)*(1/self.scaleX), love.graphics.getHeight()*((1-self.scaleY)/2)*(1/self.scaleY)
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(self.scaleX, self.scaleY)
  love.graphics.translate(cx, cy)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:boundry_check()
  if (self.x + love.graphics.getWidth()) > self.world.xmax then
    self.x = self.world.xmax - love.graphics.getWidth()
  elseif (self.x) < self.world.xmin then
    self.x = self.world.xmin
  end

  if (self.y + love.graphics.getHeight()) > self.world.ymax then
    self.y = self.world.ymax - love.graphics.getHeight()
  elseif (self.y) < self.world.xmin then
    self.y = self.world.ymin
  end
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:centered_zoom(s)
  self.scaleX = self.scaleX * s
  self.scaleY = self.scaleY * s
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:center_on_point(x, y)
  self.x = (love.graphics.getWidth()*-0.5) + x
  self.y = (love.graphics.getHeight()*-0.5) + y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end


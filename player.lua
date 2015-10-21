player = {}
-- defaults
player.height = 100
player.width = 50
player.x = 0
player.y = 0
player.max_speed = 10
player.accelleration = 2
player.velocity = 0

function player:new (new_player, height, width, x, y, speed)
      new_player = new_player or {}   -- create object if user does not provide one
      setmetatable(new_player, self)
      self.__index = self
      new_player.height = height or player.height
      new_player.width = width or player.width
      new_player.x = x or player.x
      new_player.y = y or player.y
      return new_player
    end

function player:update()
	--[[
	if love.keyboard.isDown("down") then
		self.y = 
	up = love.keyboard.isDown("up")
	self.x = self.x + self.speed
	]]
end

function player:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
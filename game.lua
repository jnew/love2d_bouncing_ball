--[[
	file: game.lua
	description: main game logic
]]

require "camera"
require "player"
local sti = require "lib.sti"

game = {}
game.world = {}
game.map = {}
game.world_objects = {}
game.title = "Love2D Exploration"
game.width = 1750
game.height = 1025
game.seconds_per_update = 0.008
game.lag_in_seconds = 0
game.state = "NO_BALL"
game.font = love.graphics.newFont(36)
love.graphics.setFont(game.font)
game.game_message = "B: Spawn Ball\nD: De-spawn Ball\nUp: Reset Ball\nLeft: Push Ball Left\nRight: Push Ball Right\nDown: Push Ball Down"

function game:init_window()
	love.window.setTitle(self.title)
	success = love.window.setMode(1280, 720)
	camera:center_on_point(875, 525)
	return success
end

function game:init_world()
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  	self.world = love.physics.newWorld(0, 9.81*64, true)
  	self.map = sti.new("assets/tilemaps/test_level_2.lua", {"box2d"})
  	self.map:box2d_init(self.world)

  	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
 --  	self.world_objects.ground = {}
	-- self.world_objects.ground.body = love.physics.newBody(self.world, self.width/2, self.height-100) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	-- self.world_objects.ground.shape = love.physics.newRectangleShape(self.width-200, 50) --make a rectangle with a width of 650 and a height of 50
	-- self.world_objects.ground.fixture = love.physics.newFixture(self.world_objects.ground.body, self.world_objects.ground.shape) --attach shape to body
end

function game:update_world(dt)
	self.map:update(dt)
	if self.state == "NO_BALL" then
		if love.keyboard.isDown('b') then
			self:spawn_ball()
			self.state = "BALL"
		end
	else
		if love.keyboard.isDown('d') then
			self:despawn_ball()
			self.state = "NO_BALL"
		elseif love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    		self.world_objects.ball.body:applyForce(200, 0)
  		elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    		self.world_objects.ball.body:applyForce(-200, 0)
    	elseif love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
    		self.world_objects.ball.body:applyForce(0, 200)
  		elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    		self.world_objects.ball.body:setPosition(self.width/2, self.height/4)
    		self.world_objects.ball.body:setLinearVelocity(0, 0) --we must set the velocity to zero to prevent a potentially large velocity generated by the change in position
  		end
	end
	self.world:update(dt)
end

function game:update_camera(dt)
	if love.keyboard.isDown('a') then
		camera:move(-5,0)
	elseif love.keyboard.isDown('s') then
		camera:move(5,0)
	end
	if self.state == "BALL" then
		camera:center_on_point(self.world_objects.ball.body:getX(), self.world_objects.ball.body:getY())
	end
end

function game:spawn_ball()
	self.world_objects.ball = {}
	self.world_objects.ball.body = love.physics.newBody(self.world, self.width/2, self.height/4, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	self.world_objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
	self.world_objects.ball.fixture = love.physics.newFixture(self.world_objects.ball.body, self.world_objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	self.world_objects.ball.fixture:setRestitution(0.9) --let the ball bounce
	self.world_objects.ball.color = {193, 47, 14}
end

function game:despawn_ball()
	self.world_objects.ball = nil
end

function game:bounce_ball()

end

function game:draw_world()
	camera:set()
	self.map:draw()
	self.map:box2d_draw()
	local width = self.font:getWidth(self.game_message)
	love.graphics.print(self.game_message, (game.width-width)/2, game.height/6)
	for key, value in pairs(self.world_objects) do
		if value.body ~= nil and value.shape ~= nil and value.fixture ~= nil then
			shape_type = value.shape:type()
			if value.color ~= nil then
				love.graphics.setColor(value.color)
			else
			    love.graphics.setColor(255,255,255)
			end
			if shape_type == "PolygonShape" then
				love.graphics.polygon("fill", value.body:getWorldPoints(value.shape:getPoints()))
			elseif shape_type == "CircleShape" then
				love.graphics.circle("fill", value.body:getX(), value.body:getY(), value.shape:getRadius())
			else
				-- do nothing
			end
		end
	end
	camera:unset()
end
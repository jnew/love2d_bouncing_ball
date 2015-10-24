--[[
	file: main.lua
	description: callbacks for the Love2D game loop
]]

require "game"

--RUN ONCE
function love.load()
	if game:init_window() ~= true then -- something is wrong, just quit
		love.event.quit()
	end
	game:init_world()
end

-- MAIN GAME LOOP BEGIN

--UPDATE LOOP
function love.update(dt) -- dt is delta time
	--game.lag_in_seconds = game.lag_in_seconds + dt
	--while(game.lag_in_seconds >= game.seconds_per_update) do
		game:update_world(dt)
		game:update_camera(dt)
		--game.lag_in_seconds = game.lag_in_seconds - game.seconds_per_update
	--end
end

--RENDER LOOP
function love.draw()
	game:draw_world()
end

function love.quit()
end

-- MAIN GAME LOOP END
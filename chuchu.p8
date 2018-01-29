pico-8 cartridge // http://www.pico-8.com
version 15
__lua__

mouse = {}
mouse.x = 80
mouse.y = 24
mouse.sprite = 16
mouse.speed = 1
-- 1 = up, 2 = right, 3 = down, 4 = left
mouse.direction = 2
mouse.frame = 0
mouse.frames = 2

-- see if mouse hits a wall
function flipmouse()
	x_check = 0
	y_check = 0

	if not (flr(mouse.x) % 8 == 0 and flr(mouse.y) % 8 == 0) then
		return
	end

	-- mouse has arrived on a new tile, what's
	-- on the next tile?
	if(mouse.direction == 1) then
		y_check = -1
	end
	if(mouse.direction == 2) then
		x_check = 1
	end
	if(mouse.direction == 3) then
		y_check = 1
	end
	if(mouse.direction == 4) then
		x_check = -1
	end

	next_tile = mget((mouse.x / 8) + x_check, (mouse.y / 8) + y_check)
	current_tile = mget((mouse.x / 8), (mouse.y / 8))

	if(next_tile == 1) then
		mouse.direction += 1
		if(mouse.direction > 4) then
			mouse.direction = 1
		end
		-- we turned, now check tile in new direction
		flipmouse()
	end

	if(current_tile >= 2 and current_tile <= 5) then
		mouse.direction = current_tile - 1
	end

end

function mousemove()
	-- animate through three frames
	mouse.frame += 1
	if(mouse.frame == mouse.frames) then
	    mouse.sprite += 1
	    mouse.frame = 0
	end
	if mouse.sprite > 19 then
	    mouse.sprite = 16
	end

	flipmouse()

	-- move mouse depending on mouse.direction
	if mouse.direction == 1 then
		mouse.y -= mouse.speed
	end
	if mouse.direction == 2 then
		mouse.x += mouse.speed
	end
	if mouse.direction == 3 then
		mouse.y += mouse.speed
	end
	if mouse.direction == 4 then
		mouse.x -= mouse.speed
	end
end


function _update()
	mousemove()
end

function _draw()
	cls()
	map(0, 0, 0, 0, 16, 16)
	spr(mouse.sprite, mouse.x, mouse.y)
end

function _init()
end

__gfx__
00000000444f4444cccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f4040f04ccc11cccc1cc1cccc1cccc1cccc1cc1c00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004440444fcc1cc1cccc1cc1cccc1cc1cccc1cc1cc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044044f44c1cccc1cccc1cc1cccc11cccc1cc1ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044f44044ccc11cccccc1cc1cc1cccc1cc1cc1ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000040444444cc1cc1cccc1cc1cccc1cc1cccc1cc1cc00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004f0f4404c1cccc1cc1cc1cccccc11cccccc1cc1c00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000444f444cccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
09999990099999900999999009999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99799799997997999979979999799799000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99199199991991999919919999199199000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99911999999119999991199999911999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09990999999099909909990990999099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900090090009009000900000090009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000100000000000001040000050100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000003000000000200000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000100000300000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000005000000000000020100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000010000000001010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000001000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

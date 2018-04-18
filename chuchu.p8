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
mouse.finished = 0

pointer = {}
pointer.x = 1 -- matches map location
pointer.y = 1 -- matches map location
pointer.sprite = 6
pointer.frames = 3
pointer.frame = pointer.frames
dirsprite = 0

tiles = {}
tiles.history = {}
tiles.max = 4

flashcolor = 0

-- place a direction tile
function placetile()
	if(mget(pointer.x, pointer.y, dirsprite) ~= 1) then
		pointer.sprite = 7
		mset(pointer.x, pointer.y, dirsprite)
	end
end

-- move pointer
function movepointer()
	-- use mouse animation threshold to poll controls
	pointer.frame -= 1
	if (pointer.frame ~= 0) return
	pointer.frame = pointer.frames

	-- if button is pushed, let player select a direction tile
	if (btn(4)) then
		if (btn(0)) dirsprite = 5 -- left
		if (btn(1)) dirsprite = 3 -- right
		if (btn(2)) dirsprite = 2 -- up
		if (btn(3)) dirsprite = 4 -- down

		placetile()
	else
		-- place direction tile
		if(pointer.sprite ~= 6) then
			pointer.sprite = 6

			if(dirsprite ~= 0) then
				dirsprite = 0
				add(tiles.history, { pointer.x, pointer.y })

				-- remove oldest direction tile
				if(#tiles.history > tiles.max) then
					-- remove from playing field the oldest item in
					-- the table by sticking a blank sprite on the
					-- map for its x and y coordinates...
					mset(tiles.history[1][1], tiles.history[1][2], 0)
					-- ...and removing it from the table
					del(tiles.history, tiles.history[1])
				end
			end
		end

		-- get direction from player
		if (btn(0)) pointer.x -= 1
		if (btn(1)) pointer.x += 1
		if (btn(2)) pointer.y -= 1
		if (btn(3)) pointer.y += 1

		-- stay inside playable area
		if (pointer.x == 0) pointer.x = 1
		if (pointer.y == 0) pointer.y = 1
		if (pointer.x == 15) pointer.x = 14
		if (pointer.y == 15) pointer.y = 14
	end
end

-- see if mouse needs to change direction
function flipmouse()
	local x_check = 0
	local y_check = 0

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

	-- Did mouse go into mousehole?
	if(current_tile == 8) then
		mouse.finished = 1
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
	if(mouse.finished == 0) then
		mousemove()
	end
	movepointer()
end

function _draw()
	cls()
	map(0, 0, 0, 0, 16, 16)
	spr(mouse.sprite, mouse.x, mouse.y)
	spr(pointer.sprite, (pointer.x * 8), (pointer.y * 8))

	if(mouse.finished == 1) then
		flashcolor = flashcolor + 1
		if(flashcolor > 16) flashcolor = 0
		print("SUPER VERYGOOD!", 32, 48, flashcolor)
	end
end

function _init()
end

__gfx__
00000000444f4444cccccccccccccccccccccccccccccccc6666666688888888000ee00000000000000000000000000000000000000000000000000000000000
00000000f4040f04ccc11cccc1cc1cccc1cccc1cccc1cc1c600000078000000e00e22e0000000000000000000000000000000000000000000000000000000000
000000004440444fcc1cc1cccc1cc1cccc1cc1cccc1cc1cc600000078000000e0e2222e000000000000000000000000000000000000000000000000000000000
0000000044044f44c1cccc1cccc1cc1cccc11cccc1cc1ccc600000078000000ee22ee22e00000000000000000000000000000000000000000000000000000000
0000000044f44044ccc11cccccc1cc1cc1cccc1cc1cc1ccc600000078000000ee22ee22e00000000000000000000000000000000000000000000000000000000
0000000040444444cc1cc1cccc1cc1cccc1cc1cccc1cc1cc600000078000000e0e2222e000000000000000000000000000000000000000000000000000000000
000000004f0f4404c1cccc1cc1cc1cccccc11cccccc1cc1c600000078000000e00e22e0000000000000000000000000000000000000000000000000000000000
000000000444f444cccccccccccccccccccccccccccccccc677777778eeeeeee000ee00000000000000000000000000000000000000000000000000000000000
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
0100000100000000000001000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000100000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000010000000001010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000080000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000001000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

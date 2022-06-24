-- https://github.com/Ulydev/push
push = require 'push'

--[[
    game real window is reduced to present the game in window mode with 80% the size of the user screen
]]
local windowWidth, windowHeight = love.window.getDesktopDimensions()
WINDOW_WIDTH = windowWidth*.8
WINDOW_HEIGHT = windowHeight*.8

--[[
    game actual render window size, set to give retro vibes at a lower quality( values are the original pong resolution 858x525)
]]
VIRTUAL_WIDTH = 858
VIRTUAL_HEIGHT = 525

local n 
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    n = 0
end

function love.update(dt)
    n = n + 1
end

function love.draw()
    push:apply('start')
    love.graphics.printf(
        'PONG',
        0,
        VIRTUAL_HEIGHT / 2 -6,
        VIRTUAL_WIDTH,
        'center'
    )

    nString = 'n:' .. n
    love.graphics.printf(
        nString,
        8,
        4,
        VIRTUAL_WIDTH,
        'left'
    )
    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
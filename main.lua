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

BASE_FONT = love.graphics.newFont('PixBob-Lite.ttf', 32)
TOOLS_FONT = love.graphics.newFont('PixBob-Lite.ttf', 16)

local updateNum 
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.graphics.setFont(BASE_FONT)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    updateNum = 0
end

function love.update(dt)
    updateNum = updateNum + 1
end

function love.draw()
    push:apply('start')

    DrawTitle()
    DrawUpdates()
    DrawFps()
    
    push:apply('end')
end

function DrawTitle()
    love.graphics.printf(
        'PONG',
        0,
        8,
        VIRTUAL_WIDTH,
        'center'
    )
end

function DrawUpdates()
    local nString = 'upd No ' .. updateNum
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        nString,
        8,
        4,
        VIRTUAL_WIDTH,
        'left'
    )
    ClearFont()
end

function DrawFps()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        'FPS ' .. tostring(love.timer.getFPS( )),
        8,
        24,
        VIRTUAL_WIDTH,
        'left'
    )
    ClearFont()
end

function ClearFont()
    love.graphics.setFont(BASE_FONT)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
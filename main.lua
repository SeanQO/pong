--[[
    https://github.com/Ulydev/push
    'push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution.'
    push library is used to render a game with a fixed virtual resolution. The desired retro low res render is keept instead of however large the user window is. 
]]
push = require 'push'

--game real window is reduced to present the game in window mode with 80% the size of the user screen
local windowWidth, windowHeight = love.window.getDesktopDimensions()
WINDOW_WIDTH = windowWidth*.8
WINDOW_HEIGHT = windowHeight*.8

--game actual render window size, set to give retro vibes at a lower quality( values are the original pong resolution 858x525)
VIRTUAL_WIDTH = 858
VIRTUAL_HEIGHT = 525

--[[
    https://www.dafont.com/es/bitmap.php
    https://dl.dafont.com/dl/?f=pixbob_lite - Pixbob Lite from Habib Khoirul Fajar
]]
BASE_FONT = love.graphics.newFont('PixBob-Lite.ttf', 32)
TOOLS_FONT = love.graphics.newFont('PixBob-Lite.ttf', 16)

-- global variable for the game border
BOARD_BORDER = 4

--global variable to keep track of the number of updates since the game started runing.
local updateNum

function TableColorOf(r,g,b)
    red = r/255
    green = g/255
    blue = b/255

    return { red, green, blue} 
end

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
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.clear(TableColorOf(26, 26, 26))
    DrawBoard()
    DrawTitle()
    DrawPaddles()
    DrawUpdates()
    DrawFps()
    
   

    push:apply('end')
end

function DrawPaddles()
    love.graphics.rectangle('fill',
    10 + BOARD_BORDER,
    60 + BOARD_BORDER,
    10,
    40
    )

    love.graphics.rectangle('fill',
    VIRTUAL_WIDTH - (10 + BOARD_BORDER) - 10 ,
    VIRTUAL_HEIGHT - (40 + BOARD_BORDER) - 60,
    10,
    40
    )

    love.graphics.rectangle('fill',
    (VIRTUAL_WIDTH - (BOARD_BORDER*2)) / 2 - 4,
    (VIRTUAL_HEIGHT - (BOARD_BORDER*2)) / 2 - 4,
    8,
    8
    )
    
end

function DrawBoard()
    love.graphics.rectangle(
        'fill',
        0,
        0,
        VIRTUAL_WIDTH,
        BOARD_BORDER
    )

    love.graphics.rectangle(
        'fill',
        0,
        0,
        BOARD_BORDER,
        VIRTUAL_HEIGHT
    )
    
    love.graphics.rectangle(
        'fill',
        0,
        VIRTUAL_HEIGHT - BOARD_BORDER,
        VIRTUAL_WIDTH,
        BOARD_BORDER
    )

    love.graphics.rectangle(
        'fill',
        VIRTUAL_WIDTH - BOARD_BORDER,
        0,
        BOARD_BORDER,
        VIRTUAL_HEIGHT
    )
end

function DrawTitle()
    love.graphics.setFont(BASE_FONT)
    love.graphics.printf(
        'PONG',
        0 + BOARD_BORDER,
        8 + BOARD_BORDER,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'center'
    )
end

function DrawUpdates()
    local nString = 'upd No ' .. updateNum
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        nString,
        8 + BOARD_BORDER,
        4 + BOARD_BORDER,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'left'
    )
end

function DrawFps()
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        'FPS ' .. tostring(love.timer.getFPS( )),
        8 + BOARD_BORDER,
        24 + BOARD_BORDER,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'left'
    )
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
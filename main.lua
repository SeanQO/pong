--[[
    https://github.com/Ulydev/push
    'push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution.'
    push library is used to render a game with a fixed virtual resolution. The desired retro low res render is keept instead of however large the user window is. 
]]
local push = require 'push'

--game real window is reduced to present the game in window mode with 80% the size of the user screen

local WINDOW_WIDTH
local WINDOW_HEIGHT

--game actual render window size, set to give retro vibes at a lower quality( values are the original pong resolution 858x525)
local VIRTUAL_WIDTH
local VIRTUAL_HEIGHT

--[[
    https://www.dafont.com/es/bitmap.php
    https://dl.dafont.com/dl/?f=pixbob_lite - Pixbob Lite from Habib Khoirul Fajar
]]
local BASE_FONT
local TOOLS_FONT

-- global variable for the game border
local BOARD_BORDER

-- Speed of the moving paddles
local SPEED_PADDLE
-- Speed of the moving ball
local SPEED_BALL

local score_p1
local score_p2

local paddleLY
local paddleRY

function TableColorOf(r,g,b)
    local red = r/255
    local green = g/255
    local blue = b/255

    return { red, green, blue} 
end

function love.load()
    local userWindowWidth, userWindowHeight = love.window.getDesktopDimensions()
    WINDOW_WIDTH = userWindowWidth*.8
    WINDOW_HEIGHT = userWindowHeight*.8

    VIRTUAL_WIDTH = 858
    VIRTUAL_HEIGHT = 525

    love.graphics.setDefaultFilter('nearest', 'nearest')
    BASE_FONT = love.graphics.newFont('000webfont.ttf', 64)
    TOOLS_FONT = love.graphics.newFont('000webfont.ttf', 32)

    BOARD_BORDER = 4

    SPEED_PADDLE = 260
    SPEED_BALL = 200

    score_p1 = 0
    score_p2 = 0

    paddleLY = 50
    paddleRY = VIRTUAL_HEIGHT - 50

    love.graphics.setFont(BASE_FONT)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

end

--TODO: implement threads
function love.update(dt)
    if love.keyboard.isDown('w') then
        paddleLY = paddleLY - (SPEED_PADDLE * dt)
    elseif love.keyboard.isDown('s') then
        paddleLY = paddleLY + (SPEED_PADDLE * dt)
    end

    if love.keyboard.isDown('up') then
        paddleRY = paddleRY + (SPEED_PADDLE * dt)
    elseif love.keyboard.isDown('down') then
        paddleRY = paddleRY - (SPEED_PADDLE * dt)
    end

end

function love.draw()
    push:apply('start')
    love.graphics.clear(TableColorOf(26, 26, 26))

    DrawBoard()
    DrawTitle(0,8)
    DrawPaddles()
    DrawBall()
    DrawFps(8,0)

    push:apply('end')
end

function DrawPaddles()
    love.graphics.rectangle('fill',
    10 + BOARD_BORDER,
    paddleLY + BOARD_BORDER,
    10,
    40
    )

    love.graphics.rectangle('fill',
    VIRTUAL_WIDTH - (10 + BOARD_BORDER) - 10 ,
    VIRTUAL_HEIGHT - (40 + BOARD_BORDER) - paddleRY,
    10,
    40
    )
    
end

function DrawBall()
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

function DrawTitle(x,y)
    love.graphics.setFont(BASE_FONT)
    love.graphics.printf(
        'PONG',
        x + BOARD_BORDER,
        y + BOARD_BORDER,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'center'
    )
end

function DrawFps(x,y)
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        'FPS: ' .. tostring(love.timer.getFPS( )),
        x + BOARD_BORDER,
        y,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'left'
    )
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'escape' then
        love.event.quit()
    end
end
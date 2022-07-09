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
local SCORE_FONT

-- global variable for the game border
local BOARD_BORDER

local PADDLE_WIDTH
local PADDLE_HEIGHT

local BALL_WIDTH
local BALL_HEIGHT

-- Speed of the moving paddles
local SPEED_PADDLE
-- Speed of the moving ball
local SPEED_BALL

local score_p1
local score_p2

local paddleLY
local paddleRY

local ballX
local ballY


local ballDX
local ballDY
local sin
local cos

local gameState
local START
local PLAYING
local PAUSED
function TableColorOf(r,g,b)
    local red = r/255
    local green = g/255
    local blue = b/255

    return { red, green, blue} 
end

function love.load()
    local userWindowWidth, userWindowHeight = love.window.getDesktopDimensions()

    START = 'start'
    PLAYING = 'playing'
    PAUSED = 'paused'
    gameState = START

    WINDOW_WIDTH = userWindowWidth*.8
    WINDOW_HEIGHT = userWindowHeight*.8

    VIRTUAL_WIDTH = 858
    VIRTUAL_HEIGHT = 525

    love.graphics.setDefaultFilter('nearest', 'nearest')
    BASE_FONT = love.graphics.newFont('000webfont.ttf', 64)
    TOOLS_FONT = love.graphics.newFont('000webfont.ttf', 32)
    SCORE_FONT = love.graphics.newFont('000webfont.ttf', 256)

    BOARD_BORDER = 4

    PADDLE_WIDTH = 10
    PADDLE_HEIGHT = 50

    BALL_WIDTH = 8
    BALL_HEIGHT = 8

    SPEED_PADDLE = 260
    SPEED_BALL = 200

    score_p1 = 0
    score_p2 = 0

    ballX = (VIRTUAL_WIDTH - (BOARD_BORDER*2)) / 2 - 4
    ballY = (VIRTUAL_HEIGHT - (BOARD_BORDER*2)) / 2 - 4

    cos = math.cos(45)
    sin = math.sin(45)

    ballDX = 0
    ballDY = 0

    paddleLY = 60
    paddleRY = 60



    love.graphics.setFont(BASE_FONT)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

end

--TODO: implement threads
function love.update(dt)
    if gameState == PLAYING then
        if  love.keyboard.isDown('w') then
            paddleLY = math.max(0, paddleLY - (SPEED_PADDLE * dt))
    
        elseif love.keyboard.isDown('s') then
            paddleLY = math.min((VIRTUAL_HEIGHT-BOARD_BORDER-PADDLE_HEIGHT),paddleLY + (SPEED_PADDLE * dt))
        end
    
        if love.keyboard.isDown('up') then
            paddleRY = math.min((VIRTUAL_HEIGHT-BOARD_BORDER-PADDLE_HEIGHT),paddleRY + (SPEED_PADDLE * dt))
        elseif love.keyboard.isDown('down') then
            paddleRY = math.max(0, paddleRY - (SPEED_PADDLE * dt))
        end
    end

    if gameState == START then
        ballX = (VIRTUAL_WIDTH - (BOARD_BORDER*2)) / 2 - 4
        ballY = (VIRTUAL_HEIGHT - (BOARD_BORDER*2)) / 2 - 4
        paddleLY = 60
        paddleRY = 60
    elseif gameState == PLAYING then
        ballDX = (SPEED_BALL * sin * dt)
        ballDY = (SPEED_BALL * cos * dt)

        ballX = ballX + ballDX
        ballY = ballY + ballDY
    end


end

function love.draw()
    push:apply('start')
    love.graphics.clear(TableColorOf(26, 26, 26))

    DrawBoard()
    DrawTitle()
    DrawScores()
    DrawPaddles()
    DrawBall()
    DrawFps()
    DrawGameState()

    push:apply('end')
end

function DrawPaddles()
    love.graphics.setColor(TableColorOf(255, 255, 255))
    love.graphics.rectangle('fill',
    PADDLE_WIDTH + BOARD_BORDER,
    paddleLY + BOARD_BORDER,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
    )

    love.graphics.rectangle('fill',
    VIRTUAL_WIDTH - (PADDLE_WIDTH + BOARD_BORDER + PADDLE_WIDTH),
    VIRTUAL_HEIGHT - (PADDLE_HEIGHT + BOARD_BORDER + paddleRY) ,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
    )
    
end

function DrawBall()
    love.graphics.setColor(TableColorOf(255, 255, 255))
    love.graphics.rectangle('fill',
    ballX,
    ballY,
    BALL_WIDTH,
    BALL_HEIGHT
    )
end

function DrawBoard()
    love.graphics.setColor(TableColorOf(255, 255, 255))
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

function DrawGameState()
    love.graphics.setColor(TableColorOf(102, 102, 102))
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        'gs: ' .. gameState,
        8 + BOARD_BORDER,
        14,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'left'
    )
end

function DrawTitle()
    love.graphics.setColor(TableColorOf(255, 255, 255))
    love.graphics.setFont(BASE_FONT)
    love.graphics.printf(
        'PONG',
        0 + BOARD_BORDER,
        8 + BOARD_BORDER,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'center'
    )
end

function DrawScores()
    love.graphics.setColor(TableColorOf(77, 77, 77))
    love.graphics.setFont(SCORE_FONT)

    love.graphics.printf(
        score_p1,
        VIRTUAL_WIDTH/4,
        0,
        VIRTUAL_WIDTH,
        'left'
    )
    love.graphics.printf(
        score_p2,
        VIRTUAL_WIDTH/4,
        0,
        VIRTUAL_WIDTH,
        'center'
    )
end

function DrawFps()
    love.graphics.setColor(TableColorOf(102, 102, 102))
    love.graphics.setFont(TOOLS_FONT)
    love.graphics.printf(
        'FPS: ' .. tostring(love.timer.getFPS( )),
        8 + BOARD_BORDER,
        0,
        VIRTUAL_WIDTH - (BOARD_BORDER*2),
        'left'
    )
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if gameState == START then
        if key == 'return' then
            gameState = PLAYING
            
        end
    elseif  gameState == PLAYING then
        if key == 'p' then
            gameState = PAUSED
        end
        if key == 'backspace' then
            gameState = START
        end
    elseif  gameState == PAUSED  then
        if key == 'p' then
            gameState = PLAYING
        end
        if key == 'backspace' then
            gameState = START
        end
    end
    

   

end
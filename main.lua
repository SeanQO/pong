WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
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
    love.graphics.printf(
        'PONG',
        0,
        WINDOW_HEIGHT / 2 -6,
        WINDOW_WIDTH,
        'center'
    )
    love.graphics.print(
        'n:' .. n,
        8,
        4
    )
end

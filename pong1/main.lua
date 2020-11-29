WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Paddle'
require 'Ball'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Pong!')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont("fonts/04b03.TTF", 8)
    scoreFont = love.graphics.newFont("fonts/04b03.TTF", 32)
    victoryFont = love.graphics.newFont("fonts/04b03.TTF", 14)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    paddle1 = Paddle(5, 20, 5, 20, VIRTUAL_WIDTH / 2 - 50)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20, VIRTUAL_WIDTH / 2 + 30)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = math.random(2) == 1 and 1 or 2

    ball.dx = servingPlayer == 1 and 100 or -100

    gameState = 'start'
end

function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        ball.dx = -ball.dx
    end

    if ball:collides(paddle2) then
        ball.dx = -ball.dx
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end

    if ball.x <= 0 then
        paddle2:updateScore()
        ball:reset()
        servingPlayer = 1
        ball.dx = 100

        if paddle2.score == 3 then 
            gameState = 'victory'
        else
            gameState = 'serve'
        end

    elseif ball.x >= VIRTUAL_WIDTH - 4 then
        paddle1:updateScore()
        ball:reset()
        servingPlayer = 2
        ball.dx = -100

        if paddle1.score == 3 then 
            gameState = 'victory'
        else
            gameState = 'serve'
        end
    end


    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ball:reset()
        elseif gameState == 'victory' then
            paddle1.score = 0
            paddle2.score = 0
            gameState = 'start'
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- ball
    ball:render()

    -- paddle render
    love.graphics.setFont(scoreFont)
    paddle1:render()
    paddle2:render()

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to play!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. " is serving!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to serve!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        winner = paddle1.score > paddle2.score and 1 or 2
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winner) .. " is the winner!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to play again!", 0, 40, VIRTUAL_WIDTH, 'center')
    end

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end
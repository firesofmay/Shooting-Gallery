require "utils"

-- this is where you initialize all the variables etc.
function love.load()

    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50
    target.miss = false

    score = 0
    countdown = 10
    timer = countdown

    sprites = {}
    sprites.sky = loadSprite("sprites/sky.png")
    sprites.sky_red = loadSprite("sprites/sky_red.png")
    sprites.target = loadSprite("sprites/target.png")
    sprites.crosshairs = loadSprite("sprites/crosshairs.png")

    GAME_STATE_INIT = 1
    GAME_STATE_RUNNING = 2
    GAME_STATE_OVER = 3

    gameState = GAME_STATE_INIT

    gameFont = love.graphics.newFont(40)
    love.graphics.setFont(gameFont)

    love.mouse.setVisible(false)

end

-- dt means delta time. 
-- this will be called 60 times every second (60 fps)
function love.update(dt)

    if timer > 0 and gameState == GAME_STATE_RUNNING then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = GAME_STATE_OVER
    end

end

function updateGame(updateScore, updateTimer, newTarget)

    score = score + updateScore
    timer = timer + updateTimer

    if newTarget then
        target.x = math.random(target.radius, love.graphics.getWidth()-target.radius)
        target.y = math.random(target.radius+50, love.graphics.getHeight()-target.radius)
    end

end

-- only used for updating graphics.
-- also called every second 60 times
-- don't do important calculations or store imp vars here
function love.draw()

    -- setRGBColor(128, 159, 255)
    -- love.graphics.circle("fill", target.x, target.y, target.radius)

    if target.miss then
        love.graphics.draw(sprites.sky_red, 0, 0)
    else
        love.graphics.draw(sprites.sky, 0, 0)
    end

    setColor("white")
    
    love.graphics.print("Score: " .. score, 5, 5)

    -- love.graphics.print(math.ceil(timer), 300, 0)
    love.graphics.print(string.format("Timer: %.2f",timer) , 300, 5)

    if gameState == GAME_STATE_INIT then
        love.graphics.printf("Right Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
    elseif gameState == GAME_STATE_RUNNING then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    elseif gameState == GAME_STATE_OVER then
        love.graphics.printf("Game OVER!", 0, 250, love.graphics.getWidth(), "center")
        love.graphics.printf("Right click anywhere to restart the game!", 0, 300, love.graphics.getWidth(), "center")
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20,  love.mouse.getY()-20)

end


function love.mousepressed(x, y, button, istouch, presses)

    if button == 2 and gameState == GAME_STATE_INIT then

        gameState = GAME_STATE_RUNNING
        timer = countdown

    elseif button == 2 and gameState == GAME_STATE_OVER then

        gameState = GAME_STATE_RUNNING
        score = 0
        timer = countdown

    elseif button == 1 and gameState == GAME_STATE_RUNNING then

        -- if the distance between mouse click 
        -- is less then radius of the cirlce
        -- then it means it's inside the circle
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)

        if mouseToTarget < target.radius then
            target.miss = false
            updateGame(1, 0.5, true)
        else
            target.miss = true
            updateGame(-1, -1, false)
        end

    end
end


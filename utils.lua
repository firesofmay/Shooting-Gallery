function setRGBColor(r, g, b)
    love.graphics.setColor(r/255, g/255, b/255)
end

function setColor(color)

    if color == "white" then
        setRGBColor(255, 255, 255)
    elseif  color == "black" then
        setRGBColor(0, 0, 0)
    end

end

function distanceBetween (x1, y1, x2, y2)

    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )

end

function loadSprite(f)
    return love.graphics.newImage(f)
end
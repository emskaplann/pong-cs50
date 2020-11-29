Paddle = Class{}

function Paddle:init(x, y, width, height, scoreX)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.scoreX = scoreX

    self.dy = 0
    self.score = 0
end

function Paddle:updateScore()
    self.score = self.score + 1
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + self.dy * dt) 
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.print(self.score, self.scoreX, VIRTUAL_HEIGHT / 3)
end
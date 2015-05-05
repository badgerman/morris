local img
local qboard
local pieces = {}
local board = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
local player = 1
local places = { 0, 0, 0, 0, 0, 0 }
local piece = 1
local left, top
local snd_click

function love.load()
    snd_click = love.audio.newSource("zipclick.wav", "static")
    love.window.setTitle("Three Men's Morris")
    img = love.graphics.newImage("pieces.png")
    qboard = love.graphics.newQuad(356, 0, 668, 647, img:getDimensions())
    pieces[1] = love.graphics.newQuad(1, 3, 179, 153, img:getDimensions())
    pieces[2] = love.graphics.newQuad(9, 167, 160, 160, img:getDimensions())
    pieces[3] = love.graphics.newQuad(2, 365, 168, 154, img:getDimensions())
    pieces[4] = love.graphics.newQuad(177, 7, 179, 153, img:getDimensions())
    pieces[5] = love.graphics.newQuad(195, 169, 149, 146, img:getDimensions())
    pieces[6] = love.graphics.newQuad(194, 327, 152, 155, img:getDimensions())
end

local offset = {
    { 20, 240, 460 },
    { 50, 250, 450 }
}

function love.draw()
    local x, y, w, h = qboard:getViewport()
    local width, height = love.window.getDimensions()
    left = (width - w) / 2
    top = (height - h) / 2
    love.graphics.draw(img, qboard, left, top)
    for k, v in ipairs(board) do
        if v>0 then
            local x = 1 + (k-1) % 3
            local y = 1 + math.floor((k-1) / 3)
            love.graphics.draw(img, pieces[v], left+offset[1][x], top+offset[2][y])
        end
    end
    if piece~=0 then
        love.graphics.draw(img, pieces[piece], 0, 0)
    end
end

local function unused_piece(player)
    local p
    local result = 0
    for p = 1, 3 do
        if places[player*3+p-3]==0 then
            result = player*3+p-3
        end
    end
    return result
end

local function swap_player()
    player = 3-player
    piece = unused_piece(player)
end

local function find_closest(x, y)
    local tx = 1
    local ty = 1
    for i = 2,3 do
        local a1 = math.abs(x-left-offset[1][i]-110)
        local a2 = math.abs(x-left-offset[1][tx]-110)
        if a1<a2 then tx = i end
        local b1 = math.abs(y-top-offset[2][i]-100)
        local b2 = math.abs(y-top-offset[2][ty]-100)
        if b1<b2 then ty = i end
    end
    return tx+ty*3-3
end

function love.mousereleased(x, y, b)
    if b == "l" then
        loc = find_closest(x, y)
        if loc > 0 then
            if piece > 0 then
                if board[loc]==0 then
                    places[piece] = loc
                    board[loc] = piece
                    swap_player()
                    snd_click:play()
                end
            else
                local ppl = math.floor((board[loc]-1) / 3)+1
                if player==ppl then
                    piece = board[loc]
                    places[piece] = 0
                    board[loc] = 0
                end
            end
        end
    end
end


-- https://stackoverflow.com/a/16077650
local function DeepCopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[DeepCopy(k, seen)] = DeepCopy(v, seen)
    end
  else -- number, string, boolean, etc
    no = o
  end
  return no
end


-- w is wall
-- "-" is empty


function CreateEmptyGrid()
    local grid = {}
    for i = 1, 80 do
        grid[i] = {}
        for j = 1, 80 do
            grid[i][j] = "w"
        end
    end
    return grid
end

function AttemptExpand(x, y, w, h, grid_og)
    local grid = DeepCopy(grid_og)
    for i = x, x + w - 1 do
        for j = y, y + h - 1 do
            if (grid[i][j] == "-" or grid[i][j] == nil) then
                return {grid = grid,success = false}
            end
            grid[i][j] = "-"
        end
    end
    return {grid = grid,success = true}
end

function TryExpandToMaxSizePlusBorder(sx,sy,mw,mh,grid_og)
    local best_grid = nil
    local previous_grid = nil
    for x=1, mw do
        for y=1, mh do
            if (AttemptExpand(sx,sy,x,y,grid_og).success) then
                previous_grid = DeepCopy(best_grid)
                best_grid = AttemptExpand(sx,sy,x,y,grid_og).grid
            else
                return previous_grid or grid_og
            end
        end
    end
    return best_grid or grid_og

end



--below is test stuff, i have no effecient way of seeing if this code actually works so the below testing code isnt really reliable
local eg = CreateEmptyGrid()

eg = TryExpandToMaxSizePlusBorder(10,10,10,10,eg)

eg = TryExpandToMaxSizePlusBorder(30,10,10,10,eg)

for i=1, 80 do
    local s = ""
    for j=1, 80 do
        s = s .. eg[i][j]
    end
    print(s)
end
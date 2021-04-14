local PunchedBag = RegisterMod("PunchedBag", 1)
PunchedBag.COLLECTIBLE_PUNCHEDBAG = Isaac.GetItemIdByName("Punched Bag")
PunchedBag.ENTITY_PUNCHEDBAG = Isaac.GetEntityTypeByName("Punched Bag")

local playerpbs = {}
function PunchedBag:SpawnPunchedBag()
  for playerNum = 1, Game():GetNumPlayers() do
    local player = Game():GetPlayer(playerNum)
    if player:HasCollectible(PunchedBag.COLLECTIBLE_PUNCHEDBAG) then
      -- first pickup
      
      if playerpbs[playerNum] == nil then
        
        local pb = Isaac.Spawn(PunchedBag.ENTITY_PUNCHEDBAG, 0, 0, RandomPosition(Vector(320, 300),100), Vector(0,0), nil)
        playerpbs[playerNum] = pb
      end
    else
      if playerpbs[playerNum] ~= nil then
        playerpbs[playerNum]:Kill()
        playerpbs[playerNum] = nil
      end
    end
  end
  
    
end

-- To get somewhat the center of the room for later use
function RandomPosition(position--[[Vector]], range--[[int]])
  local rng = RNG()
  local effectiveRange = rng:RandomInt(range)
  local newPos
  isNegative = rng:RandomInt(1)
  if isNegative then
    newPos = position - Vector(effectiveRange, effectiveRange)
  else
    newPos = position + Vector(effectiveRange, effectiveRange)
  end
  print(newPos)
  --eventually
  return Game():GetRoom():FindFreeTilePosition(newPos, range)
end

function PunchedBag:SaveModData(shouldSave)
  if shouldSave then
    Isaac.SaveModData(PunchedBag, table.tostring(playerpbs))
  end  
end

function PunchedBag:LoadModData(startedFromSave)
  if startedFromSave then
    playerpbs = load("return " ..Isaac.LoadModData(PunchedBag))
    local pbs = Isaac:FindByType(PunchedBag.ENTITY_PUNCHEDBAG, 0, 0, false, false)
    for playerNum = 1, Game():GetNumPlayers() do
      if pbs[playerNum].GetLastParent() == Game().GetPlayer(playerNum) then
        
      end
    end
  end  
end

function PunchedBag:TearDown(gameOver)
  playerpbs = {}
end


PunchedBag:AddCallback(ModCallbacks.MC_POST_UPDATE, PunchedBag.SpawnPunchedBag)
PunchedBag:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PunchedBag.SaveModData, shouldSave)
PunchedBag:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PunchedBag.LoadModData, startedFromSave)
PunchedBag:AddCallback(ModCallbacks.MC_POST_GAME_END, PunchedBag.TearDown, gameOver)


-- FOR SAVING MOD DATA
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end





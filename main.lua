StartDebug()

local PunchedBag = RegisterMod("PunchedBag", 1)
PunchedBag.COLLECTIBLE_PUNCHEDBAG = Isaac.GetItemIdByName("Punched Bag")
PunchedBag.ENTITY_PUNCHEDBAG = Isaac.GetEntityTypeByName("Punched Bag")


function PunchedBag:SpawnPunchedBag()
  if Game():GetFrameCount() == 1 then
    PunchedBag.HasPb = false
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, PunchedBag.COLLECTIBLE_PUNCHEDBAG, Vector(320, 300), Vector(0,0),     nil)
  end
  for playerNum = 1, Game():GetNumPlayers() do
    local player = Game():GetPlayer(playerNum)
    if player:HasCollectible(PunchedBag.COLLECTIBLE_PUNCHEDBAG) then
      -- first pickup
      if not PunchedBag.HasPb then
        PunchedBag.HasPb = true
        Isaac.Spawn(PunchedBag.ENTITY_PUNCHEDBAG, 0, 0, Vector(320, 300), Vector(0,0), nil)
      end
    end
  end
  
    
end

-- To get somewhat the center of the room for later use
local function RandomPosition(position--[[Vector]], range--[[int]])
  local rng = RNG()
  rng.SetSeed(Seeds.GetStartSeed(), 0)
  --TODO
  

PunchedBag:AddCallback(ModCallbacks.MC_POST_UPDATE, PunchedBag.SpawnPunchedBag)
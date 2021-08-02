--[[

encode a bunch of patterns for various types of crystallised essences (less patterns that way, actual need for farms and such, makes for a more interesting gameplay

so, to get essentia in the system, ME will throw an item into alch furnace, crystallize the essence, import crystals into an array of void barrels. grab an exact amount of needed crystals, smelt them up to a limit and keep that in the essentia drives

pros
- more interesting gameplay than getting rich on a mob/mana farm, actually have to think (like having a mushroom farm for tenebrae)
- control over exact values of essentia in the system, no overfills anywhere
- distillation patterns are super easy to encode
- sounds pretty fun

--]]

i = peripheral.wrap("right")
e = peripheral.wrap("bottom")

amount_to_stock = 100

storage = {}

hashes = {
  terra = "hash_terra",
  ignis = "hash_ignis",
}

function getStorage()
  count = #storage
  for i = 0, count do storage[i] = nil end

  local t = {e.getAspects()}

  for k, v in pairs(t) do
    if (k % 2 ~= 0) then
      storage[v] = t[k+1]
    end
  end
end

function craft(aspect, amount)
  i.requestCrafting(hashes[aspect], amount)
end

while true do
  sleep_time = 10
  getStorage()

  for aspect, amount in pairs(storage) do
    local _amount = tonumber(amount)
    if _amount < amount_to_stock then
      craft(aspect, amount_to_stock - _amount)
      sleep_time = 60
    end
  end
  os.sleep(sleep_time)
end

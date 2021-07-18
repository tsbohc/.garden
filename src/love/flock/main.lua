local ecs = require("lib.concord")
local QuadTree = require("lib.quadtree")
local tree = QuadTree(0, 0, 1024, 1024)
local core = {}
core["nil?"] = function(x)
  return (nil == x)
end
core["table?"] = function(x)
  return ("table" == type(x))
end
core["seq?"] = function(xs)
  local i = 0
  for _ in pairs(xs) do
    i = (i + 1)
    if (nil == xs[i]) then
      return false
    end
  end
  return true
end
core["has?"] = function(xt, y)
  if core["seq?"](xt) then
    for _, v in ipairs(xt) do
      if (v == y) then
        return true
      end
    end
  else
    if (nil ~= xt[y]) then
      return true
    end
  end
  return false
end
core["even?"] = function(n)
  return ((n % 2) == 0)
end
core["odd?"] = function(n)
  return not core["even?"](n)
end
core.count = function(xs)
  if core["table?"](xs) then
    local maxn = 0
    for k, v in pairs(xs) do
      maxn = (maxn + 1)
    end
    return maxn
  elseif not xs then
    return 0
  else
    return #xs
  end
end
core["empty?"] = function(xs)
  return (0 == core.count(xs))
end
core["run!"] = function(f, xs)
  if xs then
    local nxs = core.count(xs)
    if (nxs > 0) then
      for i = 1, nxs do
        f(xs[i])
      end
      return nil
    end
  end
end
core.map = function(f, xs)
  local result = {}
  local function _0_(x)
    local mapped = f(x)
    local function _1_()
      if (0 == select("#", mapped)) then
        return nil
      else
        return mapped
      end
    end
    return table.insert(result, _1_())
  end
  core["run!"](_0_, xs)
  return result
end
core.reduce = function(f, init, xs)
  local result = init
  local function _0_(x)
    result = f(result, x)
    return nil
  end
  core["run!"](_0_, xs)
  return result
end
core["merge!"] = function(base, ...)
  local function _0_(acc, m)
    if m then
      for k, v in pairs(m) do
        acc[k] = v
      end
    end
    return acc
  end
  return core.reduce(_0_, (base or {}), {...})
end
core.merge = function(...)
  return core["merge!"]({}, ...)
end
local function shallow_merge(c, xt)
  for k, v in pairs(xt) do
    c[k] = v
  end
  return c
end
local function distance(x1, y1, x2, y2)
  return math.sqrt((((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2))))
end
local function distance_between(f, t)
  return distance(f.position.x, f.position.y, t.position.x, t.position.y)
end
local flock = {}
local function _0_(c, x, y, s)
  return shallow_merge(c, {special = (s or false), x = (x or 0), y = (y or 0)})
end
ecs.component("position", _0_)
local function _1_(c, x, y)
  return core["merge!"](c, {separation = {x = 0, y = 0}, x = (x or 0), y = (y or 0)})
end
ecs.component("velocity", _1_)
local function _2_(c, r)
  return shallow_merge(c, {r = (r or 100), vision = {}})
end
ecs.component("fieldofview", _2_)
local function _3_(c, r)
  c.r = (r or 50)
  return nil
end
ecs.component("separation", _3_)
ecs.component("cohesion")
ecs.component("alignment")
ecs.component("fear")
ecs.component("drawable")
local DrawSystem = ecs.system({pool = {"position", "velocity", "drawable"}})
DrawSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    if e.position.special then
      love.graphics.setColor(1, 1, 1)
    else
      love.graphics.setColor(0.6, 0.6, 0.6)
    end
    love.graphics.circle("fill", e.position.x, e.position.y, 4)
  end
  return nil
end
local MoveSystem = ecs.system({pool = {"position", "velocity"}})
MoveSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    if (e.velocity.x > 100) then
      e.velocity.x = 100
    end
    if (e.velocity.y > 100) then
      e.velocity.y = 100
    end
    if (e.velocity.x < -100) then
      e.velocity.x = -100
    end
    if (e.velocity.y < -100) then
      e.velocity.y = -100
    end
    e.position.x = (e.position.x + (e.velocity.x * dt))
    e.position.y = (e.position.y + (e.velocity.y * dt))
    if ((e.position.x < 10) or (e.position.y < 10) or (e.position.x > 1014) or (e.position.y > 1014)) then
      e.velocity.x = ( - e.velocity.x)
      e.velocity.y = ( - e.velocity.y)
    end
  end
  return nil
end
MoveSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.line(e.position.x, e.position.y, (e.position.x - (e.velocity.x / 6)), (e.position.y - (e.velocity.y / 6)))
  end
  return nil
end
local FieldofviewSystem = ecs.system({pool = {"fieldofview", "position"}})
FieldofviewSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    for i, t in ipairs(tree:search((e.position.x - e.fieldofview.r), (e.position.y - e.fieldofview.r), (e.position.x + e.fieldofview.r), (e.position.y + e.fieldofview.r))) do
      if (t.position and (e ~= t) and (distance_between(e, t) < e.fieldofview.r)) then
        e.fieldofview.vision[i] = {position = {x = t.position.x, y = t.position.y}, velocity = {x = t.velocity.x, y = t.velocity.y}}
      else
        e.fieldofview.vision[i] = nil
      end
    end
  end
  return nil
end
FieldofviewSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    if e.position.special then
      love.graphics.circle("line", e.position.x, e.position.y, e.fieldofview.r)
      for _0, v in pairs(e.fieldofview.vision) do
        if v then
          love.graphics.circle("line", v.position.x, v.position.y, 10)
        end
      end
    end
  end
  return nil
end
local speed = 5
local SeparationSystem = ecs.system({pool = {"velocity", "fieldofview", "separation"}})
SeparationSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local x = 0
    local y = 0
    for i, v in pairs(e.fieldofview.vision) do
      if (distance(e.position.x, e.position.y, v.position.x, v.position.y) < e.separation.r) then
        x = (x - (v.position.x - e.position.x))
        y = (y - (v.position.y - e.position.y))
      end
    end
    e.separation.x = x
    e.separation.y = y
    e.velocity.x = (e.velocity.x + ((x / 1) * dt * speed))
    e.velocity.y = (e.velocity.y + ((y / 1) * dt * speed))
  end
  return nil
end
SeparationSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    if e.position.special then
      love.graphics.setColor(1, 0.5, 0.5)
      love.graphics.circle("line", e.position.x, e.position.y, e.separation.r)
      love.graphics.line(e.position.x, e.position.y, (e.position.x + e.separation.x), (e.position.y + e.separation.y))
    end
  end
  return nil
end
local CohesionSystem = ecs.system({pool = {"velocity", "fieldofview", "cohesion"}})
CohesionSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local x = 0
    local y = 0
    local n = core.count(e.fieldofview.vision)
    if (n > 0) then
      for i, v in pairs(e.fieldofview.vision) do
        x = (x + v.position.x)
        y = (y + v.position.y)
      end
      x = (x / n)
      y = (y / n)
      e.cohesion.x = x
      e.cohesion.y = y
      x = (((x - e.position.x) / 100) * dt * speed)
      y = (((y - e.position.y) / 100) * dt * speed)
      e.velocity.x = (e.velocity.x + x)
      e.velocity.y = (e.velocity.y + y)
    end
  end
  return nil
end
CohesionSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    if e.position.special then
      love.graphics.setColor(0.5, 0.5, 1)
      love.graphics.line(e.position.x, e.position.y, e.cohesion.x, e.cohesion.y)
    end
  end
  return nil
end
local AlignmentSystem = ecs.system({pool = {"velocity", "fieldofview", "alignment"}})
AlignmentSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local x = 0
    local y = 0
    local n = core.count(e.fieldofview.vision)
    if (n > 0) then
      for i, v in pairs(e.fieldofview.vision) do
        x = (x + v.velocity.x)
        y = (y + v.velocity.y)
      end
      x = (x / n)
      y = (y / n)
      e.alignment.x = x
      e.alignment.y = y
      e.velocity.x = (e.velocity.x + ((x / 8) * dt * speed))
      e.velocity.y = (e.velocity.y + ((y / 8) * dt * speed))
    end
  end
  return nil
end
AlignmentSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    if e.position.special then
      love.graphics.setColor(0.5, 1, 0.5)
      love.graphics.line(e.position.x, e.position.y, (e.position.x + e.alignment.x), (e.position.y + e.alignment.y))
    end
  end
  return nil
end
local FearSystem = ecs.system({pool = {"position", "velocity", "fear"}})
FearSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local x = 0
    local y = 0
    local mx, my = love.mouse.getPosition()
    if (distance(e.position.x, e.position.y, mx, my) < 250) then
      if love.mouse.isDown(1) then
        x = (mx - e.position.x)
        y = (my - e.position.y)
      elseif love.mouse.isDown(2) then
        x = (e.position.x - mx)
        y = (e.position.y - my)
      end
      e.velocity.x = (e.velocity.x + (x * dt * speed))
      e.velocity.y = (e.velocity.y + (y * dt * speed))
    end
  end
  return nil
end
local world = ecs.world()
world:addSystems(FieldofviewSystem, SeparationSystem, CohesionSystem, AlignmentSystem, FearSystem, MoveSystem, DrawSystem)
do
  local e = nil
  do
    local _4_0 = ecs.entity(world)
    _4_0:give("drawable", 1, 1, 1)
    _4_0:give("position", 512, 512, true)
    _4_0:give("velocity", math.random(-50, 50), math.random(-50, 50))
    _4_0:give("fieldofview")
    e = _4_0
  end
  tree:insert(e)
end
for i = 1, 100 do
  local x = math.random(10, 1014)
  local y = math.random(10, 1014)
  local e = nil
  do
    local _4_0 = ecs.entity(world)
    _4_0:give("drawable")
    _4_0:give("position", x, y)
    _4_0:give("velocity", math.random(-50, 50), math.random(-50, 50))
    e = _4_0
  end
  tree:insert(e)
end
love.conf = function(t)
  t.console = true
  return nil
end
love.load = function()
  return love.window.setMode(1024, 1024)
end
love.update = function(dt)
  return world:emit("update", dt)
end
love.draw = function()
  love.graphics.setBackgroundColor(0.25, 0.25, 0.25)
  return world:emit("draw")
end
return love.draw

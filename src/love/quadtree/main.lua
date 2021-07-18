local ecs = require("lib.concord")
local Vector = require("lib.vector")
local QuadTree = require("lib.quadtree")
local function shallow_merge(c, xt)
  for k, v in pairs(xt) do
    c[k] = v
  end
  return c
end
local others = {}
local tree = QuadTree(0, 0, 512, 512)
local function _0_(c, x, y)
  c.v = Vector((x or 0), (y or 0))
  return nil
end
ecs.component("position", _0_)
local function _1_(c, r)
  c.r = (r or 10)
  return nil
end
ecs.component("radius", _1_)
local function _2_(c)
  c["is?"] = false
  return nil
end
ecs.component("collision", _2_)
ecs.component("movable")
local MoveSystem = ecs.system({pool = {"position", "movable"}})
MoveSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local p = e.position
    p.v = (p.v + (dt * 5 * Vector(math.random(-1, 1), math.random(-1, 1))))
  end
  return nil
end
local CollisionSystem = ecs.system({pool = {"position", "radius", "collision"}})
CollisionSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    local p = e.position
    local r = e.radius.r
    e.collision["is?"] = false
    for i, o in ipairs(tree:search((e.position.v.x - (0 + (2 * r))), (e.position.v.y - (0 + (2 * r))), (e.position.v.x + (0 + (2 * r))), (e.position.v.y + (0 + (2 * r))))) do
      local d = (o.position.v - e.position.v)
      if ((d.length <= (e.radius.r + o.radius.r)) and not (e == o)) then
        e.collision["is?"] = true
      end
    end
  end
  return nil
end
CollisionSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    local x = e.position.v.x
    local y = e.position.v.y
    local r = e.radius.r
    if e.collision["is?"] then
      love.graphics.setColor(0.5, 0.5, 0.5)
      love.graphics.circle("line", x, y, r)
    else
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle("fill", x, y, r)
    end
  end
  return nil
end
local world = ecs.world()
world:addSystems(MoveSystem, CollisionSystem)
love.conf = function(t)
  t.console = true
  return nil
end
love.load = function()
  love.window.setMode(512, 512)
  for i = 1, 500 do
    local x = math.random(10, 502)
    local y = math.random(10, 502)
    local _4_
    do
      local _3_0 = ecs.entity(world)
      _3_0:give("position", x, y)
      _3_0:give("collision")
      _3_0:give("movable")
      _3_0:give("radius")
      _4_ = _3_0
    end
    tree:insert(_4_, x, y)
  end
  return world:emit("load")
end
love.update = function(dt)
  return world:emit("update", dt)
end
love.draw = function()
  love.graphics.setBackgroundColor(0.25, 0.25, 0.25)
  return world:emit("draw")
end
return love.draw

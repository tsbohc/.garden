local ecs = require("lib.concord")
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
local function _0_(c, x, y)
  return shallow_merge(c, {x = (x or 0), y = (y or 0)})
end
ecs.component("position", _0_)
local function _1_(c, x, y)
  return shallow_merge(c, {x = (x or 0), y = (y or 0)})
end
ecs.component("velocity", _1_)
ecs.component("drawable")
local MoveSystem = ecs.system({pool = {"position", "velocity"}})
MoveSystem.update = function(s, dt)
  for _, e in ipairs(s.pool) do
    e.position.x = (e.position.x + (e.velocity.x * dt))
    e.position.y = (e.position.y + (e.velocity.y * dt))
  end
  return nil
end
local DrawSystem = ecs.system({pool = {"position", "drawable"}})
DrawSystem.draw = function(s)
  for _, e in ipairs(s.pool) do
    love.graphics.circle("fill", e.position.x, e.position.y, 10)
  end
  return nil
end
local world = ecs.world()
world:addSystems(MoveSystem, DrawSystem)
do
  local _2_0 = ecs.entity(world)
  _2_0:give("position", 100, 100)
  _2_0:give("velocity", 80)
  _2_0:give("drawable")
end
do
  local _3_0 = ecs.entity(world)
  _3_0:give("position", 50, 50)
  _3_0:give("drawable")
end
do
  local _4_0 = ecs.entity(world)
  _4_0:give("position", 50, 50)
end
love.update = function(dt)
  return world:emit("update", dt)
end
love.draw = function()
  return world:emit("draw")
end
return love.draw

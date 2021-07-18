(local ecs (require :lib.concord))

; -- core --
; {{{

(local core {})

(fn core.nil? [x]
  (= nil x))

(fn core.table? [x]
  (= "table" (type x)))

(fn core.seq? [xs]
  "check if table is a sequence"
  (var i 0)
  (each [_ (pairs xs)]
    (set i (+ i 1))
    (if (= nil (. xs i))
      (lua "return false")))
  true)

(fn core.has? [xt y]
  "check if table contains a value or a key pair"
  (if (core.seq? xt)
    (each [_ v (ipairs xt)]
      (when (= v y)
        (lua "return true")))
    (when (not= nil (. xt y))
      (lua "return true")))
  false)

(fn core.even? [n]
  (= (% n 2) 0))

(fn core.odd? [n]
  (not (core.even? n)))

(fn core.count [xs]
  "count elements in seq or characters in string"
  (if
    (core.table? xs)
    (do
      (var maxn 0)
      (each [k v (pairs xs)]
        (set maxn (+ maxn 1)))
      maxn)
    (not xs) 0
    (length xs)))

(fn core.empty? [xs]
  (= 0 (core.count xs)))

(fn core.run! [f xs]
  "execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (core.count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(fn core.map [f xs]
  "map xs to a new seq by calling (f x) on each item."
  (let [result []]
    (core.run!
      (fn [x]
        (let [mapped (f x)]
          (table.insert
            result
            (if (= 0 (select "#" mapped))
              nil
              mapped))))
      xs)
    result))

(fn core.reduce [f init xs]
  "reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (core.run!
    (fn [x]
      (set result (f result x)))
    xs)
  result)

(fn core.merge! [base ...]
  (core.reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(fn core.merge [...]
  (core.merge! {} ...))

; }}}

(fn shallow-merge [c xt]
  (each [k v (pairs xt)]
    (tset c k v))
  c)

; -- components --

(ecs.component :position
  (fn [c x y]
    (shallow-merge c
      {:x (or x 0)
       :y (or y 0)})))

(ecs.component :velocity
  (fn [c x y]
    (shallow-merge c
      {:x (or x 0)
       :y (or y 0)})))

(ecs.component :drawable)

; -- systems --

(local MoveSystem (ecs.system {:pool [:position :velocity]}))
(fn MoveSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (set e.position.x (+ e.position.x (* e.velocity.x dt)))
    (set e.position.y (+ e.position.y (* e.velocity.y dt)))))

(local DrawSystem (ecs.system {:pool [:position :drawable]}))
(fn DrawSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (love.graphics.circle :fill e.position.x e.position.y 10)))

; -- world --

(local world (ecs.world))
(world:addSystems MoveSystem DrawSystem)

; -- entities --

(doto (ecs.entity world)
      (: :give :position 100 100)
      (: :give :velocity 80)
      (: :give :drawable))

(doto (ecs.entity world)
      (: :give :position 50 50)
      (: :give :drawable))

(doto (ecs.entity world)
      (: :give :position 50 50))

; -- setup --

(fn love.update [dt]
  (world:emit :update dt))

(fn love.draw []
  (world:emit :draw))

(local ecs (require :lib.concord))
(local QuadTree (require :lib.quadtree))

(local tree (QuadTree 0 0 1024 1024))

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

(macro += [x y]
  `(set ,x (+ ,x ,y)))

(macro -= [x y]
  `(set ,x (- ,x ,y)))

(fn distance [x1 y1 x2 y2]
  (math.sqrt (+ (* (- x1 x2) (- x1 x2))
                (* (- y1 y2) (- y1 y2)))))

(fn distance-between [f t]
  (distance f.position.x f.position.y t.position.x t.position.y))

; -- main --

(local flock [])

; -- components --

(ecs.component :position
  (fn [c x y s]
    (shallow-merge c
      {:x (or x 0)
       :y (or y 0)
       :special (or s false)})))

(ecs.component :velocity
  (fn [c x y]
    (core.merge! c
      {:x (or x 0)
       :y (or y 0)
       :separation {:x 0 :y 0}})))

(ecs.component :fieldofview
  (fn [c r]
    (shallow-merge c
      {:r (or r 100)
       :vision {}})))

(ecs.component :separation
  (fn [c r]
    (set c.r (or r 50))))

(ecs.component :cohesion)
(ecs.component :alignment)
(ecs.component :fear)

(ecs.component :drawable)

; -- systems --

; TODO second pool with velocity for traingle alignment
(local DrawSystem (ecs.system {:pool [:position :velocity :drawable]}))
(fn DrawSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (if e.position.special
      (love.graphics.setColor 1 1 1)
      (love.graphics.setColor .6 .6 .6))
    (love.graphics.circle :fill e.position.x e.position.y 4)))

(local MoveSystem (ecs.system {:pool [:position :velocity]}))
(fn MoveSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (when (> e.velocity.x 100) (set e.velocity.x 100))
    (when (> e.velocity.y 100) (set e.velocity.y 100))
    (when (< e.velocity.x -100) (set e.velocity.x -100))
    (when (< e.velocity.y -100) (set e.velocity.y -100))
    (+= e.position.x (* e.velocity.x dt))
    (+= e.position.y (* e.velocity.y dt))
    (when (or (< e.position.x 10)
              (< e.position.y 10)
              (> e.position.x 1014)
              (> e.position.y 1014))
      (set e.velocity.x (- e.velocity.x))
      (set e.velocity.y (- e.velocity.y)))))

(fn MoveSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (love.graphics.setColor .4 .4 .4)
    (love.graphics.line
      e.position.x e.position.y
      (- e.position.x (/ e.velocity.x 6)) (- e.position.y (/ e.velocity.y 6)))))

(local FieldofviewSystem (ecs.system {:pool [:fieldofview :position]}))
(fn FieldofviewSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (each [i t (ipairs (tree:search (- e.position.x e.fieldofview.r)
                                    (- e.position.y e.fieldofview.r)
                                    (+ e.position.x e.fieldofview.r)
                                    (+ e.position.y e.fieldofview.r)))]
      (if (and t.position
               (not= e t)
               (< (distance-between e t) e.fieldofview.r))
        (tset e.fieldofview.vision i {:position {:x t.position.x :y t.position.y}
                                      :velocity {:x t.velocity.x :y t.velocity.y}})
        (tset e.fieldofview.vision i nil))

      ;(if (not t.position)
      ;  (each [k v (pairs t)]
      ;    (print k v)))
      )))

(fn FieldofviewSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (when e.position.special
      (love.graphics.circle :line e.position.x e.position.y e.fieldofview.r)
      (each [_ v (pairs e.fieldofview.vision)]
        (when v
          (love.graphics.circle :line v.position.x v.position.y 10))))))

(local speed 5)

(local SeparationSystem (ecs.system {:pool [:velocity :fieldofview :separation]}))
(fn SeparationSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (var x 0)
    (var y 0)
    (each [i v (pairs e.fieldofview.vision)]
      (when (< (distance e.position.x e.position.y v.position.x v.position.y) e.separation.r)
        (-= x (- v.position.x e.position.x))
        (-= y (- v.position.y e.position.y))))
    (set e.separation.x x)
    (set e.separation.y y)
    (+= e.velocity.x (* (/ x 1) dt speed))
    (+= e.velocity.y (* (/ y 1) dt speed))))

(fn SeparationSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (when e.position.special
      (love.graphics.setColor 1 .5 .5)
      (love.graphics.circle :line e.position.x e.position.y e.separation.r)
      (love.graphics.line e.position.x e.position.y
                          (+ e.position.x e.separation.x) (+ e.position.y e.separation.y)))))


(local CohesionSystem (ecs.system {:pool [:velocity :fieldofview :cohesion]}))
(fn CohesionSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (var x 0)
    (var y 0)
    (var n (core.count e.fieldofview.vision))
    (when (> n 0)
      (each [i v (pairs e.fieldofview.vision)]
        (+= x v.position.x)
        (+= y v.position.y))
      (set x (/ x n))
      (set y (/ y n))
      (set e.cohesion.x x)
      (set e.cohesion.y y)
      (set x (* (/ (- x e.position.x) 100) dt speed))
      (set y (* (/ (- y e.position.y) 100) dt speed))
      (+= e.velocity.x x)
      (+= e.velocity.y y))))

(fn CohesionSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (when e.position.special
      (love.graphics.setColor .5 .5 1)
      (love.graphics.line e.position.x e.position.y
                          e.cohesion.x e.cohesion.y))))


(local AlignmentSystem (ecs.system {:pool [:velocity :fieldofview :alignment]}))
(fn AlignmentSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (var x 0)
    (var y 0)
    (var n (core.count e.fieldofview.vision))
    (when (> n 0)
      (each [i v (pairs e.fieldofview.vision)]
        (+= x v.velocity.x)
        (+= y v.velocity.y))
      (set x (/ x n))
      (set y (/ y n))
      (set e.alignment.x x)
      (set e.alignment.y y)
      (+= e.velocity.x (* (/ x 8) dt speed))
      (+= e.velocity.y (* (/ y 8) dt speed)))))

(fn AlignmentSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (when e.position.special
      (love.graphics.setColor .5 1 .5)
      (love.graphics.line e.position.x e.position.y
                          (+ e.position.x e.alignment.x) (+ e.position.y e.alignment.y)))))

(local FearSystem (ecs.system {:pool [:position :velocity :fear]}))
(fn FearSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (var x 0)
    (var y 0)
    (var (mx my) (love.mouse.getPosition))
    (when (< (distance e.position.x e.position.y mx my) 250)
      (if (love.mouse.isDown 1)
        (do
          (set x (- mx e.position.x))
          (set y (- my e.position.y)))
        (love.mouse.isDown 2)
        (do
          (set x (- e.position.x mx))
          (set y (- e.position.y my))))
      (+= e.velocity.x (* x dt speed))
      (+= e.velocity.y (* y dt speed)))))

; -- world --

(local world (ecs.world))
(world:addSystems FieldofviewSystem
                  SeparationSystem
                  CohesionSystem
                  AlignmentSystem
                  FearSystem
                  MoveSystem
                  DrawSystem)

; -- entities --

(let [e (doto (ecs.entity world)
              (: :give :drawable 1 1 1)
              (: :give :position 512 512 true)
              (: :give :velocity (math.random -50 50) (math.random -50 50))
              (: :give :fieldofview)
              ;(: :give :separation)
              ;(: :give :cohesion)
              ;(: :give :fear)
              ;(: :give :alignment)
              )]
  (tree:insert e))

(for [i 1 100]
  (let [x (math.random 10 1014)
        y (math.random 10 1014)
        e (doto (ecs.entity world)
                (: :give :drawable)
                (: :give :position x y)
                (: :give :velocity (math.random -50 50) (math.random -50 50))
                ;(: :give :fieldofview)
                ;(: :give :separation)
                ;(: :give :cohesion)
                ;(: :give :fear)
                ;(: :give :alignment)
                )]
    (tree:insert e)))

; -- setup --

(fn love.conf [t]
  (set t.console true))

(fn love.load []
  (love.window.setMode 1024 1024))

(fn love.update [dt]
  (world:emit :update dt))

(fn love.draw []
  (love.graphics.setBackgroundColor .25 .25 .25)
  (world:emit :draw))

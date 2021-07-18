(local ecs (require :lib.concord))
(local Vector (require :lib.vector))
(local QuadTree (require :lib.quadtree))

(fn shallow-merge [c xt]
  (each [k v (pairs xt)]
    (tset c k v))
  c)

(local others [])
(local tree (QuadTree 0 0 512 512))

; -- components --

(ecs.component :position
  (fn [c x y]
    (set c.v (Vector (or x 0) (or y 0)))))

(ecs.component :radius
  (fn [c r]
    (set c.r (or r 10))))

(ecs.component :collision
  (fn [c]
    (set c.is? false)))

(ecs.component :movable)

; -- systems --

;(local DrawSystem (ecs.system {:pool [:position :radius]}))
;
;(fn DrawSystem.draw [s]
;  (each [_ e (ipairs s.pool)]
;    (let [x e.position.v.x
;          y e.position.v.y
;          r e.radius.r]
;      (love.graphics.setColor .6 .6 .6)
;      (love.graphics.circle :line x y r))))


(local MoveSystem (ecs.system {:pool [:position :movable]}))

(fn MoveSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (let [p e.position]
      (set p.v (+ p.v (* dt 5 (Vector (math.random -1 1) (math.random -1 1))))))))

(local CollisionSystem (ecs.system {:pool [:position :radius :collision]}))

(fn CollisionSystem.update [s dt]
  (each [_ e (ipairs s.pool)]
    (let [p e.position
          r e.radius.r]
      (set e.collision.is? false)
      (each [i o (ipairs (tree:search (- e.position.v.x (+ 0 (* 2 r)))
                                      (- e.position.v.y (+ 0 (* 2 r)))
                                      (+ e.position.v.x (+ 0 (* 2 r)))
                                      (+ e.position.v.y (+ 0 (* 2 r)))))]
        (let [d (- o.position.v e.position.v)]
          (when (and (<= d.length (+ e.radius.r o.radius.r))
                     (not (= e o)))
            (set e.collision.is? true)))))))

(fn CollisionSystem.draw [s]
  (each [_ e (ipairs s.pool)]
    (let [x e.position.v.x
          y e.position.v.y
          r e.radius.r]
      (if e.collision.is?
        (do (love.graphics.setColor .5 .5 .5)
          (love.graphics.circle :line x y r))
        (do (love.graphics.setColor 1 1 1)
          (love.graphics.circle :fill x y r)))
      )))

; -- world --

(local world (ecs.world))
(world:addSystems
  MoveSystem
  CollisionSystem)

; -- setup --

(fn love.conf [t]
  (set t.console true))

(fn love.load []
  (love.window.setMode 512 512)
  (for [i 1 500]
    (let [x (math.random 10 502)
          y (math.random 10 502)]
      (tree:insert
        (doto (ecs.entity world)
              (: :give :position x y)
              (: :give :collision)
              (: :give :movable)
              (: :give :radius))
        x y)))
  (world:emit :load)
  ;(print (# (tree:search 10 60 10 60)))
  )

(fn love.update [dt]
  (world:emit :update dt))

(fn love.draw []
  (love.graphics.setBackgroundColor .25 .25 .25)
  (world:emit :draw))

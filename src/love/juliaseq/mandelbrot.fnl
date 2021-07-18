;(local canvas (love.graphics.newCanvas 256 256))
;
;(fn love.load []
;  (love.graphics.setCanvas canvas)
;  (love.graphics.clear)
;  (love.graphics.setBlendMode :alpha)
;  (love.graphics.setColor 1 0 0 0.5)
;  (love.graphics.rectangle :fill 0 0 100 100)
;  (love.graphics.setCanvas))
;
;(fn love.draw []
;  (love.graphics.setColor 1 1 1 1)
;  (love.graphics.setBlendMode :alpha :premultiplied)
;  (love.graphics.draw canvas))

(local ps {})

(fn love.load []
  (let [w 1024
        h 1024
        max 100]
    (love.window.setMode w h)
    (for [row 0 (- h 1)]
      (for [col 0 (- w 1)]
        (let [c-re (/ (* (- col (/ w 2)) 4) w)
              c-im (/ (* (- row (/ h 2)) 4) w)]
          (var x 0)
          (var y 0)
          (var i 0)
          (while (and (<= (+ (* x x) (* y y)) 4)
                      (< i max))
            (let [x-new (+ (- (* x x) (* y y)) c-re)]
              (set y (+ (* 2 x y) c-im))
              (set x x-new)
              (set i (+ i 1))))
          (when (< i max)
            (table.insert ps [col row])))))))

(fn love.draw []
  (love.graphics.points ps)
  ;(love.graphics.print "ya")
  )


;(fn use [module ...]
;  (each [k v (pairs module)]
;    (print k)
;    (tset _G k (. module k))))

(var z (require :lib))


(fn load [self name]
  (when (z.nil? (. varsets name))
    (tset varsets name self)
    (set self.path (.. "varsets/" name)))
  self)

(fn bark []
  (print "wooo"))

(setmetatable {
 : load
 : bark
}
{
 :__index
 (fn [self key]
   ; get key here
   key)
 })

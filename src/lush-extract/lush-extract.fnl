; extract colors from a lush theme

(local theme-name :slate)

(fn nvim-rtp []
  "get neovim's runtime path"
  (with-open
    [file (assert (io.popen "nvim --headless -c 'set runtimepath' -c 'q'" "r"))]
    (let [out (file:read "*a")]
      (pick-values 1 (out:gsub "\n" "")))))

(fn get-lush-rtp []
  "get lush's runtime path"
  (var r false)
  (let [rtp (.."," (nvim-rtp) ",")]
    (each [e (rtp:gmatch "([^,]+)")]
      (if (e:find "lush.nvim$")
        (let [e (e:gsub "~" (os.getenv "HOME"))
              e (.. e "/lua/?.lua")]
          (set r e)))))
  r)

(fn get-theme-rtp [theme]
  "get theme runtime path"
  (var r false)
  (let [rtp (.."," (nvim-rtp) ",")]
    (each [e (rtp:gmatch "([^,]+)")]
      (if (e:find theme)
        (let [e (e:gsub "~" (os.getenv "HOME"))
              e (.. e "/lua/lush_theme/?.lua")]
          (set r e)))))
  r)

(set package.path (.. package.path ";" (get-lush-rtp)))
(set package.path (.. package.path ";" (get-theme-rtp theme-name)))
(local theme (require theme-name))

(var export {})
(each [k v (pairs theme.X.lush)]
  (print k v))

(alacritty [
  (varsets [colo font {:var 10}])
  (links { "alacritty.yml" "~/.config/alacritty/alacritty.yml" })])


(module alacritty
  [colo font {var 10}]
  [:alacritty.yml :~/.config/alacritty/alacritty.yml])

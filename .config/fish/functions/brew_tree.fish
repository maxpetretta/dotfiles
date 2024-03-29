function brew_tree
    set -l cyan (set_color cyan)
    set -l white (set_color white)
    brew leaves | xargs brew deps --formula --for-each | sed "s/^.*:/$cyan&$white/"
end

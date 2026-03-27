function export
    for arg in $argv
        set -l pair (string split -m 1 = -- $arg)

        if test (count $pair) -ne 2
            echo "export: expected KEY=VALUE, got '$arg'" >&2
            return 1
        end

        set -gx $pair[1] $pair[2]
    end
end

function fish_greeting
    fastfetch
end

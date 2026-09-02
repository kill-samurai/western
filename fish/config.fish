if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt
    set -l path (string replace -- $HOME '~' $PWD)
    set -l parts (string split / $path)

    if test (count $parts) -gt 2
        set path (string join / $parts[1] ... $parts[-1])
    end

    set_color green
    echo -n $path

    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (command git branch --show-current)

        # Handle detached HEAD
        if test -z "$branch"
            set branch (command git rev-parse --short HEAD)
        end

        set -l upstream (command git rev-parse \
            --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)

        set -l branch_color red

        if test -n "$upstream"
            set -l ahead (command git rev-list --count "$upstream..HEAD")
            set -l behind (command git rev-list --count "HEAD..$upstream")
            set -l changes (command git status --porcelain)

            if test "$ahead" = 0; and test "$behind" = 0; and test -z "$changes"
                set branch_color green
            end
        end

        set_color $branch_color
        echo -n " ($branch)"
    end

    set_color normal
    echo -n ' > '
end

function show_command_duration --on-event fish_postexec
    if test $CMD_DURATION -lt 1000
        echo "󱎫 $CMD_DURATION ms"
    else if test $CMD_DURATION -lt 60000
        set -l seconds (math --scale=2 "$CMD_DURATION / 1000")
        echo "󱎫 $seconds s"
    else
        set -l minutes (math --scale=2 "$CMD_DURATION / 60000")
        echo "󱎫 $minutes min"
    end
end

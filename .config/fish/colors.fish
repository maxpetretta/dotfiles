# Set terminal colors
set -x fish_color_autosuggestion    black                     # the color used for autosuggestions
set -x fish_color_cancel            brblack --bold --background=brwhite  # the color for the '^C' indicator on a canceled command
set -x fish_color_command           yellow                    # the color for commands
set -x fish_color_comment           black                     # the color used for code comments
set -x fish_color_cwd               blue                      # the color used for the current working directory in the default prompt
set -x fish_color_cwd_root          red
set -x fish_color_end               white --bold              # the color for process separators like ';' and '&'
set -x fish_color_error             red                       # the color used to highlight potential errors
set -x fish_color_escape            magenta                   # the color used to highlight character escapes like '\n' and '\x70'
set -x fish_color_history_current   --bold
set -x fish_color_host              normal                    # the color used to print the current host system in some of fish default prompts
set -x fish_color_host_remote       yellow                    # the color used to print the current host system in some of fish default prompts, if fish is running remotely (via ssh or similar)
set -x fish_color_match             --background=blue         # the color used to highlight matching parenthesis
set -x fish_color_normal            normal                    # the default color
set -x fish_color_operator          magenta                   # the color for parameter expansion operators like '*' and '~'
set -x fish_color_param             blue                      # the color for regular command parameters
set -x fish_color_quote             green                     # the color for quoted blocks of text
set -x fish_color_redirection       cyan                      # the color for IO redirections
set -x fish_color_search_match      --background=black        # used to highlight history search matches and the selected pager item (must be a background)
set -x fish_color_selection         --background=434144       # the color used when selecting text (in vi visual mode)
set -x fish_color_status            red
set -x fish_color_user              green                     # the color used to print the current username in some of fish default prompts
set -x fish_color_valid_path        --underline
set -x fish_pager_color_background  434144                    # the background color of a line
set -x fish_pager_color_completion  normal                    # the color of the completion itself
set -x fish_pager_color_description yellow                    # the color of the completion description
set -x fish_pager_color_prefix      white --bold --underline  # the color of the prefix string, i.e. the string that is to be completed
set -x fish_pager_color_progress    white --background=cyan   # the color of the progress bar at the bottom left corner

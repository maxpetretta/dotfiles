# Set terminal colors
set -U fish_color_normal normal                 # default color
set -U fish_color_command green                 # commands like echo
set -U fish_color_keyword red                   # keywords like if - this falls back on the command color if unset
set -U fish_color_quote yellow                  # quoted text like "abc"
set -U fish_color_redirection cyan              # IO redirections like >/dev/null
set -U fish_color_end red                       # process separators like ; and &
set -U fish_color_error red                     # syntax errors
set -U fish_color_param normal                  # ordinary command parameters
set -U fish_color_valid_path --underline        # parameters that are filenames (if the file exists)
set -U fish_color_option magenta                # options starting with “-”, up to the first “--” parameter
set -U fish_color_comment black                 # comments like ‘# important’
set -U fish_color_selection --background=434144 # selected text in vi visual mode
set -U fish_color_operator cyan                 # parameter expansion operators like * and ~
set -U fish_color_escape cyan                   # character escapes like \n and \x70
set -U fish_color_autosuggestion black          # autosuggestions (the proposed rest of a command)
set -U fish_color_cwd green                     # the current working directory in the default prompt
set -U fish_color_cwd_root red                  # the current working directory in the default prompt for the root user
set -U fish_color_user green                    # the username in the default prompt
set -U fish_color_host green                    # the hostname in the default prompt
set -U fish_color_host_remote yellow            # the hostname in the default prompt for remote sessions (like ssh)
set -U fish_color_status red                    # the last command’s nonzero exit code in the default prompt
set -U fish_color_cancel --bold --reverse       # the ‘^C’ indicator on a canceled command
# set -U fish_color_search_match --background=black  # history search matches and selected pager items (background only)

set -U fish_pager_color_progress                  # the progress bar at the bottom left corner
set -U fish_pager_color_background                # the background color of a line
set -U fish_pager_color_prefix --bold --underline # the prefix string, i.e. the string that is to be completed
set -U fish_pager_color_completion normal         # the completion itself, i.e. the proposed rest of the string
set -U fish_pager_color_description yellow        # the completion description
set -U fish_pager_color_selected_background --background=434144 # background of the selected completion
set -U fish_pager_color_selected_prefix green --underline       # prefix of the selected completion
set -U fish_pager_color_selected_completion green --underline   # suffix of the selected completion
set -U fish_pager_color_selected_description yellow             # description of the selected completion
# set -U fish_pager_color_secondary_background  # background of every second unselected completion
# set -U fish_pager_color_secondary_prefix      # prefix of every second unselected completion
# set -U fish_pager_color_secondary_completion  # suffix of every second unselected completion
# set -U fish_pager_color_secondary_description # description of every second unselected completion

# Default colors
set -xU EXA_COLORS "ex=31;1:ur=32;1:uw=33;1:ux=31;1:ue=31;1:gr=32:gw=33:gx=31:tr=32:tw=33:tx=31:su=36:sf=36:gm=33"

# All white except files
set -xU EXA_COLORS "ex=31;1:ur=37:uw=37:ux=37:ue=37:gr=37:gw=37:gx=37:tr=37:tw=37:tx=37:su=36:sf=36:sn=37:sb=37:uu=37:gu=37:gm=33:gt=36:da=37"

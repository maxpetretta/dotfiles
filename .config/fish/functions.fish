function brew_tree
    set -l cyan (set_color cyan)
    set -l white (set_color white)
    brew leaves | xargs brew deps --formula --for-each | sed "s/^.*:/$cyan&$white/"
end

function export
  set arr (echo $argv|tr = \n)
  set -gx $arr[1] $arr[2]
end

function fish_greeting
    neofetch
end

function office
	if test (count $argv) -eq 0
		echo -e "usage:\toffice <filename>\tAny number of files greater than 0 permitted"
	end

	while test (count $argv) -ne 0
		echo "Opening $argv[1]"

        # WORD
		if string match -q '*.doc' -- "$argv[1]";
        or string match -q '*.dot' -- "$argv[1]";
        or string match -q '*.wbk' -- "$argv[1]";
        or string match -q '*.docx' -- "$argv[1]";
        or string match -q '*.docm' -- "$argv[1]";
        or string match -q '*.dotx' -- "$argv[1]";
        or string match -q '*.dotm' -- "$argv[1]";
        or string match -q '*.docb' -- "$argv[1]"
			open -a "Microsoft Word" $argv[1]
        
        # EXCEL
		else if string match -q '*.xls' -- "$argv[1]";
        or string match -q '*.xlt' -- "$argv[1]";
        or string match -q '*.xlsx' -- "$argv[1]";
        or string match -q '*.xlsm' -- "$argv[1]";
        or string match -q '*.xltx' -- "$argv[1]";
        or string match -q '*.xltm' -- "$argv[1]"
			open -a "Microsoft Excel" $argv[1]
		
        # POWERPOINT
        else if string match -q '*.ppt' -- "$argv[1]";
        or string match -q '*.pot' -- "$argv[1]";
        or string match -q '*.pps' -- "$argv[1]";
        or string match -q '*.pptx' -- "$argv[1]";
        or string match -q '*.pptm' -- "$argv[1]";
        or string match -q '*.potx' -- "$argv[1]";
        or string match -q "*.potm" -- "$argv[1]";
        or string match -q "*.ppam" -- "$argv[1]";
        or string match -q "*.ppsx" -- "$argv[1]";
        or string match -q "*.ppsm" -- "$argv[1]";
        or string match -q "*.sldx" -- "$argv[1]";
        or string match -q "*.sldm" -- "$argv[1]"
			open -a "Microsoft PowerPoint" $argv[1]
		
        else
			echo -e "\033[91m$1 is not a recognized Word, Excel,; or PowerPoint file.\033[0m"
		end
		set -e argv[1]
	end
end

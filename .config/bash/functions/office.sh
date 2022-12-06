office() {
	if [ "$#" == "0" ]
		then # Print usage
		echo -e "usage:\toffice <filename>\tAny number of files greater than 0 permitted"
	fi

	while [ ! "$#" == "0" ]
	do
		echo "Opening $1"
		if [[ "$1" == *.doc || "$1" == *.dot || "$1" == *.wbk || "$1" == *.docx || "$1" == *.docm || "$1" == *.dotx || "$1" == *.dotm || "$1" == *.docb ]] #WORD
			then
			open -a "Microsoft Word" "$1"
		elif [[ "$1" == *.xls || "$1" == *.xlt || "$1" == *.xlsx || "$1" == *.xlsm || "$1" == *.xltx || "$1" == *.xltm ]] #EXCEL
			then
			open -a "Microsoft Excel" "$1"
		elif [[ "$1" == *.ppt || "$1" == *.pot || "$1" == *.pps || "$1" == *.pptx || "$1" == *.pptm || "$1" == *.potx || "$1" == *.potm || "$1" == *.ppam || "$1" == *.ppsx || "$1" == *.ppsm || "$1" == *.sldx || "$1" == *.sldm ]] #POWERPOINT
			then
			open -a "Microsoft PowerPoint" "$1"
		else
			echo -e "\033[91m$1 is not a recognized Word, Excel, or PowerPoint file.\033[0m"
		fi
		shift
	done
}

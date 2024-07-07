#!/bin/bash
while true; do
	read -rsn1 char
	printf "You pressed: %q\n" "$char"
done

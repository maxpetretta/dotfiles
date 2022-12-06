#!/usr/bin/env bash

windows=$(yabai -m query --windows --display 1 | jq '[.[] | select(."is-visible"==true and ."is-floating"==false)] | length')

if [[ $windows == 1 ]]; then
  yabai -m config left_padding 1285
  yabai -m config right_padding 1285
  yabai -m space --balance
elif [[ $windows == 2 ]]; then
  yabai -m config left_padding 635
  yabai -m config right_padding 635
  yabai -m space --balance
elif [[ $windows == 3 ]]; then
  yabai -m config left_padding 15
  yabai -m config right_padding 15
  yabai -m space --balance
fi

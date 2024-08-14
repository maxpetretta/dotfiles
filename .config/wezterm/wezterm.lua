local wezterm = require("wezterm")
local config = {}

-- Font
config.font_size = 13.0
config.line_height = 1.22
config.font = wezterm.font_with_fallback({
	{ family = "MonaspiceAr Nerd Font", weight = "Regular" },
	{ family = "MonaspiceAr Nerd Font", weight = "Bold" },
	{ family = "MonaspiceAr Nerd Font", italic = true },
	{ family = "MonaspiceAr Nerd Font", weight = "Bold", italic = true },
})

-- Monokai Pro colors
config.colors = {
	foreground = "#fcfcfa",
	background = "#2d2a2e",
	cursor_bg = "#fcfcfa",
	cursor_fg = "#2d2a2e",
	cursor_border = "#2d2a2e",
	selection_fg = "#fcfcfa",
	selection_bg = "#424144",
	ansi = {
		"#727072",
		"#ff6188",
		"#a9dc76",
		"#ffd866",
		"#78dce8",
		"#fc9867",
		"#ab9df2",
		"#fcfcfa",
	},
	brights = {
		"#727072",
		"#ff6188",
		"#a9dc76",
		"#ffd866",
		"#78dce8",
		"#fc9867",
		"#ab9df2",
		"#fcfcfa",
	},

	-- Search colors
	quick_select_label_bg = { Color = "#ffff00" },
	quick_select_label_fg = { Color = "#000000" },
	quick_select_match_bg = { Color = "#ff9732" },
	quick_select_match_fg = { Color = "#000000" },
}

-- Window
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Scrollback
config.scrollback_lines = 100000

-- Keyboard
config.send_composed_key_when_right_alt_is_pressed = false

return config

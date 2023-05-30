wezterm = require("wezterm")

utils = require("utils")

--
-- Shortcut helpers.
--

local on_macos = string.find(wezterm.target_triple, "darwin") ~= nil

local function bind_leader(key, action)
	return {
		key = key,
		mods = "LEADER",
		action = action,
	}
end

_bind_os_options = {
	ctrl_shift = false,
}

-- Binds CTRL+SHIFT+{key} on Windows, or SUPER+{key} on macOS.
local function bind_os(key, action, options)
	options = utils.table.combine(_bind_os_options, options or {}) -- Allow `options` to be nil.

	local mods
	if on_macos then
		mods = "SUPER"
	else
		if options.ctrl_shift == true then
			mods = "CTRL|SHIFT"
		else
			mods = "CTRL"
		end
	end

	return {
		key = key,
		mods = mods,
		action = action,
	}
end


local font_list = {
	"Monaco",
	"Inconsolata",
}

--
-- Actual config
--

local config = wezterm.config_builder()

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

function format_tab_title(tab, tabs, panes, config, hover, max_width)
	local title = utils.tab_title(tab)

	local pane = tab.active_pane
	local process_name = ""
	if pane.domain_name == "local" then
		process_name = utils.basename(pane.foreground_process_name)
	else
		local user_vars = pane.user_vars
		local cmdline = user_vars.WEZTERM_PROG
		local progname_end = string.find(cmdline, " ")
		process_name = string.sub(cmdline, 1, progname_end)
	end

	local new_output = ""
	if pane.has_unseen_output then
		new_output = " *"
	end


	return (tab.tab_index + 1) .. ":" .. process_name .. " " .. title .. new_output .. " "
end

wezterm.on("format-tab-title", format_tab_title)

config.default_prog = { "zsh", "--login", "-c", "exec xonsh" }

config.font = wezterm.font_with_fallback(font_list)
config.font_size = 13
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font_with_fallback(
			font_list,
			{
				foreground = "#fffeff",
				bold = true,
			}
		)
	}
}

config.bold_brightens_ansi_colors = "BrightAndBold"


-- Multiplexing.
config.unix_domains = {
	{ name = "unix" },
}
config.default_gui_startup_args = { "connect", "unix" }


-- Main keybindings. Set up to act kind of like our tmux config.
config.leader = {
	key = "`"
}

config.keys = {
	-- Equivalent to `bind-key -T prefix "`" send-prefix`
	bind_leader("`", wezterm.action.SendString("`")),

	-- Equivalent to `bind-key -T prefix '"' split-window -v`
	-- domain = "CurrentPaneDomain" is the default.
	bind_leader('"', wezterm.action.SplitVertical { }),

	-- Equivalent to `bind-key -T prefix "%" split-window -h`
	bind_leader("%", wezterm.action.SplitHorizontal { }),

	-- Equivalent to `bind-key -T prefix "c" new-window
	bind_leader("c", wezterm.action.SpawnTab("CurrentPaneDomain")),

	-- Equivalent to `bind-key -T prefix "n" next-window
	bind_leader("n", wezterm.action.ActivateTabRelative(1)),

	-- Equivalent to `bind-key -T prefix "p" previous-window
	bind_leader("p", wezterm.action.ActivateTabRelative(-1)),

	-- Equivalent to bind-key -T prefix "x" confirm-before -p "kill-pane #P? (y-n) kill-pane"
	bind_leader("x", wezterm.action.CloseCurrentPane { confirm = true }),

	-- Equivalent to bind-key -T prefix "h" select-pane -L
	bind_leader("h", wezterm.action.ActivatePaneDirection("Left")),

	-- Equivalent to bind-key -T prefix "j" select-pane -D
	bind_leader("j", wezterm.action.ActivatePaneDirection("Down")),

	-- Equivalent to bind-key -T prefix "k" select-pane -U
	bind_leader("k", wezterm.action.ActivatePaneDirection("Up")),

	-- Equivalent to bind-key -T prefix "l" select-pane -L
	bind_leader("l", wezterm.action.ActivatePaneDirection("Right")),

	-- Equivalent to `bind-key -T prefix "-" select-window -l`
	bind_leader("-", wezterm.action.ActivateLastTab),

	-- Equivalent to `bind-key -T prefix "z" resize-pane -Z`
	bind_leader("z", wezterm.action.TogglePaneZoomState),

	-- Equivalent to `bind-key -T prefix "[" copy-mode`
	bind_leader("[", wezterm.action.ActivateCopyMode),

	bind_leader(":", wezterm.action.ActivateCommandPalette),
	bind_leader(";", wezterm.action.ActivateCommandPalette),

	bind_leader("1", wezterm.action.ActivateTab(0)),
	bind_leader("2", wezterm.action.ActivateTab(1)),
	bind_leader("3", wezterm.action.ActivateTab(2)),
	bind_leader("4", wezterm.action.ActivateTab(3)),
	bind_leader("5", wezterm.action.ActivateTab(4)),
	bind_leader("6", wezterm.action.ActivateTab(5)),
	bind_leader("7", wezterm.action.ActivateTab(6)),
	bind_leader("8", wezterm.action.ActivateTab(7)),
	bind_leader("9", wezterm.action.ActivateTab(8)),
	bind_leader("0", wezterm.action.ActivateTab(0)),

	bind_os("c", wezterm.action.CopyTo("Clipboard"), { ctrl_shift = true }),
	bind_os("v", wezterm.action.PasteFrom("Clipboard"), { ctrl_shift = true }),

	bind_os("-", wezterm.action.DecreaseFontSize),
}

config.colors = {
	foreground = "#c7c7c7",
	background = "#000000",

	cursor_bg = "#c7c7c7",

	ansi = {
		"#000000", -- Black
		"#c91b00", -- Red
		"#00c200", -- Green
		"#c7c400", -- Yellow
		"#0225c7", -- Blue
		"#c930c7", -- Magenta
		"#00c5c7", -- Cyan
		"#c7c7c7", -- White
	},
	brights = {
		"#676767", -- Black
		"#ff6d67", -- Red
		"#5ff967", -- Green
		"#fefb67", -- Yellow
		"#6871ff", -- Blue
		"#ff76ff", -- Magenta
		"#5ffdff", -- Cyan
		"#fffeff", -- White
	},
}

wezterm.on("mux-is-process-stateful", function(process)
	is_xonsh = process.argv[1] == "xonsh"
	if is_xonsh then
		return false
	end
	return nil
end)

return config
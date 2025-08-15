-- Install: winget install wez.wezterm
-- Update: winget upgrade wez.wezterm

local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.window_close_confirmation = "NeverPrompt"
config.default_domain = "WSL:Ubuntu"
-- config.color_scheme = "Brogrammer"
config.font = wezterm.font("RobotoMono Nerd Font", { stretch = "Normal" })
config.font_size = 11.0
config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120

config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		username = "uzzielsw",
		default_cwd = "~",
		default_prog = { "bash" },
	},
}

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" then
		config.webgpu_preferred_adapter = gpu
		break
	end
end

return config

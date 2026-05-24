return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	requires = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lazy_stats = require("lazy").stats()

		require("dashboard").setup({
			theme = "doom", -- 'doom' or 'hyper' are the most used themes
			config = {

				header = {
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"", -- vertical padding
					"",
					"                                                                     ",
					"       ████ ██████           █████      ██                     ",
					"      ███████████             █████                             ",
					"      █████████ ███████████████████ ███   ███████████   ",
					"     █████████  ███    █████████████ █████ ██████████████   ",
					"    █████████ ██████████ █████████ █████ █████ ████ █████   ",
					"  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
					" ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
					"                                                                       ",
					"",
					"",
				},

				center = {
					{
						icon = "📂  ",
						desc = "Recently opened files  ",
						key = "r",
						action = "Telescope oldfiles",
					},
					{
						icon = "🔍  ",
						desc = "Find File              ",
						key = "f",
						action = "Telescope find_files",
					},
					{
						icon = "🗂️  ",
						desc = "File Browser",
						key = "b",
						action = "Neotree float toggle",
					},
					{
						icon = "📖  ", -- thanks Chris
						desc = "Find Word              ",
						key = "w",
						action = "Telescope live_grep",
					},
					{
						icon = "❄️  ",
						desc = "Open Nix Config        ",
						key = "n",
						action = "Telescope find_files cwd=~/.config/nix-config",
					},
					{
						icon = "⬆️  ",
						desc = "Update Plugins         ",
						key = "u",
						action = "Lazy update",
					},
				},

				footer = function()
					local count = lazy_stats.count or 0
					return {
						"",
						string.format("📦  Neovim loaded %d plugins", count),
						"",
					}
				end,
			},
		})
	end,
}

return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- On NixOS, LSPs are provided by Nix packages and Mason binaries won't
			-- work due to hardcoded paths in the Nix store. On other distros,
			-- auto-install so the config works out of the box.
			local is_nixos = vim.fn.executable("nixos-rebuild") == 1
			require("mason-lspconfig").setup({
				ensure_installed = is_nixos and {} or {
					"lua_ls",
					"rust_analyzer",
					"nixd",
					"pyright",
					"gopls",
					"qmlls",
				},
				automatic_installation = not is_nixos,
			})
		end,
	},
}

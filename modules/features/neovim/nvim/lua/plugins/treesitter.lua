return {
	"romus204/tree-sitter-manager.nvim",
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = { "lua", "python", "rust", "go" },
			auto_install = true,
			highlight = true,
		})
	end,
}

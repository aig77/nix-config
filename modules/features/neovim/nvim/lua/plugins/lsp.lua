local lsp_keymaps = {
	-- { mode(s), key, action, description }
	{ "n", "gd", vim.lsp.buf.definition, "Go to definition" },
	{ "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
	{ "n", "gi", vim.lsp.buf.implementation, "Go to implementation" },
	{ "n", "gr", vim.lsp.buf.references, "List references" },
	{ "n", "K", vim.lsp.buf.hover, "Hover docs" },
	{ "n", "<C-k>", vim.lsp.buf.signature_help, "Signature help" },
	{ "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol" },
	{ { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action" },
	{ "n", "gl", vim.diagnostic.open_float, "Line diagnostics" },
	{ "n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic" },
	{ "n", "]d", vim.diagnostic.goto_next, "Next diagnostic" },
	{
		"n",
		"<leader>f",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		"Format buffer",
	},
	{
		"n",
		"<leader>th",
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
		"Toggle inlay hints",
	},
}

return {
	"neovim/nvim-lspconfig",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Configure diagnostic display
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 4,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local on_attach = function(client, bufnr)
			-- Enable inlay hints if supported
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- Auto-format on save for specific filetypes
			if client:supports_method("textDocument/formatting") then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr, async = false })
					end,
				})
			end

			for _, map in ipairs(lsp_keymaps) do
				local mode, lhs, rhs, desc = map[1], map[2], map[3], map[4]
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end
		end

		-- Server configurations
		local server_configs = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						checkOnSave = true,
						check = {
							command = "clippy",
						},
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
						},
						procMacro = {
							enable = true,
						},
						inlayHints = {
							bindingModeHints = { enable = true },
							chainingHints = { enable = true },
							closingBraceHints = { enable = true, minLines = 10 },
							closureReturnTypeHints = { enable = "with_block" },
							parameterHints = { enable = true },
							typeHints = { enable = true },
						},
					},
				},
			},
			nixd = {
				settings = {
					nixd = {
						formatting = {
							command = { "alejandra" },
						},
					},
				},
			},
			pyright = {},
			gopls = {},
			qmlls = {},
		}

		-- Setup all servers manually
		-- This works with both Mason-installed and manually installed LSPs
		-- (Mason is lazy-loaded and only used when user runs :Mason)
		for server_name, config in pairs(server_configs) do
			vim.lsp.config(server_name, {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = config.settings,
			})
			vim.lsp.enable(server_name)
		end
	end,
}

return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		local sources = {}

		-- Lua
		if vim.fn.executable("stylua") == 1 then
			table.insert(sources, formatting.stylua)
		end

		-- Nix
		if vim.fn.executable("alejandra") == 1 then
			table.insert(sources, formatting.alejandra)
		end
		if vim.fn.executable("statix") == 1 then
			table.insert(sources, diagnostics.statix)
		end

		-- Python
		if vim.fn.executable("black") == 1 then
			table.insert(sources, formatting.black)
		end
		if vim.fn.executable("ruff") == 1 then
			table.insert(sources, diagnostics.ruff)
			table.insert(sources, formatting.ruff)
		end

		-- Rust formatting is handled by rust_analyzer's builtin rustfmt

		-- Go
		if vim.fn.executable("gofumpt") == 1 then
			table.insert(sources, formatting.gofumpt)
		end
		if vim.fn.executable("goimports") == 1 then
			table.insert(sources, formatting.goimports)
		end
		if vim.fn.executable("golangci-lint") == 1 then
			table.insert(sources, diagnostics.golangci_lint)
		end

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				if client:supports_method("textDocument/formatting") then
					map("n", "<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, "[C]ode [F]ormat")
				end

				if client:supports_method("textDocument/publishDiagnostics") then
					map("n", "<leader>cl", function()
						vim.diagnostic.open_float()
					end, "[C]ode [L]int info")
				end
			end,
		})
	end,
}

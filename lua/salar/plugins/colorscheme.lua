local colorschemes = require("salar.core.colorschemes")

return vim.tbl_map(function(item)
	local is_koda = item.repo == "oskarnurm/koda.nvim"
	local spec = {
		item.repo,
		lazy = not is_koda,
		priority = is_koda and 1001 or 1000,
	}

	if item.name then
		spec.name = item.name
	end

	return spec
end, colorschemes.items)

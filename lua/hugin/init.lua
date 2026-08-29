local M = {}

M.config = {
	data_module = "hugin.cards",
	game_folder = nil,
}

local items_cache = nil

local function build_file_path(paths, card)
	local dir = paths[card.db]
	return M.config.game_folder .. dir .. "/c" .. tostring(card.id) .. ".lua"
end

local function load_items()
	if items_cache then
		return items_cache
	end

	local ok, data = pcall(require, M.config.data_module)
	if not ok then
		vim.notify("hugin: failed to load data module" .. tostring(data), vim.log.levels.ERROR)
		return {}
	end

	local items = {}
	for _, card in ipairs(data.cards) do
		table.insert(items, {
			id = card.id,
			text = card.name,
			file = build_file_path(data.paths, card),
		})
	end

	items_cache = items
	return items
end

function M.refresh()
	items_cache = nil
	package.loaded[M.config.data_module] = nil
end

function M.pick()
	local items = load_items()
	if #items == 0 then
		vim.notify("hugin: no items loaded", vim.log.levels.WARN)
	end

	Snacks.picker.pick({
		title = "EDOPro card scripts",
		items = items,
		format = function(item)
			return {
				{ item.text, "SnacksPickerLabel" },
				{ "  " },
				{ "c" .. tostring(item.id) .. ".lua", "SnacksPickerComment" },
			}
		end,
		preview = "file",
		confirm = function(picker, item)
			picker:close()
			if not vim.uv.fs_stat(item.file) then
				vim.notify("hugin: file not found (" .. item.file .. ")", vim.log.levels.WARN)
				return
			end
			vim.cmd.edit(item.file)
		end,
	})
end

function M.setup(opts)
	opts = opts or {}
	if opts.game_folder then
		M.config.game_folder = opts.game_folder:gsub("/$", "")
	end
end

return M

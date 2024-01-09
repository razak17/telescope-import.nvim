local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("import.utils")
local default_languages = require("import.languages")
local find_imports = require("import.find_imports")
local insert_line = require("import.insert_line")

local function picker(opts, args)
  local languages = utils.table_concat(opts.custom_languages, default_languages)

  local imports = find_imports(languages)

  if imports == nil then
    vim.notify("Filetype not supported", vim.log.levels.ERROR)
    return nil
  end

  if next(imports) == nil then
    vim.notify("No imports found", vim.log.levels.INFO)
    return nil
  end

  -- add syntax highlighting to the rsults of the picker
  local currentFiletype = vim.bo.filetype
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    once = true, -- do not affect other Telescope windows
    callback = function(ctx)
      -- add filetype highlighting
      vim.api.nvim_buf_set_option(ctx.buf, "filetype", currentFiletype)

      -- make discernible as the results are now colored
      local ns = vim.api.nvim_create_namespace("telescope-import")
      vim.api.nvim_win_set_hl_ns(0, ns)
      vim.api.nvim_set_hl(ns, "TelescopeMatching", { reverse = true })
    end,
  })

  pickers
    .new(args, {
      prompt_title = "Imports",
      sorter = conf.generic_sorter(args),
      finder = finders.new_table({
        results = imports,
        entry_maker = function(import)
          return {
            value = import.value,
            display = import.value,
            ordinal = import.value,
          }
        end,
      }),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          insert_line(selection.value, config.insert_at_top)
        end)
        return true
      end,
    })
    :find()
end

return picker

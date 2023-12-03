local has_telescope, telescope = pcall(require, "telescope")
local picker = require("import.picker")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use telescope-import.nvim.")
end

local config = {}
local default_opts = {
  insert_at_top = true,
  custom_languages = {},
}

return telescope.register_extension({
  setup = function(external_opts, _)
    config = vim.tbl_extend("force", default_opts, external_opts)
  end,
  exports = {
    import = function(opts)
      picker(config, opts)
    end,
  },
})

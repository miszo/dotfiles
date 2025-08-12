---@module 'lazy'
---@type LazySpec[]
return {
  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          return require('dial.map').inc_normal()
        end,
        expr = true,
        desc = 'Increment',
      },
      {
        '<C-x>',
        function()
          return require('dial.map').dec_normal()
        end,
        expr = true,
        desc = 'Decrement',
      },
    },
    opts = function()
      local augend = require('dial.augend')

      local logical_alias = augend.constant.new({
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      })

      local hexcolor_alias = augend.hexcolor.new({ case = 'lower' })

      local let_const_alias = augend.constant.new({
        elements = { 'let', 'const' },
        word = true,
        cyclic = true,
      })

      local ts_cast_alias = augend.constant.new({
        elements = { 'as', 'satisfies' },
        word = true,
        cyclic = true,
      })

      local ordinal_numbers = augend.constant.new({
        -- elements through which we cycle. When we increment, we go down
        -- On decrement we go up
        elements = {
          'first',
          'second',
          'third',
          'fourth',
          'fifth',
          'sixth',
          'seventh',
          'eighth',
          'ninth',
          'tenth',
        },
        -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
        word = false,
        -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
        -- Otherwise nothing will happen when there are no further values
        cyclic = true,
      })

      local weekdays = augend.constant.new({
        elements = {
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        },
        word = true,
        cyclic = true,
      })

      local months = augend.constant.new({
        elements = {
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        },
        word = true,
        cyclic = true,
      })

      local capitalized_boolean = augend.constant.new({
        elements = {
          'True',
          'False',
        },
        word = true,
        cyclic = true,
      })

      return {
        dials_by_ft = {
          css = 'css',
          vue = 'vue',
          javascript = 'typescript',
          typescript = 'typescript',
          typescriptreact = 'typescript',
          javascriptreact = 'typescript',
          json = 'json',
          lua = 'lua',
          markdown = 'markdown',
          sass = 'css',
          scss = 'css',
          less = 'css',
          python = 'python',
        },
        groups = {
          default = {
            augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
            augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.date.alias['%Y/%m/%d'], -- date (2022/02/19, etc.)
            ordinal_numbers,
            weekdays,
            months,
            capitalized_boolean,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            logical_alias,
            augend.semver.alias.semver,
            augend.constant.new({ elements = { 'start', 'end' } }),
            augend.constant.new({ elements = { 'top', 'bottom' } }),
            augend.constant.new({ elements = { 'on', 'off' } }),
            augend.case.new({
              types = { 'PascalCase', 'camelCase', 'snake_case', 'kebab-case', 'SCREAMING_SNAKE_CASE' },
            }),
            augend.paren.new({
              patterns = { { "'", "'" }, { '"', '"' }, { '`', '`' } }, -- single, double, and backtick quotes
              nested = false,
              escape_char = [[\]],
              cyclic = true,
            }),
          },
          vue = {
            let_const_alias,
            ts_cast_alias,
            hexcolor_alias,
            logical_alias,
          },
          typescript = {
            let_const_alias,
            ts_cast_alias,
            hexcolor_alias,
            logical_alias,
          },
          javascript = {
            let_const_alias,
            hexcolor_alias,
            logical_alias,
          },
          css = {
            hexcolor_alias,
          },
          markdown = {
            augend.misc.alias.markdown_header, -- markdown header (##, ###, ####, etc.)
            augend.constant.new({
              elements = { '[ ]', '[x]' },
              word = false,
              cyclic = true,
            }),
            augend.misc.alias.markdown_header,
          },
          json = {
            augend.semver.alias.semver, -- versioning (v1.1.2)
          },
          lua = {
            augend.paren.alias.lua_str_literal, -- Lua string literal brackets ([], {}, etc.)
            augend.constant.new({
              elements = { 'and', 'or' },
              word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
              cyclic = true, -- "or" is incremented into "and".
            }),
          },
          python = {
            augend.constant.new({
              elements = { 'and', 'or' },
            }),
          },
        },
      }
    end,
    config = function(_, opts)
      -- copy defaults to each group
      for name, group in pairs(opts.groups) do
        if name ~= 'default' then
          vim.list_extend(group, opts.groups.default)
        end
      end
      require('dial.config').augends:register_group(opts.groups)
      vim.g.dials_by_ft = opts.dials_by_ft
    end,
  },
}

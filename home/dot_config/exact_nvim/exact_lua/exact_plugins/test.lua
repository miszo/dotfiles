return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-jest',
    },
    opts = {
      discovery = {
        enable = false,
      },
      adapters = {
        ['neotest-jest'] = {},
        ['neotest-vitest'] = {},
      },
    },
  },
}

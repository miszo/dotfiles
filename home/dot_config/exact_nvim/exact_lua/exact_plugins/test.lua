return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'olimorris/neotest-rspec',
      'rouge8/neotest-rust',
    },
    opts = {
      discovery = {
        enable = false,
      },
      adapters = {
        ['neotest-jest'] = {},
        ['neotest-vitest'] = {},
        ['neotest-rspec'] = {},
        ['neotest-rust'] = {},
      },
    },
  },
}

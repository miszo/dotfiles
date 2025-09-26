---@type vim.lsp.Config
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = { 'markdown', 'markdown.mdx', 'md', 'mdx', 'gitcommit' },
  root_markers = { '.git' },
  settings = {
    ['harper-ls'] = {
      userDictPath = '~/.config/harper-ls/dict.txt',
      workspaceDictPath = '',
      fileDictPath = '',
      linters = {
        SpellCheck = true,
        SpelledNumbers = false,
        AnA = true,
        ToDoHyphen = false,
        SentenceCapitalization = false,
        CommaFixes = true,
        UnclosedQuotes = true,
        WrongQuotes = false,
        LongSentences = true,
        RepeatedWords = true,
        Spaces = true,
        CorrectNumberSuffix = true,
        SupposedTo = true,
      },
      codeActions = {
        ForceStable = false,
      },
      markdown = {
        IgnoreLinkTitle = false,
      },
      diagnosticSeverity = 'hint',
      isolateEnglish = true,
      dialect = 'American',
      maxFileLength = 120000,
      ignoredLintsPath = {},
    },
  },
}

vim.filetype.add({
    pattern = {
      [".*%.scm"] = "query"
    },
    extension = {
      ['http'] = 'http',
      ['scm'] = 'query',
      ['query'] = 'query',
    },
  })

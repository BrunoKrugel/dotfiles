-- vim.cmd "set tags+=tags,.git/tags"
-- vim.cmd([[command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')]])
vim.g.gutentags_enabled = true
vim.g.gutentags_generate_on_new = true
vim.g.gutentags_generate_on_missing = true
vim.g.gutentags_generate_on_write = true
vim.g.gutentags_generate_on_empty_buffer = true
vim.g.gutentags_resolve_symlinks = true
vim.g.gutentags_ctags_tagfile = ".git/tags"
vim.g.gutentags_project_root = { ".git", "package.json", "go.mod" }
vim.g.gutentags_ctags_extra_args = {'--tag-relative=yes', '--fields=+ailmnS', }
vim.g.gutentags_add_default_project_roots = false
vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/')
vim.g.gutentags_file_list_command = "fd --type file --hidden --exclude .git"
vim.g.gutentags_ctags_exclude = {
  "*.git",
  "*.svg",
  "*.hg",
  "*/tests/*",
  "build",
  "dist",
  "*sites/*/files/*",
  "bin",
  "node_modules",
  "bower_components",
  "cache",
  "compiled",
  "docs",
  "example",
  "bundle",
  "vendor",
  "*.md",
  "*-lock.json",
  "*.lock",
  "*bundle*.js",
  "*build*.js",
  ".*rc*",
  "*.json",
  "*.min.*",
  "*.map",
  "*.bak",
  "*.zip",
  "*.pyc",
  "*.class",
  "*.sln",
  "*.Master",
  "*.csproj",
  "*.tmp",
  "*.csproj.user",
  "*.cache",
  "*.pdb",
  "tags*",
  "cscope.*",
  ".venv",
  "*.exe",
  "*.dll",
  "*.mp3",
  "*.ogg",
  "*.flac",
  "*.swp",
  "*.swo",
  "*.bmp",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.png",
  "*.rar",
  "*.zip",
  "*.tar",
  "*.tar.gz",
  "*.tar.xz",
  "*.tar.bz2",
  "*.pdf",
  "*.doc",
  "*.docx",
  "*.ppt",
  "*.pptx",
}

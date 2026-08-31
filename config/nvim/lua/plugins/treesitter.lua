return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    priority = 900,
    opts = {
      ensure_installed = {
        "c_sharp",
        "typescript",
        "javascript",
        "tsx",
        "ruby",
        "go",
        "gomod",
        "lua",
        "vim",
        "vimdoc",
        "json",
        "json5",
        "yaml",
        "html",
        "css",
        "scss",
        "markdown",
        "markdown_inline",
        "bash",
        "dockerfile",
        "gitignore",
        "diff",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

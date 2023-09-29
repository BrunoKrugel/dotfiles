local npairs = require "nvim-autopairs"
npairs.setup {}
local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"
local ts_conds = require "nvim-autopairs.ts-conds"

-- rule for: `(|)` -> Space -> `( | )` and associated deletion options
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
npairs.add_rules {
  Rule(" ", " ", "-markdown")
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2],
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      -- We only want to delete the pair of spaces when the cursor is as such: ( | )
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. "  " .. brackets[1][2],
        brackets[2][1] .. "  " .. brackets[2][2],
        brackets[3][1] .. "  " .. brackets[3][2],
      }, context)
    end),
}

for _, bracket in pairs(brackets) do
  npairs.add_rules {
    -- add move for brackets with pair of spaces inside
    Rule(bracket[1] .. " ", " " .. bracket[2])
      :with_pair(function()
        return false
      end)
      :with_del(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%" .. bracket[2]) ~= nil
      end)
      :use_key(bracket[2]),

    -- add closing brackets even if next char is '$'
    Rule(bracket[1], bracket[2]):with_pair(cond.after_text "$"),

    Rule(bracket[1] .. bracket[2], ""):with_pair(function()
      return false
    end),
  }
end

-- add and delete pairs of dollar signs (if not escaped) in markdown
npairs.add_rule(Rule("$", "$", "markdown")
  :with_move(function(opts)
    return opts.next_char == opts.char
      and ts_conds.is_ts_node {
        "inline_formula",
        "displayed_equation",
        "math_environment",
      }(opts)
  end)
  :with_pair(ts_conds.is_not_ts_node {
    "inline_formula",
    "displayed_equation",
    "math_environment",
  })
  :with_pair(cond.not_before_text "\\"))

npairs.add_rule(Rule("/**", "  */"):with_pair(cond.not_after_regex(".-%*/", -1)):set_end_pair_length(3))

npairs.add_rule(Rule("**", "**", "markdown"):with_move(cond.after_text "*"))
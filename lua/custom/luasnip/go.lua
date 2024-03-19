local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix

return {
  s("ternary", {
    -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
    i(1, "cond"),
    t " ? ",
    i(2, "then"),
    t " : ",
    i(3, "else"),
  }),

  s("testfunc", {
    t "func Test_",
    i(1, "FunctionName"),
    t ({"(t *testing.T) {", "\tt.Run("}),
    i(2, "Text"),
    t ", func(t *testing.T) {",
    t "\t",
    i(0),
    t {"","\t})"},
    t { "", "}" },
  }),

  s("trigger", {
    t { "if err != nil {", "\treturn " },
    i(1, "err"),
    t "\n}",
  }),

  -- err return
  s("iferr", {
    t "if err != nil {",
    t { "", "\treturn " },
    i(1, "err"),
    t { "", "}" },
  }),

  s("t", {
    t "fmt.Println(",
    i(1),
    t ")",
  }),

  s("tt", {
    t 'fmt.Printf("',
    i(1),
    t ")",
  }),

  s("fori", {
    t "for i := ",
    i(1),
    t "; i < ",
    i(2),
    t { "; i++ {", "\t" },
    i(3),
    t { "", "}" },
  }),

  s("forr", {
    t "for ",
    i(2, "_"),
    t ", ",
    i(3, "item"),
    t " := range ",
    i(1),
    t { " {", "\t" },
    i(4),
    t { "", "}" },
  }),

  ------------------ func node
  s("func", {
    i(1),
    f(
      function(args, snip, user_arg_1)
        return args[1][1]
      end,
      { 1 },
      {} -- { user_args = { "Will be appended to text from i(0)" } }
    ),
    i(0),
  }),

  s("f2", {
    f(function(args, snip)
      return "i got: " .. snip.captures[1]
    end, {}),
  }),

  ------------------ postFix
  postfix(".len", {
    f(function(_, parent)
      return "len(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),

  postfix(".t", {
    f(function(_, parent)
      return "fmt.Println(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
}

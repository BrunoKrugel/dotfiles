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
local fmta = require("luasnip.extras.fmt").fmta

--- Gets the corresponding result type based on the
--- current function context of the cursor.
---@param info table
local function go_result_type(info)
  local function_node_types = {
    function_declaration = true,
    method_declaration = true,
    func_literal = true,
  }

  -- Find the first function node that's a parent of the cursor
  local node = vim.treesitter.get_node()
  while node ~= nil do
    if function_node_types[node:type()] then
      break
    end

    node = node:parent()
  end

  -- Exit if no match
  if not node then
    vim.notify "Not inside of a function"
    return t ""
  end
  -- This file is in `queries/go/return-snippet.scm`
  local query = assert(vim.treesitter.query.get("go", "return-snippet"), "No query")
  for _, capture in query:iter_captures(node, 0) do
    if handlers[capture:type()] then
      return handlers[capture:type()](capture, info)
    end
  end
end

local go_return_values = function(args)
  return sn(
    nil,
    go_result_type {
      index = 0,
      err_name = "err",
      func_name = args[1][1],
    }
  )
end

return {
  s("ternary", {
    -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
    i(1, "cond"),
    t " ? ",
    i(2, "then"),
    t " : ",
    i(3, "else"),
  }),

  s(
    "efi",
    fmta(
      [[
       <val>, err := <f>
       if err != nil {
        return <result>
       }
       <finish>
       ]],
      {
        val = i(1, "v"),
        f = i(2),
        result = d(3, go_return_values, { 2 }),
        finish = i(0),
      }
    )
  ),

  s("testfunc", {
    t "func Test_",
    i(1, "FunctionName"),
    t { "(t *testing.T) {", "\tt.Run(" },
    i(2, "Text"),
    t ", func(t *testing.T) {",
    t "\t",
    i(0),
    t { "", "\t})" },
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

  postfix(".wrap", {
    d(1, function(_, parent)
      return sn(
        1,
        fmta("<err>(" .. parent.snippet.env.POSTFIX_MATCH .. ")<finish>", {
          err = i(1, "type"),
          finish = i(0),
        })
      )
    end),
  }),
  postfix(".byte", {
    f(function(_, parent)
      return "[]byte(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".u32", {
    f(function(_, parent)
      return "uint32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".u64", {
    f(function(_, parent)
      return "uint64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".i32", {
    f(function(_, parent)
      return "int32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
  postfix(".i64", {
    f(function(_, parent)
      return "int64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
    end, {}),
  }),
}

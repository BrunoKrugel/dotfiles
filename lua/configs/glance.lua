local present, glance = pcall(require, "glance")

if not present then
  return
end

local filter = function(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local filterReactDTS = function(value)
  if value.uri then
    return string.match(value.uri, "%.d.ts") == nil
  elseif value.targetUri then
    return string.match(value.targetUri, "%.d.ts") == nil
  end
end

glance.setup {
  hooks = {
    before_open = function(results, open, jump, method)
      if #results == 1 then
        jump(results[1])
      elseif method == "definitions" then
        results = filter(results, filterReactDTS)
        if #results == 1 then
          jump(results[1])
        else
          open(results)
        end
      else
        open(results)
      end
    end,
  },
}

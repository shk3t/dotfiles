local consts = require("consts")

local M = {}

M.natural_order_with_filetype_cmp = function(left, right)
  local left_ft_priority = consts.FILETYPE_PRIORITIES[left.type]
  local right_ft_priority = consts.FILETYPE_PRIORITIES[right.type]
  if left_ft_priority ~= -1 and right_ft_priority ~= -1 and left_ft_priority ~= right_ft_priority then
    return left_ft_priority < right_ft_priority
  end

  left = left.name:lower()
  right = right.name:lower()

  if left == right then
    return false
  end

  for i = 1, math.max(string.len(left), string.len(right)), 1 do
    local l = string.sub(left, i, -1)
    local r = string.sub(right, i, -1)

    if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
      local l_number = tonumber(string.match(l, "^[0-9]+"))
      local r_number = tonumber(string.match(r, "^[0-9]+"))

      if l_number ~= r_number then
        return l_number < r_number
      end
    elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
      return l < r
    end
  end
end

return M

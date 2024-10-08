for _, key in pairs({"w", "e", "b", "ge"}) do vim.keymap.set({"n", "o", "v"}, key, key, {
  buffer = true,
}) end

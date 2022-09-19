local get_input = function(prompt)
    local ok, result = pcall(vim.fn.input, {prompt = prompt})
    if not ok then
        return nil
    end
    return result
end

require("nvim-surround").setup {
    keymaps = {visual = "s", visual_line = "S", delete = "ds", change = "cs"},
    surrounds = {
        ["("] = {add = {"(", ")"}},
        ["{"] = {add = {"{", "}"}},
        ["<"] = {add = {"<", ">"}},
        ["["] = {add = {"[", "]"}},
    },
    -- indent_lines = false,
    move_cursor = false
}

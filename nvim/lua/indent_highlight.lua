-- colo-indent-highlight
-- Color highlight indentation based on color scheme
-- TODO search "how to create a newvim pulgin"
--      - what is the structure?
local delta = 3
-- require("colo_indent_highlight").setup {
--      rbgdelta
-- }

function LightenDarkenColor(numColor, amt)
    -- Lighten or darken a base 10 RBG color by amt
    -- Return a base 16 RBG hex string starting with '#'
    local r_base = bit.rshift(numColor, 16)
    local b_base = bit.band(bit.rshift(numColor, 8), 0x00FF)
    local g_base = bit.band(numColor, 0x0000FF)

    -- Prevent distortion for edge values
    if amt > 0 then
        amt = math.min(amt, 255-r_base, 255-b_base, 255-g_base)
    end
    if amt < 0 then
        -- Do not produce a negative value
        amt = math.min(amt, r_base, b_base, g_base)
    end

    local r = r_base + amt
    local b = b_base + amt
    local g = g_base + amt
    if not unpack then -- lua version compatibility
        local unpack = table.unpack
    end
    local newColor = bit.bor(g, bit.bor(bit.lshift(b, 8), bit.lshift(r, 16)))
    local hexString = string.format("#%06x", newColor)
    return hexString
end

function setup_color_indent_highlight()
    bg_color = vim.api.nvim_get_hl_by_name('Normal', true).background
    vim.cmd("highlight IndentBlanklineIndent1 guibg=" .. LightenDarkenColor(bg_color, delta) .. " gui=nocombine")
    vim.cmd("highlight IndentBlanklineIndent2 guibg=" .. LightenDarkenColor(bg_color, -delta) .. " gui=nocombine")

    require("indent_blankline").setup {
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
    }
end

vim.api.nvim_create_autocmd(
    "ColorScheme",
    {
		pattern = "*",
		callback = setup_color_indent_highlight,
    }
)
setup_color_indent_highlight()

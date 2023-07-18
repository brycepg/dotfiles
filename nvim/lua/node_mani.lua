-- XXX Try with integrated vim api which vim.treesitter
local api = vim.api

if "a" == "b" then
    print("HI:)")
end
local ts_utils = require('nvim-treesitter.ts_utils')


function delete_simple_conditional_lines()
    -- Delete end
    -- Deindent body
    -- Delete conditional
end


function conditional_range_surrounding_cursor()
    possible_block_node = look_for_parent_node("if_statement", vim.treesitter.get_node())
    if possible_block_node then
        return vim.treesitter.get_node_range(possible_block_node)
    end
    return nil
end


function conditional_body_range_surrounding_cursor(start_node)
    if not start_node then
        start_node = vim.treesitter.get_node()
    end
    possible_block_node = look_for_parent_node("if_statement", start_node)
    -- print("possible_block_node: ", tostring(possible_block_node))
    if possible_block_node then
        node_body = find_node_body(possible_block_node)
        -- print("node_body", tostring(node_body))
        if node_body ~= nil then
            --- use
            local node_body_range = node_body:range()
            -- print(node_body:range())
            -- print(type(node_body:range()))
            -- print(node_body_range)
            return node_body_range
            -- print("node_body:range()", node_body:range())
            -- print("node_body:range()", node_body:range())
            -- print("node_range", tostring(vim.treesitter.get_node_range(node_body)))
            -- return node_body:range()
        end
    end
    return nil
end


function test_conditional_body_range()
    local test_lines={'',
        'if "a" == "b" then',
        '    print("HI:)")',
        'end',
        ''
    }
-- conditional range: 1,0,3,3
-- body range: 2,4,2,17
-- lua: how do I insert a lua multiline lua string into a neovim buffer
    local buffer_handle_or_0 = api.nvim_create_buf(true, true)
    if buffer_handle_or_0 == 0 then
        return nil
    end
    local buffer_handle = buffer_handle_or_0
    local pos = {3, 5}
    api.nvim_buf_set_option(buffer_handle, 'filetype', 'lua')
    api.nvim_buf_set_lines(buffer_handle, 0, #test_lines, false, test_lines)

    local node = get_node_at_pos(buffer_handle, pos)
    if not node then
        print("No node found at pos")
        return nil
    else
        print("Node found: ", tostring(node))
        print("Node type: ", tostring(node:type()))
    end
    local range = conditional_body_range_surrounding_cursor(node)
    print("range", tostring(range))
    assert(range[1] == 2)
    assert(tableEqualForTest(range, {2,4,2,17}) == true)
    -- api.nvim_win_get_buf(bufnr)
    -- api.nvim_buf_delete(buffer_handle)
end

function tableEqualForTest(a, b)
    if a == nil then
        print("first array is empty")
        return nil
    end
    if b == nil then
        print("second array is empty")
        return nil
    end
    if #a ~= #b then
        print("Table len do not match")
        print(string.format("#a: %s. #b: %s", a, b))
        return false
    end
    for index, _ in ipairs(a) do
        if a[index] ~= b[index] then
            print(string.format("a[%s] != b[%s]. %s != %s").format(#a, #b, a[index], b[index]))
            return false
        end
    end
    return true
end

function find_node_body(node)
    for i = 0, node:named_child_count() - 1, 1 do
        -- print("i :" .. tostring(i))
        local child = node:named_child(i)
        local type = child:type()
        -- print("child type: " .. type)
        if type == "block" then
            return child
        end
    end
    return nil
end


function _conditional_body_range_surrounding_cursor()
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ""
    end
    local node = current_node
    while node do
        if node:type() == 'if_statement' then
            break
        end

        node = node:parent()
    end

    local find_body
    find_body = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            -- print("i :" .. tostring(i))
            local child = node:named_child(i)
            local type = child:type()
            -- print("child type: " .. type)
            if type == "block" then
                return vim.treesitter.get_node_range(child)
            end
        end
        return nil
    end
    return find_body(node)
end

function delete_function_declaration_lines()
    funcrowStart, funccolStart, funcrowEnd, funccolEnd = function_range_surrounding_cursor()
    bodyrowStart, bodycolStart, bodyrowEnd, bodycolEnd = function_body_range_surrounding_cursor()
    functionStartDelta = bodyrowStart - funcrowStart
    functionEndDelta = funcrowEnd - bodyrowEnd
    -- print("functionEndDelta: " .. tostring(functionEndDelta))
    if funcrowStart == bodyrowStart then
        print("WARN: function start and body start are on the same line. Unable to do interpolation")
        return nil
    end
    if funcrowEnd == bodyrowEnd then
        -- Then go into column mode
        -- api.nvim_buf_set_text(buf, startLine - 1, startColumn - 1, endLine, endColumn, lines)
        -- XXX probably can handle brace syntax here
        print("WARN: function end and body end are on the same line. Unable to do interpolation")
        return nil
    end
    -- Delete the end first to preverse the line numbers
    api.nvim_buf_set_lines(0, bodyrowEnd+1, bodyrowEnd+functionEndDelta+1, false, {})
    -- Deindent - convert from index to line number
    deindent_lines(bodyrowStart+1, bodyrowEnd+1)
    -- delete the beginning second
    api.nvim_buf_set_lines(0, funcrowStart, funcrowStart+functionStartDelta, false, {})
end


-- < Retrieve the name of the function the cursor is in.
function function_surrounding_cursor()
    if not ts_utils then
        return "<tsutils>"
    end
    local current_node = vim.treesitter.get_node()

    if not current_node then
        return "<none1>"
    end

    local func = current_node

    while func do
        if func:type() == 'function_declaration' then
            break
        end

        func = func:parent()
    end

    if not func then
        prev_function_node = nil
        prev_function_name = ""
        return "<none>"
    end

    if func == prev_function_node then
        return prev_function_name
    end

    prev_function_node = func

    local find_name
    find_name = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            print("i :" .. tostring(i))
            local child = node:named_child(i)
            local type = child:type()
            print("child type: " .. type)

            if type == 'identifier' or type == 'operator_name' then
                return vim.treesitter.get_node_text(child, 0)
            else
                local name = find_name(child)

                if name then
                    return name
                end
            end
        end

        return nil
    end

    prev_function_name = find_name(func)
    return prev_function_name
end

-- Look for parent node with matches `node_name`
-- @param node_name(str): name of the node to look for defined by treesitter
-- @param current_node(optional): the treesitter node to start from
-- @return a treesitter node if found, nil otherwise
-- if current_node is not supplied, the node at cursor will be used
function look_for_parent_node(node_name, current_node)
    if not current_node then
        local current_node = vim.treesitter.get_node()
    end
    if not current_node then
        return nil
    end
    local func = current_node
    while func do
        if func:type() == node_name then
            break
        end
        func = func:parent()
    end

    if not func then
        return nil
    end

    return func
end

function function_range_surrounding_cursor()
    -- XXX ok so the issue I'm having is that
    -- The retured range is inccorect from
    -- using ts_utils

    ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ""
    end
    local func = current_node
    print(current_node)
    print(type(current_node))
    while func do
        print("Checking type")
        if func:type() == 'function_declaration' then
            break
        end
        func = func:parent()
    end

    if not func then
        prev_function_node = nil
        prev_function_name = ""
        return "<none>"
    end

    if func == prev_function_node then
        return prev_function_name
    end

    print(func:type())
    return vim.treesitter.get_node_range(func)
    -- return func:range()
end

-- print("DONT ME")
function test_me()
    print("HI")
end
-- print("DONT ME2")


function generateRange(startNum, endNum)
  local range = {}
  for i = startNum, endNum do
    table.insert(range, i)
  end
  return range
end

function printTable(table_)
    for _, item in ipairs(table_) do
        print(item)
    end
end

function deindent_lines(startRow, endRow)
    -- arguments are line numbers and not an index

    -- startRow and endRow are inclusive
    -- Get the current buffer handle
    local buf = api.nvim_get_current_buf()

    -- Get the shiftwidth value (number of spaces per tabstop)
    local shiftwidth = api.nvim_buf_get_option(buf, 'shiftwidth')

    -- Get the lines to be deindented
    local lines = api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Deindent the specified lines by the tabstop value
    local range = generateRange(startRow, endRow)
    for _, lineNum in ipairs(range) do
      local line = lines[lineNum]
      local deindentedLine = line:gsub("^" .. string.rep(" ", shiftwidth), "")
      lines[lineNum] = deindentedLine
    end

    -- Update the buffer with the modified lines
    api.nvim_buf_set_text(buf, 0, 0, -1, 0, lines)
end

function print_all_parent_node_types()
    ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ""
    end
    local func = current_node
    while func do
        print(func:type())
        func = func:parent()
    end
end

function function_body_range_surrounding_cursor()
    ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ""
    end
    local func = current_node
    while func do
        if func:type() == 'function_declaration' then
            break
        end

        func = func:parent()
    end
    if not func then
        return nil
    end

    local find_body
    find_body = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            -- print("i :" .. tostring(i))
            local child = node:named_child(i)
            local type = child:type()
            -- print("child type: " .. type)
            if type == "block" then
                return vim.treesitter.get_node_range(child)
            end
        end
        return nil
    end
    return find_body(func)
end


function get_node_at_pos(buf, pos, ignore_injected_langs)
  winnr = winnr or 0
  local pos_range_0 = { pos[1] - 1, pos[2] }
  local root_lang_tree = vim.treesitter.get_parser(buf)
  if not root_lang_tree then
    return
  end

  local root ---@type TSNode|nil
  if ignore_injected_langs then
    for _, tree in ipairs(root_lang_tree:trees()) do
      local tree_root = tree:root()
      if tree_root and vim.treesitter.is_in_node_range(tree_root, pos_range_0[1], pos_range_0[2]) then
        root = tree_root
        break
      end
    end
  else
    root = ts_utils.get_root_for_position(pos_range_0[1], pos_range_0[2], root_lang_tree)
  end

  if not root then
    return
  end

  return root:named_descendant_for_range(pos_range_0[1], pos_range_0[2], pos_range_0[1], pos_range_0[2])
end

local ts_utils = require('nvim-treesitter.ts_utils')


function delete_simple_conditional_lines()
    -- Delete end
    -- Deindent body
    -- Delete conditional
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
        -- vim.api.nvim_buf_set_text(buf, startLine - 1, startColumn - 1, endLine, endColumn, lines)
        -- XXX probably can handle brace syntax here
        print("WARN: function end and body end are on the same line. Unable to do interpolation")
        return nil
    end
    -- Delete the end first to preverse the line numbers
    vim.api.nvim_buf_set_lines(0, bodyrowEnd+1, bodyrowEnd+functionEndDelta+1, false, {})
    -- Deindent - convert from index to line number
    deindent_lines(bodyrowStart+1, bodyrowEnd+1)
    -- delete the beginning second
    vim.api.nvim_buf_set_lines(0, funcrowStart, funcrowStart+functionStartDelta, false, {})
end


-- < Retrieve the name of the function the cursor is in.
function function_surrounding_cursor()
    if not ts_utils then
        return "<tsutils>"
    end
    local current_node = ts_utils.get_node_at_cursor()

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
        local current_node = ts_utils.get_node_at_cursor()
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

    -- require "nvim-treesitter.parsers"
    ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()
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
        prev_function_node = nil
        prev_function_name = ""
        return "<none>"
    end

    if func == prev_function_node then
        return prev_function_name
    end

    print(func:type())
    return vim.treesitter.get_node_range(func, 0)
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
    local buf = vim.api.nvim_get_current_buf()

    -- Get the shiftwidth value (number of spaces per tabstop)
    local shiftwidth = vim.api.nvim_buf_get_option(buf, 'shiftwidth')

    -- Get the lines to be deindented
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Deindent the specified lines by the tabstop value
    local range = generateRange(startRow, endRow)
    for _, lineNum in ipairs(range) do
      local line = lines[lineNum]
      local deindentedLine = line:gsub("^" .. string.rep(" ", shiftwidth), "")
      lines[lineNum] = deindentedLine
    end

    -- Update the buffer with the modified lines
    vim.api.nvim_buf_set_text(buf, 0, 0, -1, 0, lines)
end


function function_body_range_surrounding_cursor()
    ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()
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

    -- if not func then
    --     prev_function_node = nil
    --     prev_function_name = ""
    --     return "<none>"
    -- end
    --
    -- if func == prev_function_node then
    --     return prev_function_name
    -- end
    --
    local find_body
    find_body = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            -- print("i :" .. tostring(i))
            local child = node:named_child(i)
            local type = child:type()
            -- print("child type: " .. type)
            if type == "block" then
                return vim.treesitter.get_node_range(child, 0)
            end
        end
        return nil
    end
    return find_body(func)
end

----------------------------------------
--                                    --
-- GrandMA3 Subfixture Layout Builder --
--         By Gabe Odachowski         --
--                                    --
----------------------------------------

-- This plugin takes the main fixtures in a layout view and replaces (by creating a new layout view)
-- those elements with a provided subfixture template.
-- 
-- This project is open source. Feel free to fork the code and be sure to submit any revisions or
-- issues to the project's Github page found here: https://github.com/gabe927/gma3-subfixture-layout
-- 
-- As always, please don't be a dick. If you use this code on your own projects, credit the source!
-- 
-- Instructions for how to use the plugin can be found on the Github page.

---------------------------------
-- EDIT THE USER SETTINGS HERE --
---------------------------------
source_layout = 2 -- Layout with main fixtures
template_layout = 3 -- Layout with template elements
dest_layout = 4 -- Layout to store to
groups_pool_start = 11 -- Groups pool number to start storing subfix groups (one per element in template, will overwrite existing!)
groups_layout = 5 -- Layout to store the subfix group elements
groups_prefix = "JDC" -- Prefix to go at beginning of each group
scaling_factor = 2 -- Scales the position values
overwrite_enabled = false -- Overwrite destination layout
mirror_xy = false -- mirrors the template along a y=x axix
mirror_x = false -- mirrors the template along the x axis
mirror_y = false -- mirrors the template along the y axis

------------------------------------------
-- DON'T EDIT ANYTHING BELOW THIS POINT --
------------------------------------------

-- Other global variables
c = Cmd
p = Printf

-- Layout builder functions --
local function twosCompToInt(val)
    if (val > 32767) then
        return val - 65536
    else
        return val
    end
end

local function getSubfixIdFromLayoutElement(o)
        id = o:Get("Object"):ToAddr() -- returns "Fixture (id).(subid).(subid)..."
        -- remove "Fixture "
        id = string.sub(id, 9, -1)
        -- remove main fixID before first "."
        while ((string.byte(id) ~= string.byte('.')) and (#id > 2)) do -- Reasons why I don't like lua... You can't reference a string as an array.
            id = string.sub(id, 2, -1)
        end
        return id
end

local function getSouceElements()
    local l = DataPool().Layouts[source_layout]
    local elements = {}
    for i = 1, #l do
        if (l[i].selected and (l[i].assignType == "Fixture")) then
            local e = {
                id = l[i].id,
                posx = twosCompToInt(l[i].posx),
                posy = twosCompToInt(l[i].posy)
            }
            table.insert(elements, e)
        end
    end
    return elements
end

local function getTemplateElemets()
    local l = DataPool().Layouts[template_layout]
    local elements = {}
    for i = 1, #l do
        if (l[i].selected and (l[i].assignType == "Fixture")) then
            local e = {
                id = getSubfixIdFromLayoutElement(l[i]),
                posx = twosCompToInt(l[i].posx),
                posy = twosCompToInt(l[i].posy),
                height = l[i].positionh,
                width = l[i].positionw
            }
            table.insert(elements, e)
        end
    end
    return elements
end

local function normalize(elements, param)
    -- find lowest value
    local lowVal = elements[1][param]
    for i = 2, #elements do
        if (elements[i][param] < lowVal) then
            lowVal = elements[i][param]
        end
    end

    -- normalize
    for i = 1, #elements do
        elements[i][param] = elements[i][param] - lowVal
    end
end

local function flipAxis(elements, axisKey, offsetKey)
    -- add offset and negate values
    for i=1, #elements do
        local e = elements[i]
        e[axisKey] = -1 * (e[axisKey] + e[offsetKey])
    end

    -- normalize
    normalize(elements, axisKey)
end

local function swapXY(elements)
    for i=1, #elements do
        local e = elements[i]
        local tempX = e["posx"]
        e["posx"] = e["posy"]
        e["posy"] = tempX
        local tempHeight = e["height"]
        e["height"] = e["width"]
        e["width"] = tempHeight
    end

    -- normalize
    normalize(elements, "posx")
    normalize(elements, "posy")
end

local function doesLayoutExist(layoutNum)
    local l = ObjectList("Layout " .. layoutNum)
    return (#l >= 1)
end

local function removeLayout(layoutNum)
    c("Delete Layout " .. layoutNum)
end

local function newLayout(layoutNum)
    c("Store Layout " .. layoutNum)
end

local function assignElement(type, id, layoutNum)
    c("Assign " .. type .. " " .. id .. " At Layout " .. layoutNum)
end

local function posElement(handle, x, y, h, w)
    handle.posx = x
    handle.posy = y
    handle.positionh = h
    handle.positionw = w
end

-- Group functions
local function removeGroup(num)
    c("Delete Group " .. num)
end

local function appendToGroup(fixID, groupNum)
    c("ClearAll")
    c("Fixture " .. fixID)
    c("Store Group ".. groupNum .. " /m")
end

local function renameGroup(groupNum, name)
    c("Label Group " .. groupNum .. " \"" .. name .. "\"")
end

local function replaceCharInString(fromChar, toChar, str)
    
end

local function main()
    -- get fixID of selected elements in source layout
    local mainElements = getSouceElements()

    -- get elements of template
    local templateElements = getTemplateElemets()

    -- normalize tempate element positions
    normalize(templateElements, "posx")
    normalize(templateElements, "posy")

    -- morph tempate elemets
    -- rotate 90
    if (mirror_xy) then
        swapXY(templateElements)
    end
    -- x axis
    if (mirror_x) then
        flipAxis(templateElements, "posy", "height")
    end
    -- y axis
    if (mirror_y) then
        flipAxis(templateElements, "posx", "width")
    end

    -- remove layouts if overwrite enabled
    if (overwrite_enabled) then
        removeLayout(dest_layout)
        removeLayout(groups_layout)
    end

    -- create new destination layout if it doesn't exist
    if (not doesLayoutExist(dest_layout)) then
        newLayout(dest_layout)
    end

    -- create new gropus layout if it doesn't exist
    if (not doesLayoutExist(groups_layout)) then
        newLayout(groups_layout)
    end

    -- assign new elements
    c("Select Layout " .. dest_layout) -- view the new layout cause I like to watch it build :)
    local destLayoutHandle = DataPool().Layouts[dest_layout]
    local groupsLayoutHandle = DataPool().Layouts[groups_layout]
    for i=1, #mainElements do
        for j=1, #templateElements do
            -- SubFix Layout --
            -- assign the element
            local fixID = tostring((mainElements[i]["id"])) .. templateElements[j]["id"]
            assignElement("Fixture", fixID, dest_layout)
            -- position the element
            local elementHandle = destLayoutHandle[#destLayoutHandle]
            local x = (mainElements[i]["posx"] * scaling_factor) + templateElements[j]["posx"]
            local y = (mainElements[i]["posy"] * scaling_factor) + templateElements[j]["posy"]
            local h = templateElements[j]["height"]
            local w = templateElements[j]["width"]
            posElement(elementHandle, x, y, h, w)

            -- Groups --
            local groupNum = groups_pool_start + j - 1
            -- delete existing group if i=1
            if ((i == 1) and overwrite_enabled) then
                removeGroup(groupNum)
            end
            -- append subfix in respective group
            appendToGroup(fixID, groupNum)
            if (i == 1) then
                -- rename group
                local groupName = groups_prefix .. templateElements[j]["id"]
                groupName = groupName:gsub("%.", "-") -- replace . with - because labels don't work with .
                renameGroup(groupNum, groupName)
                -- assign element
                assignElement("Group", groupNum, groups_layout)
                -- position element
                elementHandle = groupsLayoutHandle[#groupsLayoutHandle]
                x = templateElements[j]["posx"]
                y = templateElements[j]["posy"]
                -- h = templateElements[j]["height"] redundant from above, but you get the idea
                -- w = templateElements[j]["width"]
                posElement(elementHandle, x, y, h, w)
            end
        end
    end
    c("ClearAll")
end

return main
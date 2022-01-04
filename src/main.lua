------------------------------------
--                                --
-- JDC1 Subfixture Layout Builder --
--      By Gabe Odachowski        --
--                                --
------------------------------------

---------------------------------
-- EDIT THE USER SETTINGS HERE --
---------------------------------
source_layout = 2 -- Layout with main fixtures
template_layout = 3 -- Layout with template elements
dest_layout = 4 -- Layout to store to
scaling_factor = 6 -- Scales the position values
overwrite_enabled = false -- Overwrite destination layout
mirror_xy = true -- mirrors the template along a y=x axix
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

local function assignElement(layoutNum, fixID)
    c("Assign Fixture " .. fixID .. " At Layout " .. layoutNum)
end

local function posElement(handle, x, y, h, w)
    handle.posx = x
    handle.posy = y
    handle.positionh = h
    handle.positionw = w
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
        flipAxis(templateElements, "posy", "width")
    end
    -- y axis
    if (mirror_y) then
        flipAxis(templateElements, "posx", "height")
    end

    -- remove destination layout if overwrite enabled
    if (overwrite_enabled) then
        removeLayout(dest_layout)
    end

    -- create new destination layout if it doesn't exist
    if (not doesLayoutExist(dest_layout)) then
        newLayout(dest_layout)
    end

    -- assign new elements
    c("Select Layout " .. dest_layout) -- view the new layout cause I like to watch it build :)
    local destLayoutHandle = DataPool().Layouts[dest_layout]
    for i=1, #mainElements do
        for j=1, #templateElements do
            -- assign the element
            local fixID = tostring((mainElements[i]["id"])) .. templateElements[j]["id"]
            assignElement(dest_layout, fixID)
            -- position the element
            local elementHandle = destLayoutHandle[#destLayoutHandle]
            local x = (mainElements[i]["posx"] * scaling_factor) + templateElements[j]["posx"]
            local y = (mainElements[i]["posy"] * scaling_factor) + templateElements[j]["posy"]
            local h = templateElements[j]["height"]
            local w = templateElements[j]["width"]
            posElement(elementHandle, x, y, h, w)
        end
    end
end

return main
------------------------------------
--                                --
-- JDC1 Subfixture Layout Builder --
--                                --
------------------------------------

-- User settings --
source_layout = 2
template_layout = 3
dest_layout = 4
scaling_factor = 6
-- (for future morphing) {
flip_x = false
flip_y = false
rotate_90 = false
-- }

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

local function removeLayout()
    c("Delete Layout " .. dest_layout)
end

local function newLayout()
    c("Store Layout " .. dest_layout)
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
    lowVal = elements[1][param]
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

local function assignElement(fixID, elemNum)
    
end

local function posElement()
    
end

local function main()
    -- reset the destination layout
    -- c("ClearAll")
    -- removeLayout()
    -- newLayout()

    -- get fixID of selected elements in source layout
    local mainElements = getSouceElements()

    -- get elements of template
    local templateElements = getTemplateElemets()

    -- normalize tempate element positions
    normalize(templateElements, "posx")
    normalize(templateElements, "posy")

    -- morph tempate elemets (for future use)

    -- assign new elements
end

return main
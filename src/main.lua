------------------------------------
--                                --
-- JDC1 Subfixture Layout Builder --
--                                --
------------------------------------

-- User settings --
source_layout = 2
dest_layout = 3

flip_x = false
flip_y = false
rotate_90 = false

-- Fixture functions --
scaling_factor = 6
cells = {
    {
        x_offset = 0,
        y_offset = 0,
        height = 50,
        width = 50,
        subfix = "1.1"
    }
}

-- Other global variables
c = Cmd
p = Printf

-- Layout builder functions --
local function removeLayout()
    c("Delete Layout " .. dest_layout)
end

local function newLayout()
    c("Store Layout " .. dest_layout)
end

local function assignElement(fixID, elemNum)
    
end

local function posElement()
    
end

local function main()
    -- reset the destination layout
    c("ClearAll")
    removeLayout()
    newLayout()
    -- DataPool().Layouts[1][6] = DataPool().Layouts[1][5]
    l = DataPool().Layouts
    p(l[1][5].object)
    l[1][5].posx = 20
    l[1][5].name = "asdf"
    l[1][5].id = 3
end

return main
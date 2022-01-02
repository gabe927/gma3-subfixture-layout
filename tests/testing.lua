local function main1()
    local subfixtureIndex = SelectionFirst();
    Printf("subfixture selected with index: "..subfixtureIndex)
	Printf("Number of selected fixtures: "..SelectionCount())
end

local function main()
    local subfixtureIndex, x, y, z = SelectionFirst();
    local mainFix = GetSubfixture(subfixtureIndex)
    Printf(mainFix.fid)
    repeat
        Printf("subfixture selected with index: "..subfixtureIndex.." x: "..x.." y: "..y.." z: "..z)
        subfixtureIndex, x, y, z = SelectionNext(subfixtureIndex)
    until not subfixtureIndex;
    printChildren(mainFix)
end

function main3()
	local fixture = DataPool().Groups[1]
    -- local fixture = Root()
	-- local fixture = Root()
	-- Printf(fixture[1].name)
	-- Printf(dump(fixture[1]))
	-- print_table(fixture)
	-- for k,v in pairs(fixture) do
	-- 	Printf(tostring(v))  
	-- end
    printChildren(fixture)
    -- Printf(type(fixture:Children()))
end

function main4()
    local seq = DataPool().Sequences[2]
    -- Printf(seq.name)
    seq.name = "asdf"
end

function main5()
    DataPool().Layouts[1][6] = DataPool().Layouts[1][5]
    l = DataPool().Layouts
    l1 = l:Children()[1]
    l2 = l:Children()[2]
    l15 = l1:Children()[5]
    l21 = l2:Children()[1]
    subfix = l21:Get("Object")[1]:ToAddr()
    c("Assign " .. subfix .. "At Layout 3.2 Property \"OBJECT\"")
    l[1][5].posx = -20
    l[1][5].Name = "asdf"
    l[1][5].id = 3
    p(Count(l15))
    printChildren(l1)
end

function printChildren(o)
    Printf(type(o))
    Printf(dump(o))
    Printf(o.name)
    Printf(#o:Children())
    for i = 1, #o:Children() do
        Printf("Child " .. i .. " = " .. o[i].name)
    end
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

return main

--asdf
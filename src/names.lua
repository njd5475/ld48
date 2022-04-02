

function GenerateDemonName(seed, lists)
    love.math.setRandomSeed(seed)

    local name = ''

    for i, list in pairs(lists) do
        local total = #list
        local choice = math.ceil(love.math.random()*total)
        print(choice .. ' total ' .. total)
        name = name .. ' ' .. list[choice]
    end

    return name
end

-- TODO: Add weight to the randomness
-- TODO: Expand the options here
local NAMES = {
    {"Himendinger", "Hazog", "Beelzebub", "The devil", "Morgoth"} -- first names
    ,
    {"The Cleft", "The Dangerous", "The Maleficent", "The Demonsterous", "The Destroyer"} -- second names
}

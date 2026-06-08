local list = {
    "sajo_yukimi",
    "yusa_kozue",
    "yorita_yoshino",
    "hakozaki_serika",
    "suou_momoko"
}

local result = {}
for _, v in ipairs(list) do
    for i = 1, 10 do
        result[#result + 1] = v .. tostring(i)
    end
end

return result

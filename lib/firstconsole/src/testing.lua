

local testing = {}


-- test recursion and layout
testTable = {
    stringKey = "StringValue",
    numberKey = 12345,
    booleanKey = true,
    nilValue = nil,  -- This key-value pair will be tricky since `nil` cannot be a table value
    functionKey = function() print("FunctionValue") end,
    tableKey = {
        nestedStringKey = "NestedStringValue",
        nestedNumberKey = 67890,
        nestedTableKey = {
            "ArrayValue1",
            "ArrayValue2",
            nestedFunctionKey = function() print("NestedFunctionValue") end,
        },
    },
    mixedKeyTable = {
        [1] = "MixedArrayValue1",
        ["one"] = "MixedDictionaryValue1",
        [2] = "MixedArrayValue2",
        ["two"] = "MixedDictionaryValue2",
    },
    recursiveTable = {},
    dt= 0.00,
}

-- Demonstrating a table that references itself (recursive table)
testTable.recursiveTable.self = testTable.recursiveTable
testTable.recursiveTable.parent = testTable

-- Demonstrating a table with metatable
setmetatable(testTable.recursiveTable, {
    __index = function(table, key)
        return "DefaultMetaValue"
    end
})

return testing
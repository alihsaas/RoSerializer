local primitives = require(script.Primitives)

local RoSerializer = {
	array = require(script.Array),
	interface = require(script.Interface)
}

for key, serializer in pairs(primitives) do
	RoSerializer[key] = serializer
end

return RoSerializer
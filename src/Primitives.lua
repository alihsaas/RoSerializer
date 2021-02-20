local Serializer = require(script.Parent.Serializer)
local t = require(script.Parent.t)

local hexUtility = require(script.Parent.HexUtility)

local Primitives = {}

Primitives.string = Serializer(
	"String",
	t.string,
	function(_, serialize)
		return tostring(serialize)
	end,
	function(_, deserialize)
		return deserialize
	end
)

Primitives.number = Serializer(
	"Number",
	t.number,
	function(_, serialize)
		return tostring(serialize)
	end,
	function(self, deserialize)
		local deserialized = tonumber(deserialize)
		if not deserialized then
			error(("Failed to deserialize value of type %s in %s"):format(typeof(deserialize), self.name))
		end
		return deserialized
	end
)

Primitives.boolean = Serializer(
	"Boolean",
	t.boolean,
	function(self, serialize)
		if not t.boolean(serialize) then
			error(("Failed to serialize value of type %s. Expected %s"):format(typeof(serialize), self.name))
		end

		return serialize and "1" or "0"
	end,
	function(_, deserialize)
		if not t.literal("0", "1")(deserialize) then
			error(("Failed to deserialize value of value %s. Expected '0' or '1'"):format(tostring(deserialize)))
		end

		if deserialize == "1" then
			return true
		elseif deserialize == "0" then
			return false
		end
	end
)

Primitives.Color3 = Serializer(
	"Color3",
	t.Color3,
	function(self, serialize)
		local isColor3, errorMessage = self.validate(serialize)
		if not isColor3 then
			error(("Failed to serialize value of type %s. Expected %s"):format(typeof(serialize), self.name))
		end

		return hexUtility.color3ToHex(serialize)
	end,
	function(_, deserialize)
		local isHex, errorMessage = t.match("([%a%d][%a%d])([%a%d][%a%d])([%a%d][%a%d])")(deserialize)
		if not isHex then
			error(("Failed to deserialize value of invalid format, expected Hex format.\n%s"):format(errorMessage))
		end

		return hexUtility.hexToColor3(deserialize)
	end
)

return Primitives
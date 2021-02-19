local t = require(script.Parent.t)
local Serializer = require(script.Parent.Serializer)
local SerializerStructure = require(script.Parent.RoSerializerStructure)

return function(name, structure)
	do
		local isArrayOfRoSerializerStructure, errorMessage = t.map(t.string, SerializerStructure)(structure)
		if not isArrayOfRoSerializerStructure then
			error(("Invalid structure passed to RoSerializer interface call, Fail with error\n%s"):format(errorMessage))
		end
	end
	return Serializer(
		("Interface(%s)"):format(name),
		function(value)
			local isTable, errorMessage = t.table(value)
			if isTable == false then
				return false, errorMessage or ""
			end

			for key, roSerializer in pairs(structure) do
				local success, errMsg = roSerializer.validate(value[key])
				if success == false then
					return false, ("[interface] bad value for %s:\n\t%s"):format(tostring(key), errMsg or "")
				end
			end

			return true
		end,
		function(self, serialize)
			local isInterface, errorMessage = self.validate(serialize)
			if not isInterface then
				error(("Expected interface of type %s. Failed with error\n%s"):format(self.name, errorMessage))
			end

			local serialized = {}

			for key, roSerializer in pairs(structure) do
				serialized[key] = roSerializer:serialize(serialize[key])
			end

			return serialized
		end,
		function(_, deserialize)
			local isInterface, errorMessage = t.map(t.string, t.union(t.string, t.table))(deserialize)
			if not isInterface then
				error(("Expected dictionary of strings. Failed with error\n%s"):format(errorMessage))
			end

			local deserialized = {}

			for key, roSerializer in pairs(structure) do
				deserialized[key] = roSerializer:deserialize(deserialize[key])
			end

			return deserialized
		end
	)
end
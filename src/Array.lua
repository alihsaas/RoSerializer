local t = require(script.Parent.t)
local Serializer = require(script.Parent.Serializer)
local SerializerStructure = require(script.Parent.RoSerializerStructure)

return function(roSerializer)
	do
		local isRoSerializerStructure, errorMessage = SerializerStructure(roSerializer)
		if not isRoSerializerStructure then
			error(("Invalid structure passed to RoSerializer array call, Fail with error%s"):format(errorMessage))
		end
	end

	return Serializer(
		("Array(%s)"):format(roSerializer.name),
		t.array(roSerializer.validate),
		function(self, serialize)
			local isArray, errorMessage = self.validate(serialize)
			if not isArray then
				error(("Expected input of type %s. Failed with error\n%s"):format(self.name, errorMessage))
			end
			local serialized = {}

			for _, value in ipairs(serialize) do
				table.insert(serialized, roSerializer:serialize(value))
			end

			return serialized
		end,
		function(_, deserialize)
			local isArray, errorMessage = t.array(t.union(t.string, t.table))(deserialize)
			if not isArray then
				error(("Expected array of strings. Failed with error\n%s"):format(errorMessage))
			end

			local deserialized = {}

			for _, value in ipairs(deserialize) do
				table.insert(deserialized, roSerializer:deserialize(value))
			end

			return deserialized
		end
	)
end
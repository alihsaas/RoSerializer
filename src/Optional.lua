local t = require(script.Parent.t)
local Serializer = require(script.Parent.Serializer)
local SerializerStructure = require(script.Parent.RoSerializerStructure)

return function(structure)
	do
		local isArrayOfRoSerializerStructure, errorMessage = SerializerStructure(structure)
		if not isArrayOfRoSerializerStructure then
			error(("Invalid structure passed to RoSerializer optional call, Fail with error\n%s"):format(errorMessage))
		end
	end

	return Serializer(
		("Optional(%s)"):format(structure.name),
		t.optional(structure.validate),
		function(self, serialize)
			local isOptional, errorMessage = self.validate(serialize)
			if not isOptional then
				error(("Failed to serialize value of type %s, expected value of type %s. Fail with error\n"):format(typeof(serialize), self.name, errorMessage))
			end

			if serialize == nil then
				return
			end

			return structure:serialize(serialize)
		end,
		function(_, deserialize)
			if deserialize == nil then
				return
			end

			return structure:deserialize(deserialize)
		end
	)
end
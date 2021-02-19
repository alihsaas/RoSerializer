local MESSAGE = {
	serialize = "Failed to serialize initial at key %s with initial value %s and result %s",
	deserialize = "Failed to deserialize initial at key %s with initial value %s"
}

return function()
	local ser = require(script.Parent)

	it("should support basic types", function()
		expect(ser.number:serialize(10)).to.equal("10")
		expect(ser.number:deserialize("10")).to.equal(10)
	end)
	it("should support array serialization and deserialization", function()
		local array = ser.array(ser.number)

		local initial = {10, 20, 10, 40, 10}

		local serialized = array:serialize(initial)

		for key, value in ipairs(initial) do
			assert(serialized[key] == tostring(value), MESSAGE.serialize:format(key, value, serialized[key]))
		end

		local deserialized = array:deserialize(serialized)

		for key, value in ipairs(deserialized) do
			assert(deserialized[key] == value, MESSAGE.deserialize:format(key, value, deserialized[key]))
		end
	end)
	it("should support interface serialization and deserialization", function()
		print(ser.color3)
		local interface = ser.interface("TestInterface", {
			String = ser.string,
			Number = ser.number,
			Color3 = ser.Color3,
		})

		local initial = {
			String = "LoL!",
			Number = 10,
			Color3 = Color3.fromRGB(10, 10, 10)
		}

		local serialized = interface:serialize(initial)

		for key, value in ipairs(initial) do
			assert(serialized[key] == value, MESSAGE.serialize:format(key, value, serialized[key]))
		end

		local deserialized = interface:deserialize(serialized)

		for key, value in ipairs(deserialized) do
			assert(deserialized[key] == value, MESSAGE.deserialize:format(key, value, deserialized[key]))
		end
	end)
end

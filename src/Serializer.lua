return function (name, validate, serializer, deserializer)
	return {
		name = name,
		validate = validate,
		serialize = serializer,
		deserialize = deserializer
	}
end
local t = require(script.Parent.t)

return t.interface({
	name = t.string,
	validate = t.callback,
	serialize = t.callback,
	deserialize = t.callback
})
local hexUtility = {}

function hexUtility.hexToColor3(hex)
	local r, g, b = string.match(hex, "([%a%d][%a%d])([%a%d][%a%d])([%a%d][%a%d])")
	return Color3.new((tonumber(r, 16)) / 255, (tonumber(g, 16)) / 255, (tonumber(b, 16)) / 255)
end
function hexUtility.getHex(num)
	return string.format("%02X", num)
end

function hexUtility.color3ToHex(color)
	local result = {}

	for _, num in ipairs({color.r, color.g, color.b}) do
		table.insert(result, hexUtility.getHex(num * 255))
	end

	return table.concat(result)
end

return hexUtility
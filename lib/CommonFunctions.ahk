#Requires AutoHotkey v2

ConvertCCValueToScale(value, minimum_value, maximum_value) {
	if (value > maximum_value) {
		value := maximum_value
	} else if (value < minimum_value) {
		value := minimum_value
	}
	return (value - minimum_value) / (maximum_value - minimum_value)
}

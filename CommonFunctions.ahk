
DisplayOutput(event, value) {
	Gui,14:default
	Gui,14:ListView, Out1 ; see the second listview midi out monitor
		LV_Add("",event,value)
		LV_ModifyCol(1,"center")
		LV_ModifyCol(2,"center")
		If (LV_GetCount() > 10)
		{
			LV_Delete(1)
		}
}

ConvertToAxis(value, maximum_axis_value) {
	return Floor(value * maximum_axis_value)
}

ConvertCCValueToScale(value, minimum_value, maximum_value) {
	if (value > maximum_value) {
		value := maximum_value
	} else if (value < minimum_value) {
		value := minimum_value
	}
	return (value - minimum_value) / (maximum_value - minimum_value)
}

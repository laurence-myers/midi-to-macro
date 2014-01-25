
DisplayOutput(event, value) {
	Gui,14:default
	Gui,14:ListView, Out1 ; see the second listview midi out monitor
		LV_Add("",event,value)
		LV_ModifyCol(1,"center")
		LV_ModifyCol(2,"center")
		LV_ModifyCol(3,"center")
		LV_ModifyCol(4,"center")
		LV_ModifyCol(5,"center")
		If (LV_GetCount() > 10)
			{
				LV_Delete(1)
			}
}

ConvertCCValueToAxis(value, maximum_value, maximum_axis_value) {
	return Floor(ConvertCCValue(value, maximum_value) * maximum_axis_value)
}

ConvertCCValue(value, maximum_value) {
	if (value > maximum_value) {
		value := maximum_value
	}
	return (value / maximum_value)
}
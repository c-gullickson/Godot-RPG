extends OptionButton

# A button to signify the change of a character's Gender
signal gender_selection_changed(selected_index, selected_value)

func _on_item_selected(index):
	var selected_text = get_item_text(index)
	emit_signal("gender_selection_changed", index, selected_text)
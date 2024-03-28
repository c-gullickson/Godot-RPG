extends HBoxContainer

@export var stat_text: String = "label"

@onready var stat_label = $stat_label
@onready var stat_progressbar = $stat_bar

var stat_progress_value: float = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	stat_label.text = stat_text
	stat_progressbar.value = stat_progress_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

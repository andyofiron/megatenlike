extends Node
class_name OverworldDialogue

@export var Flag : FlagContainer
@export var PlayerController : PlayerController
var textSpeed : float = 60
signal DialogueFlagBroadcast(flag)
var tesst : Array
var dialogText : Label
var nameText : Label
var talkIcon : TextureRect
var talkSprite : TextureRect
var canProgress : bool = false
var controller : PlayerController
var textNext : bool = false
var box : Panel
var popspeed : float
var boxOn : bool = false

func _input(event):
	if event.is_action_pressed("test"):
		StartDialogue(tesst)

func _process(delta):
	if Input.is_key_pressed(KEY_L) and not boxOn:
		StartDialogue(tesst)
	if Input.is_key_pressed(KEY_Z) and canProgress:
		textNext = true
	var bb = box.color.a
	if boxOn:
		box.color = Color(1, 1, 1, lerp(bb, 0.9, 0.5))
	if not boxOn:
		box.color = Color(1, 1, 1, lerp(bb, 0, 0.1))
		if 1 - box.color.a > 0.05:
			box.color = Color(1, 1, 1, 0)
			dialogText.get_parent().hide()

func _ready():
#	$AnimatedSprite = dialogText
	$AnimatedSprite.show()
	box.color = Color(1, 1, 1, 0)
	boxOn = true
	controller.inDialog = true

func EndDialogue():
	textNext = false
	boxOn = false
	controller.inDialog = false

func StartDialogue(conversation):
	dialogText.get_parent().show()
	box.color = Color(1, 1, 1, 0)
	boxOn = true
	controller.inDialog = true
	for line in conversation:
		TypeDialog(line)
		textNext = false
		await(self.textNext)
		
		if not line.Flag.flag.empty():
			
			var newflag = Flag.Flag.new()
			newflag.flag = line.Flag.flag
			newflag.type = Flag.FlagType.Room
			DialogueFlagBroadcast.emit(line.Flag)
			PlayerController.envFlags.append(line.Flag)
	EndDialogue()

func TypeDialog(dialog):
	dialogText.set_text("")
	nameText.set_text(dialog.name)
	talkIcon.set_modulate(Color(1, 1, 1, 0))
	talkSprite.set_texture(dialog.talkSprite)
	canProgress = false
	for letter in str(dialog.dialogue):
		dialogText.set_text(dialogText.get_text() + letter)
		if not Input.is_action_pressed("run"):
			await (get_tree().create_timer(1.0 / textSpeed))
	canProgress = true
	talkIcon.set_modulate(Color(1, 1, 1, 1))

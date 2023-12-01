extends CharacterBody3D
class_name PlayerController

enum InteractType {NormalDialogue, Inspect, InspectLore}



#IntertLore: # Shows 

@export_group("Player Properties")
@export var moveSpeed : float
@export var camSpeed : float
@export var RunMultiplier : float
@export var inDialog : bool = false
@export var inMenu : bool = false
@export_group("Instances")
@export var PlayerRB : PlayerController
@export var interactionSquare : StaticBody3D
@export var Cam : Node3D
@export_group("Modules")
@export var dialogueScript : OverworldDialogue
@export var inspectionUI : InspectionUI

@export_group("Other Props.")
var cMoveSpd : float
var isMoving : bool
var input : Vector2
@export var cameraOffset : Vector3
var interactRange : float = 1
var interactableLayer : int
@export var interactOffset : Vector3

var envFlags : Array = []
@onready var animator : AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	pass
#	animator =  $AnimatedSprite
#	interactionSquare.position  = interactOffset

func _physics_process(delta):
	InputHandling()
	InteractionCheck()
#	animator.set("isMoving", isMoving)
	CamMove()

func InteractionCheck():
	if Input.is_action_pressed("interact") and (not inDialog and not inMenu):
		var circall = interactionSquare.get_overlapping_bodies();
		if circall.size() > 0:
			var circ = circall[0]
			var hitObject = circ.get_parent()

			var objDialogue = hitObject.get_node("DialogueReturner")
			match objDialogue.interactionType:
				InteractType.NormalDialogue: # Normal NPC/Item Pickup/Button/etc. Dialogue
					dialogueScript.StartDialogue(objDialogue.dialogue)
				InteractType.Inspect: # Shows image you can freely close out of
					inspectionUI.OpenUI(objDialogue.inspectSprite)
				InteractType.InspectLore: # Shows dialogue over an inspection image, similar to event CGS
					pass

func CamInstantTravel():
	Cam.global_position = lerp(Cam.global_position, self.global_position + cameraOffset, 1)

func CamMove():
	Cam.global_position = lerp(Cam.global_position, self.global_position + cameraOffset, camSpeed / 100)

func InputHandling():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if Input.is_action_pressed("run"):
		cMoveSpd = RunMultiplier
	else:
		cMoveSpd = 1

	if input != Vector2.ZERO and (not inDialog and not inMenu):
		var targDir = Vector3(input.x, 0, input.y)
		interactOffset = targDir.normalized() * interactRange
		
		Move(targDir.clamp(-Vector3.ONE*0.5,Vector3.ONE*0.5) * (cMoveSpd * moveSpeed))
	else:
		Move(Vector3.ZERO)

func Move(targetPos):
	print(targetPos)
	if targetPos == null:
		targetPos = Vector3.ZERO
	PlayerRB.translate(targetPos)
#	self.global_position = Vector3(self.global_position.x, self.global_position.y, self.global_position.z)

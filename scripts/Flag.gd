extends Node
class_name FlagContainer

enum FlagType { Room, Battle, Unlock, Lock, SetLastRoom }

class Flag:
	var flag: String
	var type: FlagType
	var location: Vector3

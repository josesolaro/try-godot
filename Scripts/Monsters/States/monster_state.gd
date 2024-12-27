class_name MonsterState extends State

const IDLE = "idle"
const ATTACK = "attack"

var monster: SkeletonWarriorMonster

func _ready() -> void:
	await owner.ready
	monster = owner as SkeletonWarriorMonster
	assert(monster != null, "The MonsterState state type must be used only in the monster scene. It needs the owner to be a SkeletonWarriorMonster node.")

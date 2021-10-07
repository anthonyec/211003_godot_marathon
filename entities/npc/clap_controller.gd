extends Spatial

onready var clap_sound: AudioStreamPlayer3D = $ClapSound
onready var voice: AudioStreamPlayer3D = $Voice
onready var timer: Timer = $Timer

onready var left_arm: Spatial = $"../LeftArm"
onready var right_arm: Spatial = $"../RightArm"
onready var animation: AnimationPlayer = $"../AnimationPlayer"

var state = 'idle'
var clap_sound_files = []
var shout_sound_files = []

var shouts = {
	"male_1": ["yay", "woo", "hello"],
	"male_2": [],
	"female_1": []
}

var shout_animations = [
	"npc_wave",
	"npc_shout",
	"npc_fist_pump"
]

func _ready() -> void:	
	for index in range(1, 10):
		var audio_file_template = "res://entities/npc/sfx/claps/clap_%s.wav" 
		var audio_file = audio_file_template % [index]
		
		if File.new().file_exists(audio_file):
			var sfx = load(audio_file) 
			clap_sound_files.append(sfx)
	
	for fileName in shouts["male_1"]:
		var audio_file_template = "res://entities/npc/sfx/shouts/%s_%s.wav" 
		var audio_file = audio_file_template % ["male_1", fileName]

		if File.new().file_exists(audio_file):
			var sfx = load(audio_file) 
			shout_sound_files.append(sfx)

	start_idling()

func should_shout() -> bool:
	var dice_roll = rand_range(0, 1)
	var chance = 0.005
	return state != 'shouting' && dice_roll < chance

func start_idling() -> void:
	state = 'idle'
	animation.play("npc_idle")
	animation.seek(rand_range(0, animation.current_animation_length))
	animation.playback_speed = 1

func start_clapping() -> void:
	state = 'clapping'
	animation.play("npc_clap")
	animation.playback_speed = rand_range(1, 6)
	clap_sound.pitch_scale = rand_range(0.8, 1.1)
	clap_sound.max_db = rand_range(-2, 1)

func start_shouting() -> void:
	var previous_state = state;
	var random_index = round(rand_range(0, shout_animations.size() - 1))
	var shout_animation = shout_animations[random_index]
	
	state = 'shouting'

	animation.stop()
	animation.playback_speed = 1	
	animation.play(shout_animation)
	
	yield(animation, "animation_finished")
	
	if previous_state == 'clapping':
		start_clapping()

func start_clapping_with_delay() -> void:
	if state == 'idle':
		timer.wait_time = rand_range(0, 1)
		timer.start()

func clap() -> void:
	var random_index = round(rand_range(0, clap_sound_files.size() - 1));
	clap_sound.stream = clap_sound_files[random_index]
	clap_sound.play()

	if should_shout():
		start_shouting()

func shout() -> void:
	var random_index = round(rand_range(0, shout_sound_files.size() - 1));
	voice.stream = shout_sound_files[random_index]
	voice.play()

func _on_Timer_timeout() -> void:
	start_clapping()

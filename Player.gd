class_name Player extends CharacterBody2D

@export var playerID:int
@export var camera:CameraFollow;
##If this client is in control of this player, the camera will follow it 
func _ready():
	if $MultiplayerSynchronizer.get_multiplayer_authority()== multiplayer.get_unique_id():
		camera.follow(self)
	$GPUParticles2D.emitting = false;

##Tells the Multiplayer synchroizer which player to sync to 
##is called before ready (i.e. before the scene is added to the scene tree
func sync():
	$MultiplayerSynchronizer.set_multiplayer_authority(playerID)
	print(str(playerID))
##Called every frame, if its the authority, it will listed for player input and move based on that
##if not it won't do anything, as the Multiplayer syncronizer will move it based on the other scene 
func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if(Input.is_action_pressed("Jump")):
			velocity += Vector2(1,0)
			if(velocity.x >= 100):
				velocity.x = 100
			$GPUParticles2D.emitting = true;
		else:
			velocity +=Vector2(-1,0)*0.5
			if(velocity.x<0):
				velocity = Vector2.ZERO
			$GPUParticles2D.emitting = false;
		move_and_slide() ##Actually does the moving based on Velocity, part of CharacterBody2D.

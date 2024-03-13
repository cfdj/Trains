class_name CameraFollow extends Camera2D

var follows:Node2D;
func follow(following:Node2D):
	follows = following;
	print("Following " + str(following))

##If its got a player to follow, update its position each frame to keep up
func _process(delta):
	if(follows!=null):
		position.x = follows.position.x

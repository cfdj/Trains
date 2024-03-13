extends Control

##These are used to actually help the connections find eachother
##If you didn't want to hard code this, you could do it via user text entry 
##or by having a third computer act as a server which coordinates the connection
@export var address = "127.0.0.1"
@export var port = 8910

var players:Array[int] ##Stores the IDS of our players
##first it sets up connections for debug purposes
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(Disconneted)

##Connected to the host button
func host():
	var peer = ENetMultiplayerPeer.new() ##peers store all the information about active multiplayer connections
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	print("Hosting")
	players.append(multiplayer.get_unique_id()) ##Geting reading for assigning players for syncronisation layer

##Connected to the join button
func join():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.multiplayer_peer = peer

##When a player connects, save their player ID
func PlayerConnected(id):
	print("Connected: " + str(id))
	players.append(id)
	if(multiplayer.is_server()):
		setPlayers.rpc(id)
##When someone disconnects, just print
##You'd probably want this to do more in a real game
##Like removing their id from the players list
func Disconneted(id):
	print("Disconnected: " +str(id))

##This lets the game be started by anyone
@rpc("any_peer","call_local")
func StartGame():
	var scene:LevelManager = load("res://Level.tscn").instantiate() ##This loads our level from memory, but it doesn't activate it ye
	scene.setPlayers(players); ##Sending our player IDs to the trains
	get_tree().get_root().add_child(scene) ## This adds out level to the scene tree, activating it, so ready and process will run
	self.hide() ##this hides the main menu, but its data is still accessible

func _on_start_pressed():
	StartGame.rpc() ##Calling on everyone
	## StartGame.rpc_id() ##Call on a specific person

##Can only be called by the Server
@rpc("authority")
func setPlayers(id):
	players.append(id) ##Stores the ID of a player who has joined
	print(players)

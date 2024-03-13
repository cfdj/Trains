class_name LevelManager extends Node2D

@export var players:Array[Player]

##Takes in the player ids from the MainMenu and assigns them to each train
##Technically slightly unsafe if there are more players than trains
func setPlayers(IDs:Array[int]):
	for i in IDs.size():
		players[i].playerID = IDs[i]
		players[i].sync()

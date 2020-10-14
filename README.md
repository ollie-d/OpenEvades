# OpenEvades
## An open-source partial implementation of Evades.io

This has been created in order to use the gameplay of Evades.io for scientific experiments. The public implementations posted on this repository may or may not be the most up-to-date version used for experiments. The goal is to use the relatively simplistic gamespace of Evades to study complex agent interactions. This is being made public early on in development in case anybody else wants to develop similar experiments.

### Important Notes:
* This implementation is written in GDScript (for the Godot engine)
* This is NOT a multiplayer implementation
* I have no intent to release this as a downloadable, playable game outside of experiments
* Only the basic features of Evades.io will ever be added (no classes, unique enemies, abilities, levels, etc)

### Current Implemented Features
* Players can control a single character
* Players dodge moving enemies
* The goal is to reach the right side of the level
* Players can safely enter the safe zones
* Enemies will bounce off safe zones
* Enemies collide with walls but not one another
* Player collides with walls
* When the player is struck by the enemy they die
* When the player dies, collision and control are disabled
* When the player dies, a visible timer decrements to denote revival time

### Future Features
* Players can enter the next level in the right save zone
* AI agents will control a player-like entity
* When a player or agent dies, they can be revived
* Revival consists of a non-enemy entity entering the dead entity's area
* Artificial agents can have a variety of behaviors
* Sprites can be altered to display alternate colors and icons

### Videos and GIFs
[09Oct2020] Death now works: https://www.youtube.com/watch?v=mnVrES_Lws0&feature=youtu.be <br>
[08Oct2020] Initial gameplay: https://www.youtube.com/watch?v=qlSxNIk5KDE&feature=youtu.be

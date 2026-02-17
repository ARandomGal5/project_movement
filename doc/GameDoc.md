**Project Movement**


# Overarching Design
## Game Title
(w.i.p.)

## Concept
You've got 10 minutes to spend exploring various stops on this (very long) train line. Some stops are beautiful, others strange, and some you would probably be better off skipping.

## Genre
Walking-Sim / Platformer, similar to anomaly watch, station 7, desert bus.


# Game Design 

## Visual / Audio Style
All textures and models will follow a low-poly, low-resolution style similar to the PS1 era of gaming. Each meter is 16 pixels,


# Game Systems

## Core Loops
The primary loop is the player arriving at a stop, having to explore it with their limited time, then leaving as soon as it runs out.
The secondary larger loop is doing multiple runs to see all of the content in the game. There are planned to be at least 20+ rooms, while each run the player only sees about 4-5 of them due to either their time restriction or the hard stage limit.
The idea is that the player will be able to skip levels they've already seen, and use that time to closely inspect new ones / missed ones.
The main appeal of each stop is to provide a setting that makes the player feel something. Many rooms focus on leaving the player uneasy as with most liminal media, but we also introduce silly rooms / fun rooms as a way to limit it.

## Objectives
The players sole goal is self-driven. They can choose to see every single station, leaving only a short amount of time for each one, or take as much time as they want with a world they find interesting.


## Game Systems

### Map Loading
The internal train is its own map. It is always loaded in memory so it needs to be light weight.
The actual stops themselves are their own scenes that get loaded into the game world.
We will probably have a single scene with both the train scene, and then load the "stop" scene dynamically for each new station, queue freeing it when the player leaves.

### Timing System
The timing system will determine how long the player can stay in a station before they have to leave.
It also determines how long the player's run will last, when their time runs out and they enter the train, they should be sent to the last station.

### Dialouge / NPCS
This is important to get down as the player talks with one NPC quite often as they exist soley in the train. The player also meets some characters outside in the stations as well. We should implement a simple interaction system and dialouge tree. Dialogic would be a good option for this, although it has a fair bit of overhead.

### Achivements
Achievements are easy to implment, we just add a singleton to the autoload scripts and save it to the player's filesystem.

### Item Interaction System 
Physics interaction and item manipulation would add more immersion to the game. It would make it easier to make stations interesting as well as providing the options to make physical puzzles. Seeing as this is a small game, this is probably a fair bit out of scope. We'll see.

## Interactivity
The player moves through the world with the "wasd" keys, as well as CTRL to crouch, and space to jump. They can either click or press "e" to interact with something in front of them.  

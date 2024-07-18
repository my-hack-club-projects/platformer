# platformer

## a platformer game written in Lua using the Love2D framework.

right now, I don't know what the game's gonna be about, but here's some info about the project structure:

- src/: contains the source code of the game.
- src/libs/: libraries used in the game. most of them are written by me during the development of the game, I just like to organize them that way.
- src/types/: classes for types that are used in the game, such as Vector2, Color3, etc.
- src/game/: classes for the game itself, for example 'Player', 'Platform', etc. these classes use the libraries in src/libs/.
- src/game/states/: classes for the game states, such as 'Menu', 'Playing', etc.
- src/game/objects/: classes for the game objects, such as 'Player', 'Platform', etc.
- more folders will be added later as the game grows.

## installation

installation is very simple, follow these steps:

1. install [Love2D](https://love2d.org/).
2. clone the repository.
3. run the game by running `love .` in the src/ directory.

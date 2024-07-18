# platformer

## a platformer game written in Lua using the Love2D framework.

## installation

installation is very simple, follow these steps:

1. install [Love2D](https://love2d.org/).
2. clone the repository.
3. run the game by running `love .` in the src/ directory.

## for developers

to use this code as a base for your game, you can follow this reference:

- `src/` contains the source code of the game.
- `src/libs/` and `src/types/` contain some core libraries and types that are used in the game.
- `src/game/` contains code that is specific to the game itself - this is where you'll put your code.

inside the `src/game/` directory, you'll find a `states` directory. this directory contains the game states. each state is a folder with a `state.lua` file inside it. this file must export a class that inherits from `libs.state`.

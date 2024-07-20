# platformer

## a platformer game written in Lua using the Love2D framework.

- note: all sounds are taken from [pixabay.com](https://pixabay.com/). this is not a commercial project.

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

### states

inside the `src/game/` directory, you'll find a `states` directory. this directory contains the game states. each state is a folder with a `state.lua` file inside it. this file must export a class that inherits from `libs.state`.

the state class must implement the following methods: (or inherit them from `libs.state`)

- `enter` - called when the state is entered, takes previous state as a parameter. use this to create objects and initialize variables.
- `exit` - called when the state is exited. use this to destroy objects and clean up.
- `update` - called every frame. use this for example to move objects, etc.
- `draw` - called every frame for rendering. don't have to override this one, but you can if you want to draw something custom.
  all states must set the `name` property to a unique name.

to change the current state, you can use the `game:setState` method. this method takes the name of the state as an argument. it then calls the `exit` method of the current state, sets the new state, and calls the `enter` method of the new state and passes the previous state into it.

### entities

you can create entities by extending `lib.entity`. entities are objects with a position, size and rotation. they can be drawn and updated. you can also add custom properties and methods to them.

to create instances of entities, use `state.entities.new(EntityClass, entityName)` where `EntityClass` is the class of the entity you want to create. this method returns the created entity.
to find entities, use `state.entities.find(entityName)` where `entityName` is the name of the entity you want to find. this method returns the entity if it exists, otherwise it returns nil.
to destroy entities, use `entity:destroy()` where `entity` is the entity you want to destroy.

### other stuff

inside the `src/lib/` directory, you'll find some other useful classes and functions, such as camera, physics, etc.

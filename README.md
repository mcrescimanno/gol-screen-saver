# Game of Life Screen Saver
A Screen Saver made with the rules of Cellular Automata.

Conway's Game of Life describes a set of rules that apply to an infinite two-dimensional grid of square cells. Each cell on the grid has an initial state of "alive" or "dead", and the cells change their state every "generation" in accordance with the following rules:

> 1. Any live cell with two or three live neighbours survives.
  2.  Any dead cell with three live neighbours becomes a live cell.
  3.   All other live cells die in the next generation. Similarly, all other dead cells stay dead.

Interesting patterns emerge from these simple rules, and I thought it would be neat to create a Mac Screen Saver with this idea. The screen saver works by first computing a pseudo-random initial state for each cell on the grid, draws the grid on screen, and finally applies the rules above on each subsequent animation frame. What we end up with is something like this:

![Game of Life Simulation](https://github.com/mcrescimanno/gol-screen-saver/raw/main/assets/game-of-life.gif)


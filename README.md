# Memory3D

This game is a simple implementation of "Memory" (also known as "Concentration") that showcases [Starling][]'s Sprite3D functionality.

The repository contains three tags that you can use to look at different states of development.

* **2D** is the starting point: turning cards is achieved by animating the "scaleX" property, which creates a pseudo-3D effect.
* **3D** changes the "Card" and "PlayingField" classes to inherit from "Sprite3D". That way, the dealing and flipping animations can be converted to real 3D.
* In **3D-optimized**, the flipping logic is changed so that the cards do not contain any 3D transformations while lying down flat. That way, they can be batched on rendering, which is normally not possible for Sprite3D objects. (Enable the 'showStats' property of Starling to see the number of draw calls.)

I also recorded a [video][] that explains the first two steps of this process.

Note that this project requires the latest development version of Starling. "Sprite3D" will be part of the 1.6 release.

[Starling]: http://www.starling-framework.org
[video]: http://vimeo.com/109564325
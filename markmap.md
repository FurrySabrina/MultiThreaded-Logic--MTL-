---
title: MultiThreaded Logic (MTL)
markmap:
    colorFreezeLevel: 0
    maxWidth: 300
    duration: 250
    spacingVertical: 15
---

#FF5555 FPS#ffffff 20 /\50 \/5

# Completed

- [x] Made a procedurally generated terrain im happy with.
- [x] Made a hud gui that shows performance stats.
    - [x] FPS info
        - [x] Current FPS
    - [x] LCPS (logic calcuations per second.)
    - [x] Time (just how long the world has been running for.)

# Plans

- [ ] Edit more of the stats gui.
    - [ ] FPS info
        - [ ] Max FPS
        - [ ] Min FPS
    - [ ] Hz (how fast (in hz) the logic gates are being calculated.)
        - this is good for dynamic logic gate speeds. otherwise, it wont really be useful.
- [ ] Figure out how the terrain script multithreads.
- [ ] Code the terrain script to calculate the logic gates.
    - ```lua
        while #calcuations~=0 do ... end
      ```
    - Make logic gate speeds dynamic if possible.
- [ ] Need to make a MTL settings gui for game settings eventually.
- [ ] Add some commands eventually.
    - `/mtl` to open the settings gui.
    - `/world <world_index>` to change the current world index. (make sure this is saved when reloading the world.)
    - `/stats` to open or close the stats gui. (make sure to make it save when reloading the world.)

- [ ] Create a warehouse world for creating logic systems.
    - [ ] Could have a thing in the wall that allows logic gates to be connected to mutiple worlds, to save on performance?
        - or instead just have a placeable gate that can be connected to multiple worlds.

# Validation

- [ ] Check for client/server issues.

# Links

- [Github](https://github.com/FurrySabrina/MultiThreaded-Logic--MTL-)

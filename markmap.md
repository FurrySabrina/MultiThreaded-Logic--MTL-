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

# Plans

- [ ] Make a hud gui that shows performance stats.
    - [ ] FPS info
        - [ ] Current FPS
        - [ ] Max FPS
        - [ ] Min FPS
    - [ ] LCPS (logic calcuations per second.)
    - [ ] Hz (how fast (in hz) the logic gates are being calculated.)
        - this is good for dynamic logic gate speeds. otherwise, it wont really be useful.
    - [ ] Time (just how long the world has been running for.)
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
    - `/gateCount` prints the current gate count.
        - Logic Gates : xyz
        - Timers : xyz

# Thoughts

# Links

- [Github](https://github.com/FurrySabrina/MultiThreaded-Logic--MTL-)

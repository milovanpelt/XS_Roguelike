// The xs module is 
import "xs" for Input, Render, Data
import "xs_math" for Bits, Vec2, Math
import "grid" for Grid
import "random" for Random

class Type {
    static none     { 0 << 0 }
    static player   { 1 << 0 }
    static enemy    { 1 << 1 }
    static bomb     { 1 << 2 }
    static wall     { 1 << 3 }
    static door     { 1 << 4 }
    static blocking { wall | door }
}

// The game class it the entry point to your game
class Game {

    // The config method is called before the device, window, renderer
    // and most other systems are created. You can use it to change the
    // window title and size (for example).
    // You can remove this method
    static config() {
        System.print("config")
        
        // This can be saved to the system.json using the
        // Data UI. This code overrides the values from the system.json
        // and can be removed if there is no need for that
        Data.setString("Title", "xs - roguelike", Data.system)
        Data.setNumber("Width", 220, Data.system)
        Data.setNumber("Height", 220, Data.system)
        Data.setNumber("Multiplier", 2, Data.system)
    }

    // The init method is called when all system have been created.
    // You can initialize you game specific data here.
    static init() {
        
        System.print("init")

        System.print("player %(Type.player)")
        System.print("bomb %(Type.bomb)")

        // The "__" means that __time is a static variable (belongs to the class)
        __time = 0

        // grid is the new model
        __grid = Grid.new(5, 2, Type.none)
    }

    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt
    }

    // The render method is called once per tick, right after update.
    static render() {
        // render grid
        var r = 8
        var of = 2 * r + 4
        var sx = (__grid.width - 1) / 2 * of
        var sy = (__grid.height - 1) / 2 * of

        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var val = __grid[x,y]
                if (val == Type.none){
                    Render.setColor(0.8, 0.8, 0.8)
                    Render.circle(x * of - sx, y * of - sy, r, 18)
                } else if (val == Type.player){
                    Render.setColor(0.5, 0.5, 0.9)
                    Render.disk(x * of - sx, y * of - sy, r, 18)
                } else if (val == Type.enemy){
                    Render.setColor(0.9, 0.5, 0.5)
                    Render.disk(x * of - sx, y * of - sy, r, 18)
                }
            }
        }
    }
}
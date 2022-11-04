// This is just confirmation, remove this line as soon as you
// start making your game
System.print("Wren just got compiled to bytecode")

// The xs module is 
import "xs" for Input, Render, Data
import "xs_math" for Bits, Vec2
import "grid" for Grid

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
        Data.setNumber("Width", 360, Data.system)
        Data.setNumber("Height", 360, Data.system)
        Data.setNumber("Multiplier", 1, Data.system)
        Data.setBool("Fullscreen", false, Data.system)
    }

    // The init method is called when all system have been created.
    // You can initialize you game specific data here.
    static init() {        
        
        System.print("init")

        // The "__" means that __time is a static variable (belongs to the class)
        __time = 0

        // Variable that exists only in this function 
        var image = Render.loadImage("[games]/shared/images/FMOD_White.png")
        __sprite = Render.createSprite(image, 0, 0, 1, 1)

        // grid is the new model
        __grid = Grid.new(9, 9, Type.none)

        // add player
        __grid[4, 4] = Type.player

        // add enemies
        __grid[0, 0] = Type.enemy
        __grid[5, 6] = Type.enemy
    }    

    
    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt

        var player = null
        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var val = __grid[x,y]
                if (val == Type.player){
                    player = Vec2.new(x,y)
                }
            }
        }

        var direction = getDirection()
        if (direction != Vec2.new(0, 0)){
            moveDirection(player, direction)
        }
    }

    static getDirection(){
        if (Input.getKeyOnce(Input.keyUp)){
            return Vec2.new(0, 1)
        } else if (Input.getKeyOnce(Input.keyDown)){
            return Vec2.new(0, -1)
        } else if (Input.getKeyOnce(Input.keyLeft)){
            return Vec2.new(-1, 0)
        } else if (Input.getKeyOnce(Input.keyRight)){
            return Vec2.new(1, 0)
        } else{
            return Vec2.new(0, 0)
        }
    }

    static moveDirection(position, direction){
        var from = position
        var to = position + direction
        __grid.swap(from.x, from.y, to.x, to.y)
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
                if (Bits.checkBitFlagOverlap(val, Type.blocking)){

                }
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
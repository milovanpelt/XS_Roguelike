// This is just confirmation, remove this line as soon as you
// start making your game
System.print("Wren just got compiled to bytecode")

// The xs module is 
import "xs" for Input, Render, Data
import "random" for Random

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
        Data.setNumber("Width", 640, Data.system)
        Data.setNumber("Height", 360, Data.system)
        Data.setNumber("Multiplier", 1, Data.system)
        Data.setBool("Fullscreen", false, Data.system)
    }

    // The init method is called when all system have been created.
    // You can initialize you game specific data here.
    static init() {        
        
        System.print("init")
        __playerChar = "@"
        __enemyChar = "E"

        __board = ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"]

        __board.add(__playerChar)
        __board[3] = __enemyChar
        
        // The "__" means that __time is a static variable (belongs to the class)
        __time = 0

        // Variable that exists only in this function 
        var image = Render.loadImage("[games]/shared/images/FMOD_White.png")
        __sprite = Render.createSprite(image, 0, 0, 1, 1)
    }    

    static movePlayer(x) {
        __board[__playerPos] = "_"
        __playerPos = __playerPos + x
        __board[__playerPos] = "@"
    }

    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt
        __playerPos = __board.indexOf("@")

        if(Input.getKeyOnce(Input.keyLeft) && __playerPos > 0) {
            movePlayer(-1)
            
        }

        if(Input.getKeyOnce(Input.keyRight) && __playerPos < __board.count - 1) {
            movePlayer(1)
        }
    }

    // The render method is called once per tick, right after update.
    static render() {
        for (i in 0..__board.count - 1) {
            Render.setColor(0.5, 0.5, 0.5)
            Render.shapeText(__board[i], (i * 30) - 280, 0, 5)
        }
    }
}
// This is just confirmation, remove this line as soon as you
// start making your game
System.print("Wren just got compiled to bytecode")

// The xs module is 
import "xs" for Input, Render, Data
import "grid" for Grid

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
        
        // The "__" means that __time is a static variable (belongs to the class)
        __time = 0

        // Variable that exists only in this function 
        var image = Render.loadImage("[games]/shared/images/FMOD_White.png")
        __sprite = Render.createSprite(image, 0, 0, 1, 1)

        // grid is the new model
        __grid = Grid.new(9, 9, 0)

        // add player
        __grid[4, 4] = 1

        // add enemies
        __grid[0, 0] = 2
        __grid[5, 6] = 2
    }    

    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt
    }

    // The render method is called once per tick, right after update.
    static render() {
        // render grid
        Render.setColor(1, 1, 1)
        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var val = __grid[x,y]
                if (val == 0){
                     Render.circle(x * 10, y * 10, 5, 12)
                } else{
                    Render.disk(x * 10, y * 10, 5, 12)
                }
            }
        }
    }
}
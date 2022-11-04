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

class Turn {
    static none     { 0 }
    static player   { 1 }
    static enemy    { 2 }
    static dead     { 3 }
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
        __grid = Grid.new(9, 9, Type.none)
        __turn = Turn.player
        __level = 3
        __rand = Random.new()

        // add player
        __grid[4, 4] = Type.player
        spawnEnemies()
    }

    static spawnEnemies(){
        var count = 0
        while(count < __level ){
            var x = __rand.int(0, __grid.width)
            var y = __rand.int(0, __grid.height)

            if (__grid[x,y] == Type.none){
                __grid[x,y] = Type.enemy
                count = count + 1
            }
        }
    }

    
    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt

        if (__turn == Turn.player){
            playerTurn()
        } else if (__turn == Turn.enemy){
            enemyTurn()
        }
    }

    static playerTurn(){
        var player = null
        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var val = __grid[x,y]
                if (val == Type.player){
                    player = Vec2.new(x,y)
                }
            }
        }

        if (!player){
            __turn = Turn.dead
            return
        }

        var direction = getDirection()
        if (direction != Vec2.new(0, 0)){
            moveDirection(player, direction)
            __turn = Turn.enemy
        }
    }

    static enemyTurn(){
        __turn = Turn.player
        var playerPos = null
        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var player = __grid[x,y]
                if (player == Type.player){
                    playerPos = Vec2.new(x,y)
                }
            }
        }

        if (!playerPos){
            __turn = Turn.dead
            return
        }

        var enemies = List.new()
        for (x in 0...__grid.width){
            for (y in 0...__grid.height){
                var enemy = __grid[x,y]
                if (enemy == Type.enemy){
                    var enemyPos = Vec2.new(x,y)
                    enemies.add(enemyPos)
                }
            }
        }

        if (enemies.count == 0){
            __level = __level + 1
            __turn = Turn.player
            spawnEnemies()
            return
        }

        for (ePos in enemies){
            var dir = playerPos - ePos
            dir = manhattanize(dir)
            moveDirection(ePos, dir)
        }
        
    }

    static manhattanize(dir){
        if (dir.x.abs > dir.y.abs){
            return Vec2.new(dir.x.sign, 0)
        } else{
            return Vec2.new(0, dir.y.sign)
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
        to.x = to.x % __grid.width
        to.y = to.y % __grid.height
        if (__grid[to.x, to.y] != Type.none){
            __grid[to.x, to.y] = Type.none
          
        }

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
        
        if (__turn == Turn.dead){
            Render.setColor(0xFFFFFFFF)
            Render.shapeText("You dead", -20, -100, 1)
        }
    }
}
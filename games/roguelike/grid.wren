class Grid {
    construct new(w, h, z){
        _width = w
        _height = h
        _grid = List.new()

        for(i in 0..(w * h)){
            _grid.add(z)
        }
    }

    [x,y]=(val){
        _grid[y * _width + x] = val
    }

    [x,y] { _grid[y * _width + x] }

    width {_width}
    height {_height}
}
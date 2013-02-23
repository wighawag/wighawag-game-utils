package com.wighawag.view.tile;

import com.wighawag.system.EntityComponent;

class LayerComponent implements EntityComponent{

    public var layer(default, null) : Int;

    public function new(layer : Int) {
        this.layer = layer;
    }

    public function initialise():Void{

    }
    
}

/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view.tile;

import wighawag.system.EntityComponent;

class LayerComponent implements EntityComponent{

    public var layer(default, null) : Int;

    public function new(layer : Int) {
        this.layer = layer;
    }

    public function initialise():Void{

    }
    
}

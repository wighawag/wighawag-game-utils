package com.wighawag.core;

import com.wighawag.tile.ObjectLayer.ObjectPlacement;
import com.wighawag.system.EntityComponent;

class OriginalPlacement  implements EntityComponent{

    public var objectPlacement : ObjectPlacement;

    public function new(objectPlacement : ObjectPlacement) {
        this.objectPlacement = objectPlacement;
    }


    public function initialise():Void{

    }

}

package com.wighawag.tile;

import com.wighawag.tile.MapLayer.LayerType;
import com.wighawag.system.EntityType;
import msignal.Signal;

typedef ObjectPlacement = {
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  entityType : EntityType
};

class ObjectLayer implements MapLayer{

    public var type(default,null) : LayerType;

    public var objects(default,null): Array<ObjectPlacement>; // I wish we could have unmutable var in haxe
    public var onUpdated(default,null) : Signal0;
    public var onObjectAdded(default, null) : Signal1<ObjectPlacement>;

    public function new(objects: Array<ObjectPlacement>) {
        onUpdated = new Signal0();
        onObjectAdded = new Signal1();
        type  = LayerOfObjects;
        this.objects = objects;
    }

    public function removeObjectPlacement(objectPlacement : ObjectPlacement) : Void{
        //TODO improve performance:
        objects.remove(objectPlacement);
        onUpdated.dispatch();
    }

    public function addObjectPlacement(objectPlacement : ObjectPlacement) : Void{
        objects.push(objectPlacement);
        onUpdated.dispatch();
        onObjectAdded.dispatch(objectPlacement);
    }

}

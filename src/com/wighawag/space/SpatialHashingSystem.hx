package com.wighawag.space;

import nme.geom.Point;
import com.wighawag.system.Entity;
import com.wighawag.system.SystemComponent;
import com.wighawag.system.Updatable;

import com.wighawag.core.PlacementComponent;

@entities(["com.wighawag.core.PlacementComponent"])
class SpatialHashingSystem implements SystemComponent, implements Updatable{

    public function new() {
    }

    public function getEntityAt(x : Float, y : Float) : Array<Entity>{
        //TODO use spatial hashing
        var entities : Array<Entity> = new Array();
        for (entity in registeredEntities){
            var placementComponent = entity.get(PlacementComponent);
            if(placementComponent.contains(x,y)){
                entities.push(entity);
            }
        }
        return entities;
    }

    public function initialise():Void{

    }

    public function onEntityRegistered(entity:Entity):Void {
    }

    public function onEntityUnregistered(entity:Entity):Void {
    }

    public function update(dt:Float):Void {
        //TODO
//        for (entity in registeredEntities){
//            var placementComponent = entity.get(PlacementComponent);
//        }
    }


}

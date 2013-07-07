/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.space;

import flash.geom.Point;
import wighawag.system.Entity;
import wighawag.system.SystemComponent;
import wighawag.system.Updatable;

import wighawag.core.PlacementComponent;

@entities(["wighawag.core.PlacementComponent"])
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

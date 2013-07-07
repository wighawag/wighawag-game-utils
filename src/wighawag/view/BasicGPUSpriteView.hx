/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view;

import wighawag.core.PlacementComponent;
import wighawag.asset.spritesheet.Sprite;
using wighawag.view.GPUSpriteUtils;
import wighawag.asset.load.Batch;
import wighawag.view.EntityView;
import wighawag.core.StateComponent;
import wighawag.core.AssetComponent;


class BasicGPUSpriteView implements EntityView<TexturedQuadProgram>{


    @owner
    private var placementComponent : PlacementComponent;

    @entityType
    private var assetComponent : AssetComponent;

    @owner
    private var stateComponent : StateComponent;

    private var sprites : Batch<Sprite>;

    public function new(sprites : Batch<Sprite>) {
        this.sprites = sprites;
    }

    public function initialise():Void{

    }

    public function draw(context:TexturedQuadProgram):Void {
        var sprite = sprites.get(assetComponent.assetId);
        if (assetComponent.scale){
            sprite.drawScaled(context, stateComponent.state, stateComponent.elapsedTime, Std.int(placementComponent.x), Std.int(placementComponent.y), Std.int(placementComponent.width), Std.int(placementComponent.height));
        }else if (assetComponent.fillVertically && assetComponent.fillHorizontally){
            sprite.fill(context, stateComponent.state, stateComponent.elapsedTime, Std.int(placementComponent.x), Std.int(placementComponent.y), Std.int(placementComponent.width), Std.int(placementComponent.height));
        }else if (assetComponent.fillHorizontally){
            sprite.fillHorizontally(context, stateComponent.state, stateComponent.elapsedTime, Std.int(placementComponent.x), Std.int(placementComponent.y), Std.int(placementComponent.width));
        }else if (assetComponent.fillVertically){
            sprite.fillVertically(context, stateComponent.state, stateComponent.elapsedTime, Std.int(placementComponent.x), Std.int(placementComponent.y), Std.int(placementComponent.height));
        }else{
            sprite.draw(context, stateComponent.state, stateComponent.elapsedTime, Std.int(placementComponent.x), Std.int(placementComponent.y));
        }

    }


    public function match():Bool {
        return true;
    }

    public function onAssociated():Void {
    }


}

/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view.tile;

import wighawag.gpu.GPUContext;
import wighawag.system.Entity;
import wighawag.view.EntityView;
import wighawag.view.EntityViewFactory;
import wighawag.asset.spritesheet.Sprite;
import wighawag.asset.load.Batch;

class BasicLayeredViewFactory implements EntityViewFactory<TexturedQuadProgram>{

    private var layer : Int;
    private var sprites : Batch<Sprite>;

    public function new(sprites : Batch<Sprite>, layer : Int) {
        this.sprites = sprites;
        this.layer = layer;
    }


    public function get(entity:Entity):EntityView<TexturedQuadProgram> {
        var layerComponent = entity.get(LayerComponent);
        if (layerComponent == null || layer != layerComponent.layer){
            return null;
        }
        var view : EntityView<TexturedQuadProgram> = new BasicGPUSpriteView(sprites);

        var accessClass = view.attach(entity);
        if (accessClass != null){
            var success = view.attachEntity(entity);
            if (success && view.match()){
                view.onAssociated();
                return view;
            }
        }
        return null;
    }



}


/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view;

import wighawag.system.Entity;
import wighawag.view.EntityView;
import wighawag.view.EntityViewFactory;
import wighawag.asset.spritesheet.Sprite;
import wighawag.gpu.GPUContext;
import wighawag.asset.load.Batch;


class BasicGPUSpriteViewFactory implements EntityViewFactory<TexturedQuadProgram>{

    private var sprites : Batch<Sprite>;

    public function new(sprites : Batch<Sprite>) {
        this.sprites = sprites;
    }

    public function get(entity:Entity):EntityView<TexturedQuadProgram> {

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

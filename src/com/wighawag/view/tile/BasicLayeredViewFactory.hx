package com.wighawag.view.tile;

import com.wighawag.gpu.GPUContext;
import com.wighawag.system.Entity;
import com.wighawag.view.EntityView;
import com.wighawag.view.EntityViewFactory;
import com.wighawag.asset.spritesheet.Sprite;
import com.wighawag.asset.load.Batch;

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


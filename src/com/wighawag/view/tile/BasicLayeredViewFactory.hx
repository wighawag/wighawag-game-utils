package com.wighawag.view.tile;

import com.wighawag.system.Entity;
import com.wighawag.view.EntityView;
import com.wighawag.view.EntityViewFactory;
import com.wighawag.asset.spritesheet.Sprite;
import com.wighawag.asset.renderer.NMEDrawingContext;
import com.wighawag.asset.load.Batch;
import com.wighawag.view.sprite.BasicSpriteViewFactory;

class BasicLayeredViewFactory  extends BasicSpriteViewFactory{

    private var layer : Int;

    public function new(sprites : Batch<Sprite>, layer : Int) {
        super(sprites);
        this.layer = layer;
    }

    override  public function get(entity:Entity):EntityView<NMEDrawingContext> {
        var layerComponent = entity.get(LayerComponent);
        if (layerComponent == null || layer != layerComponent.layer){
            return null;
        }
       return super.get(entity);
    }
    
}

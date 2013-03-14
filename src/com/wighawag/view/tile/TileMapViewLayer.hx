package com.wighawag.view.tile;
import com.wighawag.gpu.GPUContext;
import com.wighawag.tile.ObjectLayer;
import com.wighawag.tile.TileLayer;
import com.wighawag.tile.Tile;
import com.wighawag.tile.TileMap;
import com.wighawag.view.ViewLayer;
import com.wighawag.asset.spritesheet.Sprite;
import com.wighawag.asset.load.Batch;
import com.wighawag.asset.load.BitmapAsset;
using com.wighawag.asset.spritesheet.SpriteUtils;

import com.wighawag.system.Model;



// TODO : investigate another way of having model and tilemap working together
// As of now the model is needed as entity are added to it but their type and original placement come from the tileMap
// The tileMap also define the order at which they should be drawn
// An EntityPopulator or similar is needed to add the entity in the model and they have to have a LayerComponent with teh specific layer
class TileMapViewLayer implements ViewLayer<GPUContext>{

    private var tileMap : TileMap;
    private var layerViews : Array<ViewLayer<GPUContext>>;
    private var sprites : Batch<Sprite>;
    private var model : Model;
    private var camera : Camera2D;

    public function new(tilemap : TileMap, model : Model, sprites : Batch<Sprite>, camera : Camera2D) {
        this.model = model;
        this.sprites = sprites;
        this.tileMap = tilemap;
        this.camera = camera;
        onTileMapUpdated();
        tileMap.onUpdated.add(onTileMapUpdated);
    }

    private function onTileMapUpdated() : Void{
        layerViews = new Array();
        for (layerIndex in 0...tileMap.numOfLayers()){
            var layer = tileMap.getLayer(layerIndex);
            // TODO pass a factory to allow creation of specific views without having to repeat the code here
            switch(layer.type){
                case LayerOfTiles:
                    var tileLayer : TileLayer = cast(layer);
                    layerViews.push(new TileLayerView(tileLayer, sprites, camera));
                case LayerOfObjects:
                    var objectLayer : ObjectLayer = cast(layer);
                    layerViews.push(new GPUSpriteViewLayer(model,new BasicLayeredViewFactory(sprites, layerIndex), camera));
            }

        }
    }

    public function render(context:GPUContext):Void {
		for(layerView in layerViews){
            layerView.render(context);
        }
    }


}

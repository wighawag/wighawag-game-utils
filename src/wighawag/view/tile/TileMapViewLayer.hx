/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view.tile;
import wighawag.tile.MapLayer;
import wighawag.gpu.GPUContext;
import wighawag.tile.ObjectLayer;
import wighawag.tile.TileLayer;
import wighawag.tile.Tile;
import wighawag.tile.TileMap;
import wighawag.view.ViewLayer;
import wighawag.asset.spritesheet.Sprite;
import wighawag.asset.load.Batch;
import wighawag.asset.load.BitmapAsset;
using wighawag.asset.spritesheet.SpriteUtils;

import wighawag.system.Model;



// TODO : investigate another way of having model and tilemap working together
// As of now the model is needed as entity are added to it but their type and original placement come from the tileMap
// The tileMap also define the order at which they should be drawn
// An EntityPopulator or similar is needed to add the entity in the model and they have to have a LayerComponent with teh specific layer
class TileMapViewLayer implements ViewLayer<GPUContext>{

    private var tileMap : TileMap;
    private var layerViews : Array<ViewLayer<GPUContext>>;
    private var sprites : Batch<Sprite>;
    private var camera : Camera2D;
    private var model : Model;

    public function new(tilemap : TileMap, model : Model, sprites : Batch<Sprite>, camera : Camera2D) {
        this.sprites = sprites;
        this.tileMap = tilemap;
        this.camera = camera;
        this.model = model;
        this.layerViews = new Array();
        for (layerIndex in 0...tileMap.numOfLayers()){
            var layer = tileMap.getLayer(layerIndex);
            onLayerAdded(layer);
        }
        tileMap.onLayerAdded.add(onLayerAdded);
        tileMap.onLayerRemoved.add(onLayerRemoved);
    }

    private function onLayerAdded(layer : MapLayer) : Void{
        // TODO pass a factory to allow creation of specific views without having to repeat the code here
        switch(layer.type){
            case LayerOfTiles:
                var tileLayer : TileLayer = cast(layer);
                layerViews.push(new TileLayerView(tileLayer, sprites, camera));
            case LayerOfObjects:
                var objectLayer : ObjectLayer = cast(layer);
                layerViews.push(new GPUSpriteViewLayer(objectLayer, model,new BasicLayeredViewFactory(sprites, layerViews.length), camera));
        }

    }

    private function onLayerRemoved(layer : MapLayer) : Void{
        //TODO improve performance ?
        for(layerView in layerViews){
            if(Std.is(layerView,TileLayerView)){
                var tileLayerView : TileLayerView = cast(layerView);
                if(tileLayerView.layer == layer){
                    tileLayerView.dispose();
                    layerViews.remove(tileLayerView);
                    return;
                }
            }else if(Std.is(layerView,GPUSpriteViewLayer)){
                var gpuSpriteViewLayer : GPUSpriteViewLayer = cast(layerView);
                if(gpuSpriteViewLayer.layer == layer){
                    gpuSpriteViewLayer.dispose();
                    layerViews.remove(gpuSpriteViewLayer);
                    return;
                }
            }
        }
        Report.anError("TileMapViewLayer", "the layer was not found in the list of layer views :", layer);
    }




    public function render(context:GPUContext):Void {
		for(layerView in layerViews){
            layerView.render(context);
        }
    }

    public function dispose() : Void{
        tileMap.onLayerAdded.remove(onLayerAdded);
        tileMap.onLayerRemoved.remove(onLayerRemoved);
        tileMap = null;
        for (layerView in layerViews){
            layerView.dispose();
        }
        layerViews = null;
        sprites = null;
        camera = null;
        model = null;
    }


}

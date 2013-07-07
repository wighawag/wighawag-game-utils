/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view.tile;

import haxe.Timer;
import wighawag.gpu.GPUContext;
import wighawag.tile.TileLayer;
import wighawag.tile.Tile;
import wighawag.tile.TileMap;
import wighawag.view.ViewLayer;
import wighawag.asset.spritesheet.Sprite;
import wighawag.asset.load.Batch;
import wighawag.asset.load.BitmapAsset;
using wighawag.view.GPUSpriteUtils;
import wighawag.asset.renderer.TilesheetDrawingContext;

class TileLayerView implements ViewLayer<GPUContext>{

    public var layer : TileLayer;
    private var sprites : Batch<Sprite>;

    private var program : TexturedQuadProgram;
    private var camera : Camera2D;

    private var dirty : Bool;

    public function new(layer : TileLayer, sprites : Batch<Sprite>, camera : Camera2D) {
        this.sprites = sprites;
        this.layer = layer;
        this.layer.onUpdated.add(onUpdated);
        this.camera = camera;
        program = new TexturedQuadProgram(camera);
    }

    private function onUpdated() : Void{
        dirty = true;
    }

    public function render(context:GPUContext):Void {
        context.addProgram(program);
        if(dirty || program.dataRequired){
            //var before = Timer.stamp();

            program.reset();

            for(tileKey in layer.tiles.keys()){
                var tile = layer.tiles.get(tileKey);
                var x = TileLayer.x(tileKey)* layer.tileWidth;
                var y = TileLayer.y(tileKey)* layer.tileHeight;
                var sprite = sprites.get(tile.spriteId);

                //Report.anInfo("TileLayerView", "adding sprite ", sprite.id, sprite.getFrame("default", 0).texture.bitmapAsset.id);
                sprite.draw(program,"default", 0, x, y);

            }
            program.upload();
            //var after = Timer.stamp();
            //var delta = after - before;
            //Report.anInfo("TileLayerView", "verteices upload " + delta);
            dirty = false;
        }
    }

    public function dispose() : Void{
        this.layer.onUpdated.remove(onUpdated);
        layer = null;
        sprites = null;
        program.dispose();
        program = null;
        camera = null;
    }

}

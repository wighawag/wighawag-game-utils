package com.wighawag.view.tile;

import com.wighawag.gpu.GPUContext;
import com.wighawag.tile.TileLayer;
import com.wighawag.tile.Tile;
import com.wighawag.tile.TileMap;
import com.wighawag.view.ViewLayer;
import com.wighawag.asset.spritesheet.Sprite;
import com.wighawag.asset.load.Batch;
import com.wighawag.asset.load.BitmapAsset;
using com.wighawag.view.GPUSpriteUtils;
import com.wighawag.asset.renderer.TilesheetDrawingContext;

class TileLayerView implements ViewLayer<GPUContext>{

    private var layer : TileLayer;
    private var sprites : Batch<Sprite>;

    private var program : TexturedQuadProgram;
    private var camera : Camera2D;

    public function new(layer : TileLayer, sprites : Batch<Sprite>, camera : Camera2D) {
        this.sprites = sprites;
        this.layer = layer;
        this.camera = camera;

    }

    public function render(context:GPUContext):Void {
        if(program == null){
            program = new TexturedQuadProgram(camera);
            context.addProgram(program);
            program.reset();

            for(tileKey in layer.tiles.keys()){
                var tile = layer.tiles.get(tileKey);
                var x = TileLayer.x(tileKey)* layer.tileWidth;
                var y = TileLayer.y(tileKey)* layer.tileHeight;
                var sprite = sprites.get(tile.spriteId);


                sprite.draw(program,"default", 0, x, y);

            }

        }else{
            context.addProgram(program);
        }


    }


    
}

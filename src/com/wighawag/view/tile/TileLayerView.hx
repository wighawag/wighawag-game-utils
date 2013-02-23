package com.wighawag.view.tile;

import com.wighawag.tile.TileLayer;
import com.wighawag.tile.Tile;
import com.wighawag.tile.TileMap;
import com.wighawag.view.ViewLayer;
import com.wighawag.asset.renderer.NMEDrawingContext;
import com.wighawag.asset.spritesheet.Sprite;
import com.wighawag.asset.load.Batch;
import com.wighawag.asset.load.BitmapAsset;
using com.wighawag.asset.spritesheet.SpriteUtils;
import com.wighawag.asset.renderer.TilesheetDrawingContext;

class TileLayerView implements ViewLayer<NMEDrawingContext>{

    private var layer : TileLayer;
    private var sprites : Batch<Sprite>;

    private var tileBatch : Array<Float>;
    private var batchBitmap : BitmapAsset;

    public function new(layer : TileLayer, sprites : Batch<Sprite>) {
        this.sprites = sprites;
        this.layer = layer;
    }

    public function render(context:NMEDrawingContext):Void {
        if(!Std.is(context, TilesheetDrawingContext)){
            var startX = Std.int(-context.xTranslation / context.scaleX / layer.tileWidth);
            var startY = Std.int(-context.yTranslation / context.scaleY / layer.tileHeight);
            var endX = Std.int((nme.Lib.current.stage.stageWidth- context.xTranslation) / context.scaleX / layer.tileWidth);
            var endY = Std.int((nme.Lib.current.stage.stageHeight -context.yTranslation) / context.scaleY / layer.tileHeight);
            for(x in startX...endX + 1){
                for(y in startY...endY + 1){
                    var tile = layer.getTile(x,y);
                    if(tile != null){
                        var screenX = x * layer.tileWidth;
                        var screenY = y * layer.tileHeight;
                        var sprite = sprites.get(tile.spriteId);
                        // TODO implement states  later and elapsedTime?
                        sprite.draw(context, "default", 0, screenX , screenY);
                    }
                }
            }
//            for(tileKey in layer.tiles.keys()){
//                var tile = layer.tiles.get(tileKey);
//
//                var x = TileLayer.x(tileKey)* layer.tileWidth;
//                var y = TileLayer.y(tileKey)* layer.tileHeight;
//                if (x + layer.tileWidth >= - context.xTranslation && x  <= context.width - context.xTranslation && y + layer.tileHeight >= - context.yTranslation && y  <= context.height - context.yTranslation ){
//                    var sprite = sprites.get(tile.spriteId);
//                    // TODO implement states  later and elapsedTime?
//                    sprite.draw(context, "default", 0, x , y);
//                }
//            }
        }else{
            var tilesheetContext : TilesheetDrawingContext = cast(context);
            if(tileBatch == null){
                var values = new Array<Float>();
                var sprite : Sprite;
                for(tileKey in layer.tiles.keys()){
                    var tile = layer.tiles.get(tileKey);
                    var x = TileLayer.x(tileKey)* layer.tileWidth;
                    var y = TileLayer.y(tileKey)* layer.tileHeight;
                    sprite = sprites.get(tile.spriteId);

                    var frame = sprite.getFrame("default", 0);
                    var texture = frame.texture;

                    var scaleX = 1;
                    var scaleY = 1;

                    values.push(texture.x);
                    values.push(texture.y);
                    values.push(texture.width);
                    values.push(texture.height);

                    values.push(Std.int(x - (frame.x + texture.frameX) * scaleX));
                    values.push(Std.int(y - (frame.y + texture.frameY) * scaleY));
                    values.push(scaleX);
                    values.push(scaleY);

                }
                batchBitmap = sprite.bitmapAsset;   // last sprite (Need all to have the same bitmap)
                tileBatch = tilesheetContext.registerBatch(batchBitmap,values);
            }
            tilesheetContext.renderBatch(batchBitmap, tileBatch);
        }

    }


    
}

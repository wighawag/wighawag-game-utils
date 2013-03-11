package com.wighawag.view;

import com.wighawag.asset.spritesheet.Sprite;

class GPUSpriteUtils {

    inline static public function draw(sprite : Sprite, context : TexturedQuadProgram, animationName : String, elapsedTime : Float, x : Int, y : Int) : Void{
        var frame = sprite.getFrame(animationName,elapsedTime);
        var texture = frame.texture;
        var targetX = Std.int(x - (frame.x + texture.frameX) + (frame.flipX == -1 ? texture.width : 0));
        var targetY = Std.int(y - (frame.y + texture.frameY) + (frame.flipY == -1 ? texture.height : 0));
        context.draw(
            texture.bitmapAsset.id,
            texture.x,
            texture.y,
            texture.width,
            texture.height,
            targetX,
            targetY,
            targetX + texture.width * frame.flipX,
            targetY + texture.height * frame.flipY
        );
    }

    inline static public function drawScaled(sprite : Sprite, context : TexturedQuadProgram, animationName : String, elapsedTime : Float, x : Int, y : Int, width : Int, height : Int) : Void{
        var frame = sprite.getFrame(animationName, elapsedTime);
        var texture = frame.texture;

        var scaleX : Float = width / texture.width;
        var scaleY : Float = height / texture.height;

        var targetX = Std.int(x - (frame.x + texture.frameX) * scaleX + (frame.flipX == -1 ? width : 0));
        var targetY = Std.int(y - (frame.y + texture.frameY) * scaleY + (frame.flipY == -1 ? height : 0));
        context.draw(
            texture.bitmapAsset.id,
            texture.x,
            texture.y,
            texture.width,
            texture.height,
            targetX,
            targetY,
            targetX + width * frame.flipX,
            targetY + height * frame.flipY
        );
    }

    inline static public function fill(sprite : Sprite, context : TexturedQuadProgram, animationName : String, elapsedTime : Float, x : Int, y : Int, width : Int, height : Int) : Void{
        var frame = sprite.getFrame(animationName,elapsedTime);
        var texture = frame.texture;

        var totalWidth = 0;
        var totalHeight = 0;
        var maxWidth = width;
        var maxHeight = height;
        while(totalHeight < maxHeight){
            totalWidth = 0;
            while(totalWidth < maxWidth){
                var targetX = x + totalWidth - frame.x - texture.frameX;
                var targetY = y + totalHeight - frame.y - texture.frameY;
                context.draw(
                    texture.bitmapAsset.id,
                    texture.x,
                    texture.y,
                    texture.width,
                    texture.height,
                    targetX,
                    targetY,
                    targetX + texture.width,
                    targetY + texture.height
                );
                totalWidth += texture.width;
            }
            totalHeight += texture.height   ;
        }
    }

    inline static public function fillHorizontally(sprite : Sprite, context : TexturedQuadProgram, animationName : String, elapsedTime : Float, x : Int, y : Int, width : Int) : Void{
// TODO
    }

    inline static public function fillVertically(sprite : Sprite, context : TexturedQuadProgram, animationName : String, elapsedTime : Float, x : Int, y : Int, height : Int) : Void{
// TODO
    }


}

/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view;

import wighawag.asset.spritesheet.Sprite;

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

        var scaleX : Float = width / texture.frameWidth;
        var scaleY : Float = height / texture.frameHeight;

        var offsetX = frame.x + texture.frameX;
        if(frame.flipX == -1){
            offsetX = texture.frameWidth - texture.width + texture.frameX + frame.x;
        }
        var offsetY = frame.y + texture.frameY;
        if(frame.flipY == -1){
            offsetY = texture.frameHeight - texture.height + texture.frameY + frame.y;
        }


        var targetX = Std.int(x - (offsetX * scaleX) * scaleX + (frame.flipX == -1 ? texture.width * scaleX : 0));
        var targetY = Std.int(y - (offsetY * scaleY) * scaleY + (frame.flipY == -1 ? texture.height * scaleY : 0));
        context.draw(
            texture.bitmapAsset.id,
            texture.x,
            texture.y,
            texture.width,
            texture.height,
            targetX,
            targetY,
            targetX + texture.width * scaleX * frame.flipX,
            targetY + texture.height * scaleY * frame.flipY
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

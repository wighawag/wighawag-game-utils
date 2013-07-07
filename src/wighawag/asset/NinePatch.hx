/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset;
import flash.display.BitmapData;
import wighawag.asset.load.BitmapAsset;
import wighawag.asset.spritesheet.SubTexture;
import wighawag.asset.load.AssetManager;
import wighawag.asset.load.Asset;

typedef Range = {start : Int, end : Int};

class NinePatch implements Asset {

    public var id(default, null) : AssetId;

    public var leftRightTopDownOrderedPatches : Array<Array<Patch>>;
    public var scalableWidth : Int;
    public var fixedWidth : Int;

    public var scalableHeight : Int;
    public var fixedHeight : Int;

    public var contentXOffset : Int;
    public var contentYOffset : Int;
    public var nonContentWidth : Int;
    public var nonContentHeight : Int;

    public var bitmapAsset : BitmapAsset;

    public function new(id : AssetId, subTexture : SubTexture) {
        this.id = id;
        this.bitmapAsset = subTexture.bitmapAsset;

        leftRightTopDownOrderedPatches = new Array();
        //compute the ninePatch:
        var bitmapData : BitmapData = bitmapAsset.bitmapData;


        var horizontalRanges : Array<Range> = new Array();
        var currentlyScaling : Bool =  bitmapData.getPixel32(subTexture.x + 1, subTexture.y + 0) != 0;
        var beginWithHorizontalScale : Bool = currentlyScaling;
        var x = subTexture.x + 1;

        //vertical scale
        for (i in subTexture.x + 2... subTexture.x + subTexture.width - 1){
            var pixel = bitmapData.getPixel32(i, subTexture.y + 0);
            if (pixel == 0 && currentlyScaling){
                currentlyScaling = false;
                horizontalRanges.push({start:x, end:i});
                x = i;
            }else if (pixel != 0 && !currentlyScaling){
                currentlyScaling = true;
                horizontalRanges.push({start:x, end:i});
                x = i;
            }
        }
        horizontalRanges.push({start:x, end:subTexture.x + subTexture.width - 1});


        var verticalRanges : Array<Range> = new Array();
        var y = subTexture.y + 1;
        currentlyScaling =  bitmapData.getPixel32(subTexture.x + 0 ,subTexture.y + 1) != 0;
        var beginWithVerticalScale : Bool = currentlyScaling;
        for (i in subTexture.y + 2...subTexture.y + subTexture.height - 1){
            var pixel = bitmapData.getPixel32(subTexture.x + 0,i);
            if (pixel == 0 && currentlyScaling){
                currentlyScaling = false;
                verticalRanges.push({start:y, end:i});
                y = i;
            }else if (pixel != 0 && !currentlyScaling){
                currentlyScaling = true;
                verticalRanges.push({start:y, end:i});
                y = i;
            }
        }
        verticalRanges.push({start:y, end:subTexture.y + subTexture.height - 1});

        var scaleHorizontally = beginWithHorizontalScale;
        var scaleVertically = beginWithVerticalScale;

        var scalableWidthComputed : Bool = false;
        for (vRange in verticalRanges){
            var row = new Array<Patch>();
            for (hRange in horizontalRanges){
                row.push(new Patch(hRange.start, vRange.start, hRange.end - hRange.start, vRange.end - vRange.start, scaleHorizontally, scaleVertically));
                if (!scalableWidthComputed){
                    if(scaleHorizontally){
                        scalableWidth += (hRange.end - hRange.start);
                    }else{
                        fixedWidth += (hRange.end - hRange.start);
                    }
                }

                scaleHorizontally = !scaleHorizontally;
            }
            leftRightTopDownOrderedPatches.push(row);
            scalableWidthComputed = true;
            if(scaleVertically){
                scalableHeight += (vRange.end - vRange.start);
            }else{
                fixedHeight += (vRange.end - vRange.start);
            }
            scaleHorizontally = beginWithHorizontalScale;
            scaleVertically = !scaleVertically;
        }


        // DEAL with content space
        var contentStartX : Int = -1;
        var contentEndX : Int = subTexture.x + subTexture.width;
        var contentRow = subTexture.y + subTexture.height -1;
        for (i in subTexture.x... subTexture.x + subTexture.width - 1){
            var pixel = bitmapData.getPixel32(i, contentRow);
            if (pixel != 0)
            {
                contentEndX = -1;
                if (contentStartX == -1){
                    contentStartX = i;
                }
            }else if(contentEndX == -1){
                contentEndX = i;
            }
        }

        if (contentStartX != -1 && contentEndX == -1){
            contentEndX = subTexture.x + subTexture.width;
        }


        var contentStartY : Int = -1;
        var contentEndY : Int = subTexture.y + subTexture.height;
        var contentColumn = subTexture.x + subTexture.width -1;
        for (i in subTexture.y... subTexture.y + subTexture.height - 1){
            var pixel = bitmapData.getPixel32(contentColumn, i);
            if (pixel != 0){
                contentEndY = -1;
                if(contentStartY == -1){
                    contentStartY = i;
                }
            }else if(contentEndY == -1){
                contentEndY = i;
            }
        }

        if (contentStartY != -1 && contentEndY == -1){
            contentEndY = subTexture.y + subTexture.height;
        }



        nonContentWidth = (fixedWidth + scalableWidth) - (contentEndX - contentStartX);
        nonContentHeight = (fixedHeight + scalableHeight) - (contentEndY - contentStartY);
        contentXOffset = contentStartX - subTexture.x;
        contentYOffset = contentStartY  - subTexture.y;

    }
}


class Patch{

    public var x(default, null) : Int;
    public var y(default, null) : Int;
    public var width(default, null) : Int;
    public var height(default, null) : Int;

    public var scaleVertically(default, null) : Bool;
    public var scaleHorizontally(default, null) : Bool;

    public function new(x : Int, y : Int, width : Int, height : Int, scaleHorizontally : Bool, scaleVertically  : Bool){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.scaleVertically = scaleVertically;
        this.scaleHorizontally = scaleHorizontally;
    }
}


package com.wighawag.asset.font;
import de.polygonal.ds.IntHashTable;
import com.wighawag.asset.load.AssetManager;
import com.wighawag.asset.load.BitmapAsset;
import com.wighawag.asset.load.Asset;
import com.wighawag.asset.spritesheet.TextureAtlas;
class FontFace implements Asset {

    public var id : AssetId;
    private var glyphHash : IntHashTable<Glyph>;
    public var textureAtlas : TextureAtlas;

    /**
     * This is the distance in pixels between each line of text.
    **/
    public var lineHeight : Int;

    /**
     * The number of pixels from the absolute top of the line to the base of the characters.
    **/
    public var base : Int;

    public function new(id : AssetId, textureAtlas : TextureAtlas, glyphs : Array<Glyph>, lineHeight : Int, base : Int) {
        this.id = id;
        this.textureAtlas = textureAtlas;
        this.lineHeight = lineHeight;
        this.base = base;

        // TODO fix polyginal ds as if the number is too small, it crash (segmentation fault)
        this.glyphHash = new IntHashTable(512); // TODO optimal size?

        for (glyph in glyphs){
            glyphHash.set(glyph.id, glyph);
        }

    }

    public function get(id : Int) : Glyph{
        return glyphHash.get(id);
    }

    public function widthOf(text : String) : Int {
        var width = 0;
        for (i in 0...text.length){
            var glyphId = text.charCodeAt(i);
            var glyph = get(glyphId);
            width += Std.int(glyph.xAdvance);
        }
        return width;
    }

    public function heightOf(text : String) : Int {
        return lineHeight;
    }
}

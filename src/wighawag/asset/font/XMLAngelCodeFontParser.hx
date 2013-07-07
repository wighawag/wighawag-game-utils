/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset.font;
import wighawag.asset.load.BitmapAsset;
import wighawag.asset.spritesheet.TextureAtlas;
import wighawag.asset.spritesheet.SubTexture;
class XMLAngelCodeFontParser {

    private var xml : String;
    private var bitmapAsset : BitmapAsset;
    private var fontFaceId : String;

    //TODO : support binary format
    public function new(fontFaceId : String, bitmapAsset : BitmapAsset, xml : String) {
        this.xml = xml;
        this.bitmapAsset = bitmapAsset;
        this.fontFaceId = fontFaceId;
    }

    public function parse() : FontFace{

        var x = new haxe.xml.Fast( Xml.parse(xml).firstElement() );

        var fontFaceName : String = x.node.info.att.face;
        var lineHeight : Int = Std.parseInt(x.node.common.att.lineHeight);
        var base : Int = Std.parseInt(x.node.common.att.base);

        var glyphs : Array<Glyph> = new Array();
        var textures : Hash<SubTexture> = new Hash();

        for (char in x.node.chars.nodes.char){

            var id = Std.parseInt(char.att.id);

            var x = Std.parseInt(char.att.x);
            var y =Std.parseInt(char.att.y);
            var width = Std.parseInt(char.att.width);
            var height = Std.parseInt(char.att.height);

            var xOffset = Std.parseInt(char.att.xoffset);
            var yOffset = Std.parseInt(char.att.yoffset);

            var xAdvance = Std.parseInt(char.att.xadvance);

            // TODO :
            //page : No plan to support
            //chnl : not sure yet how it works


            // TODO xOffset/yOffset might be equivalent to frameX, frameY ?
            var subTexture = new SubTexture("glyph" + id, bitmapAsset,x,y,width,height, 0, 0, width, height);
            textures.set("glyph" + id, subTexture);
            glyphs.push(new Glyph(id, subTexture , xOffset, yOffset, xAdvance));
        }

        //TODO FIX : start to be confusing with same ids and Glyph/SubTexture FontFace/TextureAtlas sameness
        var textureAtlas = new TextureAtlas(fontFaceId, bitmapAsset, textures);

        // TODO specify boldness italic, charset, ....
        var fontFace = new FontFace(fontFaceId, textureAtlas, glyphs, lineHeight, base);

        return fontFace;
    }
}

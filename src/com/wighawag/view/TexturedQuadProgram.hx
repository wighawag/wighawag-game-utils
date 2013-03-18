package com.wighawag.view;

import nme.display3D.textures.Texture;
import nme.utils.ByteArray;
import nme.utils.ByteArray;
import nme.utils.Endian;

import nme.geom.Matrix3D;
import nme.display3D.Context3D;


import nme.display3D.IndexBuffer3D;
import nme.display3D.VertexBuffer3D;
import nme.display3D.shaders.glsl.GLSLProgram;
import nme.display3D.shaders.glsl.GLSLVertexShader;
import nme.display3D.shaders.glsl.GLSLFragmentShader;

import com.wighawag.gpu.GPUProgram;
import com.wighawag.gpu.TextureBatch;
import com.wighawag.gpu.TextureData;

class TexturedQuadProgram implements GPUProgram{

	public var batches : Hash<TextureBatch>;

	private var glslProgram : GLSLProgram;

	private var context3D : Context3D;
	private var availableTextures : Array<TextureData>;

    private var camera : Camera2D;

    private var drawBatches : Array<Batch>;

    public var dataRequired : Bool;

    public function new(camera : Camera2D) {
	    batches = new Hash();
        availableTextures = new Array();
        this.camera = camera;
    }

	public function setContext(context3D : Context3D) : Void{
		if(this.context3D != context3D){
			this.context3D = context3D;
            dataRequired = true;


            var vertShader =
            "attribute vec2 position;" +
            "attribute vec2 uv;" +
            "attribute float alpha;" +
            "uniform mat4 proj;" +
            "varying vec2 vTexCoord;" +
            "varying float vAlpha;" +
            "void main() {" +
            " gl_Position = proj * vec4(position, 0.0, 1.0);" +
            " vTexCoord = uv;" +
            " vAlpha = alpha;" +
            "}";

        var vertexAgalInfo = '{"varnames":{"uv":"va1","proj":"vc0","alpha":"va2","position":"va0"},"agalasm":"m44 op, va0, vc0\\nmov v0, va1\\nmov v1, va2","storage":{},"types":{},"info":"","consts":{}}';


        var fragShader = // - not on desktop ? 'precision mediump float;' +
            "varying vec2 vTexCoord;" +
            "varying float vAlpha;" +
            "uniform sampler2D texture;" +
            "void main() {" +
            "vec4 texColor = texture2D(texture, vTexCoord);" +
            "float blendAlpha = vAlpha * texColor.w;" +
            "texColor.w = blendAlpha;" +
            "gl_FragColor = texColor;"+
            "}";

            var fragmentAgalInfo = '{"varnames":{"texture":"fs0"},"agalasm":"mov ft0, v0\\ntex ft1, ft0, fs0 <2d,clamp,linear>\\nmul ft1.w v1.x ft1.w\\nmov oc, ft1","storage":{},"types":{},"info":"","consts":{}}';

            glslProgram = new GLSLProgram(context3D);
            glslProgram.upload(new GLSLVertexShader(vertShader, vertexAgalInfo),new GLSLFragmentShader(fragShader, fragmentAgalInfo));


		}
	}

	public function setAvailableTextures(availableTextures : Array<TextureData>) : Void{
		if(this.availableTextures !=availableTextures){
			this.availableTextures = availableTextures;
            dataRequired = true;
            batches = new Hash();
			for (texture in availableTextures){
				var byteArrays : Array<ByteArray> = new Array();
				var ba = new ByteArray();
				ba.endian = Endian.LITTLE_ENDIAN;
				byteArrays.push(ba);
				var ba = new ByteArray();
				ba.endian = Endian.LITTLE_ENDIAN;
				byteArrays.push(ba);
				batches.set(texture.id, new TextureBatch(texture.id, byteArrays, texture));
			}
		}

	}

	public function reset() : Void{
		// reset bytearrays (at least the position)
        dataRequired = true;
		for(textureBatch in batches){
			textureBatch.byteArrays[0].position =0;
			textureBatch.byteArrays[1].position =0;
		}

	}

    public function upload() : Void{
        drawBatches = new Array();
        for(texture in availableTextures){
            var textureBatch = batches.get(texture.id);

            if(textureBatch == null){
                Report.anError("TexturedQuadProgram", "error batch does not match available texture for " + texture.id);
                return;
            }

            //skip if nothing has been added to the byteArray
            if(textureBatch.byteArrays[0].position == 0){
                continue;
            }

            var dataPerVertex = 5;
            var indexByteArray = textureBatch.byteArrays[0];
            var numIndices = Std.int(indexByteArray.position / 2);
            var vertexByteArray = textureBatch.byteArrays[1];
            var numVertices = Std.int(vertexByteArray.position / (4 *dataPerVertex));


            // TODO might move it into initialization for optimization if possible (knowing how many things to draw)
            var vertexBuffer  = context3D.createVertexBuffer(numVertices, dataPerVertex);
            vertexBuffer.uploadFromByteArray(vertexByteArray, 0, 0, numVertices);
            var indexBuffer = context3D.createIndexBuffer(numIndices);
            indexBuffer.uploadFromByteArray(indexByteArray,0,0, numIndices);

            //Report.anInfo("TexturedQuadProgram", "adding batch for ", textureBatch.bitmapId);
            drawBatches.push(new Batch(texture.id, vertexBuffer, indexBuffer, textureBatch.textureData.texture, Std.int(numVertices /2)));

        }
        dataRequired = false;
    }




	public function execute() : Void{

        if(dataRequired){
            return;
        }

        context3D.setBlendFactors(nme.display3D.Context3DBlendFactor.SOURCE_ALPHA, nme.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);

		for(batch in drawBatches){
            batch.draw(context3D, glslProgram, camera.projectionMatrix);
		}

	}

	public function dispose() : Void{
        for (drawBatch in drawBatches){
            drawBatch.dispose();
        }
        drawBatches = null;
        glslProgram.dispose();
        glslProgram = null;
        batches = null;
        context3D = null;
        availableTextures = null;
        camera = null;
        dataRequired = true;
    }

    public function draw(bitmapAssetId : String, srcX : Int, srcY : Int, srcW : Int, srcH : Int, x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Void{

        var textureBatch = batches.get(bitmapAssetId);

        if(textureBatch == null){
            Report.anError("TexturedQuadProgram", "check whether bitmap asset " + bitmapAssetId  + " has been uploaded to gpu");
            return;
        }

        var indexByteArray = textureBatch.byteArrays[0]; //indices
        var vertexByteArray = textureBatch.byteArrays[1]; // vertices
        var textureData = textureBatch.textureData;

        var u1 = textureData.uRatio*srcX;
        var v1 = textureData.vRatio*srcY;


        var u2 = textureData.uRatio*(srcX + srcW);
        var v2 = textureData.vRatio*(srcY + srcH);


        var alpha = 1.0;//0.5;

        var vertexOffset : Int = Std.int(vertexByteArray.position / (4 * 5));

        x1 += deltaX;
        x2 += deltaX;
        y1 += deltaY;
        y2 += deltaY;

        vertexByteArray.writeFloat(x1);
        vertexByteArray.writeFloat(y1);
        vertexByteArray.writeFloat(u1);
        vertexByteArray.writeFloat(v1);
        vertexByteArray.writeFloat(alpha);

        vertexByteArray.writeFloat(x2);
        vertexByteArray.writeFloat(y1);
        vertexByteArray.writeFloat(u2);
        vertexByteArray.writeFloat(v1);
        vertexByteArray.writeFloat(alpha);

        vertexByteArray.writeFloat(x2);
        vertexByteArray.writeFloat(y2);
        vertexByteArray.writeFloat(u2);
        vertexByteArray.writeFloat(v2);
        vertexByteArray.writeFloat(alpha);

        vertexByteArray.writeFloat(x1);
        vertexByteArray.writeFloat(y2);
        vertexByteArray.writeFloat(u1);
        vertexByteArray.writeFloat(v2);
        vertexByteArray.writeFloat(alpha);


        indexByteArray.writeShort(vertexOffset + 0);
        indexByteArray.writeShort(vertexOffset + 1);
        indexByteArray.writeShort(vertexOffset + 2);
        indexByteArray.writeShort(vertexOffset + 2);
        indexByteArray.writeShort(vertexOffset + 3);
        indexByteArray.writeShort(vertexOffset + 0);

    }

    private var deltaX : Float = 0;
    private var deltaY : Float = 0;
    public function translate(deltaX : Float, deltaY : Float) : Void{
        this.deltaX += deltaX;
        this.deltaY += deltaY;
    }

}


class Batch{

    private var id : String;
    private var vertexBuffer : VertexBuffer3D;
    private var indexBuffer : IndexBuffer3D;
    private var texture : Texture;
    private var numTriangles : Int;

    public function new(id : String, vertexBuffer, indexBuffer, texture,numTriangles) {
        this.id = id;
        this.vertexBuffer = vertexBuffer;
        this.indexBuffer= indexBuffer;
        this.texture = texture;
        this.numTriangles = numTriangles;
    }

    public function draw(context3D : Context3D, glslProgram : GLSLProgram, projectionMatrix : Matrix3D) : Void{
        //var values : String = projectionMatrix.rawData.join(",");
        //Report.anInfo("Batch", "drawing batch for ", id, "triangles " + numTriangles + " (" + values + ")");
        glslProgram.attach();
        glslProgram.setVertexUniformFromMatrix("proj",projectionMatrix, true);
        glslProgram.setTextureAt("texture", texture);
        glslProgram.setVertexBufferAt("position",vertexBuffer, 0, nme.display3D.Context3DVertexBufferFormat.FLOAT_2);
        glslProgram.setVertexBufferAt("uv",vertexBuffer, 2, nme.display3D.Context3DVertexBufferFormat.FLOAT_2);
        glslProgram.setVertexBufferAt("alpha",vertexBuffer, 4, nme.display3D.Context3DVertexBufferFormat.FLOAT_1);

        context3D.drawTriangles(indexBuffer, 0, numTriangles);
    }

    public function dispose() : Void{
        vertexBuffer.dispose();
        vertexBuffer = null;
        indexBuffer.dispose();
        indexBuffer = null;
        texture = null;
    }


}





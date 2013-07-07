/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix3D;

import wighawag.gpu.GPURenderer;

using flash.Vector;

class Camera2D {

    public var projectionMatrix : Matrix3D;
    private var gpuRenderer : GPURenderer;
    private var requestedScreenResolution : Point;

    public var zoom(default,null) : Float;
    public var tx(default,null) : Float = 0;
    public var ty(default,null) : Float = 0;

    public var scale(default, null) : Float;
    public var width(default, null) : Float;
    public var height(default, null) : Float;


    public function new(gpuRenderer : GPURenderer, requestedScreenResolution : Point) {
        this.gpuRenderer = gpuRenderer;
        this.requestedScreenResolution = requestedScreenResolution;

        this.zoom = 1;
        onResize(gpuRenderer.width, gpuRenderer.height);
        gpuRenderer.onResize.add(onResize);
        computeViewPort();
    }

    private function onResize(width : Int, height : Int) : Void{
        Report.anInfo("Camera2D", "onResize", "(" + width + "," + height + ")");
        if(requestedScreenResolution == null){
            this.width = width;
            this.height = height;
        }

        computeMatrix();
    }

    public function setZoom(zoomValue : Float, ?onScreenX : Float = -1, ?onScreenY : Float = -1) : Void{
        if(zoom == zoomValue){
            return;
        }
        var centerX : Float;
        var centerY : Float;
        if(onScreenX > -1 && onScreenY > -1){
            centerX = getWorldX(onScreenX, onScreenY);
            centerY = getWorldY(onScreenX, onScreenY);
        }else{
            centerX = tx + width / 2;
            centerY = ty + height / 2;
        }


        zoom = zoomValue;

        computeViewPort();
        setCenter(centerX, centerY);
    }

    public function setFocus(area : Rectangle) : Void{
        var centerX = area.x + area.width /2;
        var centerY = area.y + area.height /2;

        if(requestedScreenResolution != null){
            requestedScreenResolution.x = area.width;
            requestedScreenResolution.y = area.height;
        }

        // by default center
        // TODO specify behavior via parameters
        setCenter(centerX, centerY);
        computeViewPort();
    }


    private function computeViewPort() : Void{
        var requestedWidth = width;
        var requestedHeight = height;
        if(requestedScreenResolution != null){
            requestedWidth = requestedScreenResolution.x;
            requestedHeight = requestedScreenResolution.y;
        }

        var zoomedWidth = requestedWidth / zoom;
        var zoomedHeight = requestedHeight / zoom;
        var scaleX =  gpuRenderer.width/ zoomedWidth;
        var scaleY =  gpuRenderer.height / zoomedHeight;

        if(scaleX > scaleY){
            scale = scaleY;
            height = zoomedHeight;
            width = zoomedWidth * scaleX / scaleY;

        }else{
            scale = scaleX;
            width = zoomedWidth;
            height = zoomedHeight * scaleY / scaleX;
        }
        computeMatrix();
    }

    private function computeMatrix() : Void{

        var actualScaleX = (2 / gpuRenderer.width) * scale;
        var actualScaleY = (2 / gpuRenderer.height) * scale;


        projectionMatrix = new Matrix3D(Vector.ofArray([
        actualScaleX, 0, 0, 0,
        0, - actualScaleY, 0, 0,
        0, 0, -1, 0,
        -1 - tx * actualScaleX,  1 +  ty  * actualScaleY, 0, 1
        ]));
    }

    public function setPosition(x : Float, y : Float) : Void{
        this.tx = x;
        this.ty = y;
        computeMatrix();
    }


    public function setCenter(x : Float, y : Float) : Void{
        setPosition(x - width / 2, y - height/2);
    }

    public function getWorldX(x : Float, y : Float) : Float{
        return x /scale + tx;
    }

    public function getWorldY(x : Float, y : Float) : Float{
        return y /scale + ty;
    }

}

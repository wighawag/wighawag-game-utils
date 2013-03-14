package com.wighawag.view;

import nme.geom.Rectangle;
import nme.geom.Matrix3D;

import com.wighawag.gpu.GPURenderer;

using nme.Vector;

class Camera2D {

    public var projectionMatrix : Matrix3D;
    private var gpuRenderer : GPURenderer;
    private var screenSpace : Rectangle;
    private var zoom : Float;
    private var x : Float = 0;
    private var y : Float = 0;

    public var scale(default, null) : Float;

    public function new(gpuRenderer : GPURenderer, screenSpace : Rectangle) {
        this.gpuRenderer = gpuRenderer;
        this.screenSpace = screenSpace;
        this.zoom = 1;
        onResize(gpuRenderer.width, gpuRenderer.height);
        gpuRenderer.onResize.add(onResize);
    }

    private function onResize(width : Int, height : Int) : Void{
        computeMatrix();
    }

    public function setZoom(zoomValue : Float) : Void{
        zoom = zoomValue;
        computeMatrix();
    }

    private function computeMatrix() : Void{
        // TODO consider the max/min of height and width
        if(screenSpace != null){
            scale = gpuRenderer.width / screenSpace.width * zoom;
        }else{
            scale = zoom;
        }



        projectionMatrix = new Matrix3D(Vector.ofArray([
        2/gpuRenderer.width * scale, 0, 0, x,
        0, -2/gpuRenderer.height * scale, 0, y,
        0, 0, -1, 0,
        -1, 1, 0, 1
        ]));
    }

    public function setPosition(x : Float, y : Float) : Void{
        this.x = x;
        this.y = y;
        computeMatrix();
    }




}

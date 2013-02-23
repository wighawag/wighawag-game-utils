package com.wighawag.tile;

import msignal.Signal;

enum LayerType{
    LayerOfTiles;
    LayerOfObjects;
}

interface MapLayer {
    public var type(default,null) : LayerType;
    public var onUpdated(default,null) : Signal0;
}

/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.tile;

import msignal.Signal;

enum LayerType{
    LayerOfTiles;
    LayerOfObjects;
}

interface MapLayer {
    public var type(default,null) : LayerType;
    public var onUpdated(default,null) : Signal0;
}

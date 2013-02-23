package com.wighawag.ui.view;

enum ScreenInputState{
    None;
    Hover;
    Up;
    Down;
}

interface ScreenInput {
    public var x : Int;
    public var y : Int;
    public var state : ScreenInputState;
    public var target : UIElementView;

    function preRender() : Void;
    function postRender() : Void;
}

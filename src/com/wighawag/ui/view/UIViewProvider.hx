package com.wighawag.ui.view;
interface UIViewProvider<UIAssetProvider, StyleSpec> {
    function createView(uiAssetProvider : UIAssetProvider, styleSpec : StyleSpec) : UIElementView;
}
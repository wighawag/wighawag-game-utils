/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;
interface UIViewProvider<UIAssetProvider, StyleSpec> {
    function createView(uiAssetProvider : UIAssetProvider, styleSpec : StyleSpec) : UIElementView;
}
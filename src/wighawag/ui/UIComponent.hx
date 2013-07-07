/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui;
import wighawag.ui.view.UIElementView;
import wighawag.ui.view.UIViewProvider;
import wighawag.ui.content.UIContent;
interface UIComponent<UIAssetProvider, ContentSpec,StyleSpec> extends UIContent<ContentSpec> extends UIViewProvider<UIAssetProvider,StyleSpec>{
}

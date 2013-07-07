/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.content;
import wighawag.ui.core.UIElement;

interface UIContent<ContentSpec> extends UIElement {
    function setId(id : String) : Void;
    function setContent(content : ContentSpec) : Void;
}

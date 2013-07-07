/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui;
import haxe.ds.StringMap;
import wighawag.ui.layout.LinearLayout;
import wighawag.ui.layout.VerticalLayout;
import haxe.Json;
import wighawag.ui.element.Button;
import wighawag.ui.layout.AbsoluteLayout;
import wighawag.ui.view.Layout;
import wighawag.ui.view.LayoutAlgorithm;
import wighawag.ui.core.UIElement;
import wighawag.ui.view.UIElementView;
import wighawag.ui.view.Container;
import wighawag.ui.view.LayoutChild;
import haxe.xml.Fast;
import wighawag.ui.core.UIActionElement;

using StringTools;

class BasicGenericUI<UIAssetProvider : BasicUIAssetProvider> {

    private var elements : StringMap<UIElement>;
    private var styles : StringMap<Dynamic>;

    public var root : UIElementView;

    private var uiAssetProvider : UIAssetProvider;

    public function new(layout : String, style : String, uiAssetProvider : UIAssetProvider) {
        VerticalLayout;
	    LinearLayout;
	    AbsoluteLayout;

        this.uiAssetProvider = uiAssetProvider;
        elements = new StringMap();

	    try{
		    styles = parseStyle(style);
	    }catch(e : Dynamic){
		    Report.anError("BasicGenericUI", "error while parsong style ", e);
	    }

	    try{
		    var layoutXml = new Fast(Xml.parse(layout).firstElement());
		    var rootChildLayout = parseElement(layoutXml, elements);
		    root = rootChildLayout.view;
	    }catch(e : Dynamic){
		    Report.anError("BasicGenericUI", "error while parsong layout ", e);
	    }
    }

    private function parseStyle(style : String) : StringMap<Dynamic>{
        var hash = new StringMap<Dynamic>();

        var data = Json.parse(style);

        for (key in Reflect.fields(data)) {
            var elementStyle = Reflect.field(data, key);
            var styleSpec = {};
            for (styleParam in Reflect.fields(elementStyle)) {
                var styleValue = Reflect.field(elementStyle, styleParam);
                Reflect.setField(styleSpec, styleParam, styleValue);
            }
            hash.set(key, styleSpec);
        }

        return hash;
    }



    private function parseElement(xmlElement : Fast, elements : StringMap<UIElement>) : LayoutChild<Dynamic>{
        switch(xmlElement.name){
            case "Container":
                var children = new Array<LayoutChild<Dynamic>>();
                for (childXml in xmlElement.elements){
                    var layoutChild = parseElement(childXml, elements);
                    if (layoutChild != null){
                        children.push(layoutChild);
                    }
                }

                var containerId :String = null;
                if (xmlElement.has.id){
                    containerId = xmlElement.att.id;
                }
                var containerLayout :String = xmlElement.att.layout;

                var clazz : Class<Dynamic> = Type.resolveClass(containerLayout);
                var layoutAlgorithm = cast(Type.createInstance(clazz,[]), LayoutAlgorithm<Dynamic, Dynamic>);


                var attributes = xmlElement.x.attributes();
                var layoutSpec = {};
                var params = {};
                for(attribute in attributes){
	                var tuple = getAtt(xmlElement, attribute, "layout:");
                    if(tuple != null){
                        var layoutParam = tuple[0];
                        var layoutValue = tuple[1];
                        Reflect.setField(layoutSpec, layoutParam, layoutValue);
                    }else{
	                    tuple = getAtt(xmlElement, attribute, "params:");
	                    if (tuple != null){
		                    var parameterName = tuple[0];
		                    var parameterValue = tuple[1];
		                    var actualValue : Dynamic = parameterValue;
		                    if(parameterValue == "true"){
			                    actualValue = true;
		                    }else if (parameterValue == "false"){
			                    actualValue = false;
		                    }

		                    Reflect.setField(params, parameterName, actualValue);
	                    }
                    }

                }

                layoutAlgorithm.setParameters(params);

                var styleSpec = styles.get(containerId);
                return container(styleSpec,layoutAlgorithm,children,layoutSpec);
            case "UIElement":
                var elementId :String = xmlElement.att.id;
                var elementType :String = xmlElement.att.type;

                var clazz : Class<Dynamic> = Type.resolveClass(elementType);
                var element = cast(Type.createInstance(clazz,[]), UIComponent<Dynamic, Dynamic, Dynamic>);
                element.setId(elementId);

                var attributes = xmlElement.x.attributes();
                var content = {};
                var layoutSpec = {};
                for(attribute in attributes){
	                var tuple = getAtt(xmlElement, attribute, "layout:");
	                if(tuple != null){
		                var layoutParam = tuple[0];
		                var layoutValue = tuple[1];
		                Reflect.setField(layoutSpec, layoutParam, layoutValue);
		            }else{
		                tuple = getAtt(xmlElement, attribute, "content:");
		                if(tuple != null){
			                var contentParam = tuple[0];
			                var attributeValue = tuple[1];
			                Reflect.setField(content, contentParam, attributeValue);
		                }
	                }

                }

                element.setContent(content);
                var styleSpec = styles.get(elementId);
                elements.set(elementId, element);
                return uiElement(element,styleSpec,layoutSpec);
            default :
                Report.anError("BasicGenericUI", "Layout parsing error : ", "xmlElement should be UIElement or Container ", "" + xmlElement.name + " not recognized");
                return null;
        }
    }

	private function getAtt(xFast : Fast, attribute : String, param : String) : Array<String>{
		if(attribute.startsWith(param + ":")){        // TODO  in As3 this is <namespace uri>::<attributeName> ?(@ appears instead of namespace when no xmlns is defined but faield on a non debug flash player)
			var tuple = new Array<String>();
			tuple.push(attribute.substr((param+":").length));
			tuple.push(xFast.x.get(attribute.replace("::", ":")));    // TODO why the name to get is different from the name you get from the iterator?
			return tuple;
		}else if (attribute.startsWith(param)){
			var tuple = new Array<String>();
			tuple.push(attribute.substr(param.length));
			tuple.push(xFast.x.get(attribute));
			return tuple;
		}
		return null;
	}

    public function get(id : String) : UIElement{
        return elements.get(id);
    }

    public function getActionElement(id : String) : UIActionElement{
        return cast(elements.get(id));
    }


    public static function setupLayout(layoutAlgorithm : LayoutAlgorithm<Dynamic, Dynamic>, children : Array<LayoutChild<Dynamic>>) : Layout<Dynamic, Dynamic>{
        return new Layout(children, layoutAlgorithm);
    }

    public function rootContainer(styleSpec : BasicStyle, layoutAlgorithm : LayoutAlgorithm<Dynamic, Dynamic>, children :Array<LayoutChild<Dynamic>>) : Container<Dynamic, Dynamic>{
        return new Container(uiAssetProvider,styleSpec, setupLayout(layoutAlgorithm,children));
    }

    public function container(styleSpec : BasicStyle, layoutAlgorithm : LayoutAlgorithm<Dynamic, Dynamic>, children :Array<LayoutChild<Dynamic>>, layoutSpec : Dynamic) : LayoutChild<Dynamic>{
        return new LayoutChild(rootContainer(styleSpec,layoutAlgorithm,children), layoutSpec);
    }

    public function uiElement(uiElement : UIComponent<Dynamic, Dynamic,Dynamic>, styleSpec : Dynamic, layoutSpec : Dynamic) : LayoutChild<Dynamic>{
        return new LayoutChild(uiElement.createView(uiAssetProvider,styleSpec), layoutSpec);
    }

}

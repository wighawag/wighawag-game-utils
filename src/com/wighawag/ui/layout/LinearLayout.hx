package com.wighawag.ui.layout;

import com.wighawag.ui.view.ViewPositioning;
import com.wighawag.ui.view.LayoutAlgorithm;
import com.wighawag.ui.view.LayoutChild;
import com.wighawag.ui.view.Layout;

typedef LinearLayoutSpec = {};

typedef LinearLayoutParams = {
	direction : String,
	horizontalPadding : Int,
	verticalPadding : Int,
	spacing: Int,
	fillHorizontally : Bool,
	fillVertically : Bool,
	verticalAlignment : String,
	horizontalAlignment : String
};

class LinearLayout implements LayoutAlgorithm<LinearLayoutSpec, LinearLayoutParams>{

	public static var HORIZONTAL : String = "horizontal";
	public static var VERTICAL : String = "vertical";
	public static var TOP : String = "top";
	public static var CENTER : String = "center";
	public static var BOTTOM : String = "bottom";
	public static var LEFT : String = "left";
	public static var RIGHT : String = "right";


	private var parameters : LinearLayoutParams;

	public function new() {
	}

	public function setParameters(parameters : LinearLayoutParams) : Void{
		this.parameters =  parameters;
	}

	public function compute(drawList : Array<ViewPositioning>, layoutChildren:Array<LayoutChild<LinearLayoutSpec>>, x : Int, y : Int, width : Int, height : Int) : Void{

		var maxChildMinWidth = _getMinWidth(layoutChildren, true);
		var maxChildMinHeight = _getMinHeight(layoutChildren, true);

		switch(parameters.direction){
			case HORIZONTAL:
				var computedWidth = maxChildMinWidth;
				if (parameters.fillHorizontally){
					computedWidth = Std.int((width - parameters.horizontalPadding*2 -((layoutChildren.length - 1) * parameters.spacing))/layoutChildren.length );
				}
				var computedHeight = maxChildMinHeight;
				if (parameters.fillVertically){
					computedHeight = height - parameters.verticalPadding * 2;
				}
				var currentX : Int = parameters.horizontalPadding;
				if (parameters.horizontalAlignment == CENTER){
					currentX += Std.int(((width - parameters.horizontalPadding * 2) - (computedWidth * layoutChildren.length + parameters.spacing * (layoutChildren.length -1))) / 2);
					if (currentX < parameters.horizontalPadding){
						currentX = parameters.horizontalPadding;
					}
				}else if(parameters.horizontalAlignment == RIGHT){
					currentX += Std.int(((width - parameters.horizontalPadding * 2) - (computedWidth * layoutChildren.length + parameters.spacing * (layoutChildren.length -1))) );
				}
				for (layoutChild in layoutChildren){
					var childMinWidth = layoutChild.view.getMinWidth();
					var childMinHeight = layoutChild.view.getMinHeight();
					if(computedWidth < childMinWidth || !parameters.fillHorizontally){
						computedWidth= childMinWidth;
					}
					if(computedHeight < childMinHeight || !parameters.fillVertically){
						computedHeight = childMinHeight;
					}
					var computedX = x + currentX;
					var computedY = y + parameters.verticalPadding;
					if (parameters.verticalAlignment == CENTER){
						computedY = Std.int(y + height / 2 - computedHeight /2);    //center it vertically
					}else if(parameters.verticalAlignment == BOTTOM){
						computedY = y + height - computedHeight - parameters.verticalPadding;
					}
					layoutChild.compute(drawList,computedX,computedY,computedWidth, computedHeight);
					currentX += computedWidth + parameters.spacing;
				}
			case VERTICAL:
				var computedWidth = maxChildMinWidth;
				if (parameters.fillHorizontally){
					computedWidth = width - parameters.horizontalPadding * 2;
				}
				var computedHeight = maxChildMinHeight;
				if (parameters.fillVertically){
					computedHeight = Std.int((height - parameters.verticalPadding * 2 -((layoutChildren.length - 1) * parameters.spacing))/layoutChildren.length  );
				}
				var currentY : Int = parameters.verticalPadding;
				if (parameters.verticalAlignment == CENTER){
					currentY += Std.int(((height - parameters.verticalPadding * 2) - (computedHeight * layoutChildren.length + parameters.spacing * (layoutChildren.length -1))) / 2);
					if (currentY < parameters.verticalPadding){
						currentY = parameters.verticalPadding;
					}
				}else if (parameters.verticalAlignment == BOTTOM){
					currentY += Std.int(((height - parameters.verticalPadding * 2) - (computedHeight * layoutChildren.length + parameters.spacing * (layoutChildren.length -1))) );
				}
				for (layoutChild in layoutChildren){
					var childMinWidth = layoutChild.view.getMinWidth();
					var childMinHeight = layoutChild.view.getMinHeight();
					if(computedWidth < childMinWidth || !parameters.fillHorizontally){
						computedWidth= childMinWidth;
					}
					if(computedHeight < childMinHeight || !parameters.fillVertically){
						computedHeight = childMinHeight;
					}

					var computedX = x + parameters.horizontalPadding;
					if (parameters.horizontalAlignment == CENTER){
						computedX = Std.int(x + width / 2 - computedWidth /2);  //center it  horizontally
					}else if(parameters.horizontalAlignment == RIGHT){
						computedX = x + width - computedWidth - parameters.horizontalPadding;
					}
					var computedY = y + currentY;
					layoutChild.compute(drawList,computedX,computedY,computedWidth, computedHeight);
					currentY += computedHeight + parameters.spacing;
				}
			default: Report.anError("LinearLayout", "unsopported direction " + parameters.direction);
		}


	}

	public function getMinWidth(layoutChildren : Array<LayoutChild<LinearLayoutSpec>>):Int {
		return _getMinWidth(layoutChildren, false) + parameters.horizontalPadding * 2;
	}

	public function _getMinWidth(layoutChildren : Array<LayoutChild<LinearLayoutSpec>>, ?maxChild : Bool = false):Int {
		if(parameters.direction == VERTICAL || maxChild){
			var width = 0;
			for (child in layoutChildren){
				var childMinWidth = child.view.getMinWidth();
				if (width < childMinWidth){
					width = childMinWidth;
				}
			}
			return width ;
		}else{
			var width = 0;
			for (child in layoutChildren){
				width += child.view.getMinWidth() + parameters.spacing;
			}
			return width;
		}
	}

	public function getMinHeight(layoutChildren : Array<LayoutChild<LinearLayoutSpec>>):Int {
		return _getMinHeight(layoutChildren, false) +  parameters.verticalPadding * 2;
	}

	public function _getMinHeight(layoutChildren : Array<LayoutChild<LinearLayoutSpec>>, ?maxChild : Bool = false):Int {
		if(parameters.direction == HORIZONTAL || maxChild){
			var height = 0;
			for (child in layoutChildren){
				var childMinHeight = child.view.getMinHeight();
				if (height < childMinHeight){
					height = childMinHeight;
				}
			}
			return height;
		}else{
			var height = 0;
			for (child in layoutChildren){
				height += child.view.getMinHeight() + parameters.spacing;
			}
			return height;
		}

	}


}

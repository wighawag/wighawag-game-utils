package com.wighawag.ui.content;
import com.wighawag.ui.core.UIElement;

interface UIContent<ContentSpec> implements UIElement {
    function setId(id : String) : Void;
    function setContent(content : ContentSpec) : Void;
}

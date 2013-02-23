package com.wighawag.ui;
import com.wighawag.ui.view.UIElementView;
import com.wighawag.ui.view.UIViewProvider;
import com.wighawag.ui.content.UIContent;
interface UIComponent<UIAssetProvider, ContentSpec,StyleSpec> implements UIContent<ContentSpec>, implements UIViewProvider<UIAssetProvider,StyleSpec>{
}

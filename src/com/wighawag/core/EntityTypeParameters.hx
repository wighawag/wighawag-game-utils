package com.wighawag.core;

import haxe.xml.Fast;
import com.wighawag.system.EntityTypeComponent;
import com.wighawag.system.EntityComponent;
import msignal.Signal;

class EntityTypeParameters implements EntityTypeComponent{


    /*
    <ParametersComponent>
        <param name="gravity" type="Float" value="0.67" />
        <param name="runForce" type="Float" value="0.39" />
    </ParametersComponent>
     */

    private var parameters : Hash<Dynamic>;
    public var onParamUpdated : Signal2<String,Dynamic>;

    public function new(xml : Xml) {
        onParamUpdated = new Signal2();
        parameters = new Hash();

        var x = new Fast(xml);

        for (paramDef in x.nodes.param){
            var paramName : String = paramDef.att.name;
            var paramType : String = paramDef.att.type;
            var paramValue : String = paramDef.att.value;

            var value : Dynamic = null;
            switch(paramType){
                case "Float":   value = Std.parseFloat(paramValue);
                case "Int":     value = Std.parseInt(paramValue);
                case "String":  value =paramValue;
                default :       Report.anError("ParametersComponent", "param type " + paramType + " not recognized.");
            }

            parameters.set(paramName, value);
        }

    }

    public function set(name : String, value : Dynamic) : Void{
        parameters.set(name, value);
        onParamUpdated.dispatch(name,value);
    }

    public function get(name : String) : Dynamic{
       return parameters.get(name);
    }

    public function keys() : Iterator<String>{
        return parameters.keys();
    }



    public function initialise():Void{

    }

    public function populateEntity(entityComponents : Array<EntityComponent>) : Void{

    }
    
}

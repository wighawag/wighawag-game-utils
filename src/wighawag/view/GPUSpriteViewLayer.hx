/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.view;


import wighawag.tile.MapLayer;
import wighawag.tile.ObjectLayer;
import wighawag.gpu.GPUContext;
import com.fermmtools.utils.ObjectHash;
import wighawag.system.Model;
import wighawag.system.Entity;

class GPUSpriteViewLayer implements ViewLayer<GPUContext> {

    private var entityViewFactory : EntityViewFactory<TexturedQuadProgram>;
    private var model : Model;

    private var entitiesViews : ObjectHash<Entity,EntityView<TexturedQuadProgram>>;
    private var camera : Camera2D;

    private var program : TexturedQuadProgram;


    public function new(model : Model, entityViewFactory : EntityViewFactory<TexturedQuadProgram>, camera : Camera2D) {

        entitiesViews = new ObjectHash();
        this.model = model;
        this.entityViewFactory = entityViewFactory;
        this.camera = camera;
        model.onEntityAdded.add(onEntityAdded);
        model.onEntityRemoved.add(onEntityRemoved);
        for(entity in model.entities){
            onEntityAdded(entity);
        }
        program = new TexturedQuadProgram(camera);
    }

    private function onEntityAdded(entity : Entity) : Void{
        var entityView = entityViewFactory.get(entity);
        if (entityView != null){
            entitiesViews.set(entity, entityView);
        }
    }

    private function onEntityRemoved(entity : Entity) : Void{
        entitiesViews.delete(entity);
    }

    public function render(context:GPUContext):Void {
        context.addProgram(program);
        program.reset();
        for (entity in entitiesViews){
            entitiesViews.get(entity).draw(program);
        }
        program.upload();
    }

    public function dispose() : Void{
        model.onEntityAdded.remove(onEntityAdded);
        model.onEntityRemoved.remove(onEntityRemoved);
        program.dispose();
        model = null;
        entityViewFactory = null;
        entitiesViews = null;
        camera = null;
        program = null;
    }

}

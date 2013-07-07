package;

import wighawag.gpu.GPURenderer;
import wighawag.view.Camera2D;
import wighawag.ui.view.UILayer;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.ui.BasicGenericUI;
import wighawag.asset.load.Batch;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class SampleTest 
{
	private var timer:Timer;
	
	public function new() 
	{

	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testExample():Void
	{
        // TODO allow NME testing with flash.Assets.getBitmapData and flash.Assets.getBytes ?
		//new wighawag.asset.NinePatchLibrary(new wighawag.asset.spritesheet.TextureAtlasLibrary(new wighawag.asset.load.NMEAssetManager(new wighawag.asset.load.ResourceMap(""))));
        var ui = new BasicGenericUI("", "", new BasicUIAssetProvider(new Batch([]), new Batch([])));
        //var uiLayer = new UILayer(ui.root, new Camera2D(new GPURenderer()));
	}
	
	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}

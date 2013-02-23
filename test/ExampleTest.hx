package;

import com.wighawag.ui.BasicUIAssetProvider;
import com.wighawag.ui.BasicGenericUI;
import com.wighawag.asset.load.Batch;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ExampleTest 
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
        // allow NME testing with nme.Assets.getBitmapData and nme.Assets.getBytes
		//new com.wighawag.asset.NinePatchLibrary(new com.wighawag.asset.spritesheet.TextureAtlasLibrary(new com.wighawag.asset.load.NMEAssetManager(new com.wighawag.asset.load.ResourceMap(""))));
        new BasicGenericUI("", "", new BasicUIAssetProvider(new Batch([]), new Batch([])));
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

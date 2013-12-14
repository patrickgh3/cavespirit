package ;
 
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.Level;
import com.patrickgh3.cavespirit.scenes.GameScene;
 
class Main extends Engine
{
    public function new()
	{
        super(256, 192, 60, true);
    }
	
    override public function init()
	{
        super.init();
		Level.init();
        //HXP.console.enable();
        //trace("HaxePunk is running!");
		//trace(HXP.screen.scale);
		HXP.scene = new GameScene();
    }
	
    public static function main()
	{
		new Main();
	}
}
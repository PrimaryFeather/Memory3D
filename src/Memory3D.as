package
{
    import flash.display.Sprite;
    
    import starling.core.Starling;
    
    [SWF(width="800", height="600", frameRate="60", backgroundColor="#00a7ff")]
    public class Memory3D extends Sprite
    {
        private var _starling:Starling;
        
        public function Memory3D()
        {
            _starling = new Starling(Game, stage, null, null, "auto", "auto");
            _starling.start();
        }
    }
}
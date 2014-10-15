package
{
    import flash.geom.Vector3D;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class Card extends Sprite
    {
        private var _front:Sprite;
        private var _back:Sprite;
        private var _id:int;
        private var _concealed:Boolean;
        
        private static var sHelperPoint3D:Vector3D = new Vector3D();
        
        public function Card(id:int, iconTexture:Texture)
        {
            init(id, iconTexture);
        }
        
        private function init(id:int, iconTexture:Texture):void
        {
            _id = id;
            _concealed = false;
            
            var cardFront:Image = new Image(Assets.getTexture("card-front"));
            var cardBack:Image = new Image(Assets.getTexture("card-back"));
            var icon:Image = new Image(iconTexture);
            
            _front = new Sprite();
            _front.addChild(cardFront);
            
            icon.scaleX = icon.scaleY = 0.8;
            icon.x = (cardFront.width  - icon.width)  / 2;
            icon.y = (cardFront.height - icon.height) / 2;
            
            _front.addChild(icon);
            _front.alignPivot();
            
            _back = new Sprite();
            _back.addChild(cardBack);
            _back.alignPivot();
            
            addChild(_front);
            addChild(_back);
            
            addEventListener(Event.ENTER_FRAME, updateVisibility);
        }
        
        public function updateVisibility():void
        {
            var stage:Stage = this.stage;
            if (stage == null) return;
            
            stage.getCameraPosition(this, sHelperPoint3D);
            
            _front.visible = sHelperPoint3D.z <  0;
            _back.visible  = sHelperPoint3D.z >= 0;
            
            if (scaleX * scaleY < 0)
            {
                _front.visible = !_front.visible;
                _back.visible  = !_back.visible;
            }
        }
        
        public function get id():int { return _id; }
        
        public function get concealed():Boolean { return _concealed; }
        public function set concealed(value:Boolean):void { _concealed = value; }
    }
}
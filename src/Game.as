package
{
    import flash.geom.Point;
    
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    public class Game extends Sprite
    {
        private const NUM_ROWS:int = 3;
        private const NUM_COLUMNS:int = 4;
        
        private var _playingField:PlayingField;
        
        public function Game()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(Event.COMPLETE, onComplete);
            addEventListener(TouchEvent.TOUCH, onTouch);
        }
        
        private function init():void
        {
            var width:int  = stage.stageWidth;
            var height:int = stage.stageHeight;
            
            var background:Quad = createBackground(width, height, 0x80b0, 0xa7ff); 
            addChild(background);
            
            _playingField = new PlayingField();
            _playingField.x = width / 2;
            _playingField.y = height / 2;
            _playingField.rotationX = -0.6;
            addChild(_playingField);
            
            startGame();
        }
        
        private function startGame():void
        {
            _playingField.dealCards(NUM_COLUMNS, NUM_ROWS);
            addEventListener(TouchEvent.TOUCH, onStartTouch);
            useHandCursor = true;
        }
        
        // event handlers
        
        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this, TouchPhase.MOVED);
            
            if (_playingField && event.shiftKey && touch)
            {
                var delta:Point = touch.getMovement(this);
                _playingField.rotationX += delta.y * 0.01;
                _playingField.rotationY -= delta.x * 0.01;
            }
        }
        
        private function onStartTouch(event:TouchEvent):void
        {
            if (event.getTouch(this, TouchPhase.ENDED))
            {
                useHandCursor = false;
                removeEventListener(TouchEvent.TOUCH, onStartTouch);
                _playingField.concealAllCards();
            }
        }
        
        private function onEnterFrame(event:EnterFrameEvent, passedTime:Number):void
        {
            _playingField.advanceTime(passedTime);
        }
        
        private function onComplete():void
        {
            _playingField.removeCards(startGame);
        }
        
        // helpers
        
        private function createBackground(width:int, height:int, colorA:uint, colorB:uint):Quad
        {
            var quad:Quad = new Quad(width, height, colorA);
            quad.setVertexColor(2, colorB);
            quad.setVertexColor(3, colorB);
            return quad;
        }
    }
}
package
{
    import starling.animation.Juggler;
    import starling.animation.Transitions;
    import starling.display.Sprite;
    import starling.display.Sprite3D;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    public class PlayingField extends Sprite3D
    {
        private var _cards:Sprite;
        private var _juggler:Juggler;
        private var _selectedCards:Array;
        private var _numTurnedCards:int;
        
        private static const ANIM_TIME:Number = 0.5;
        
        public function PlayingField()
        {
            _juggler = new Juggler();
        }
        
        public function dealCards(numColumns:int, numRows:int):void
        {
            removeChildren();
            
            _cards = createCardPlane(numColumns, numRows);
            addChild(_cards);
            
            for (var i:int=0; i<_cards.numChildren; ++i)
                dealCard(_cards.getChildAt(i) as Card, i * 0.075);
            
            _selectedCards  = [];
            _numTurnedCards = 0;
        }
        
        public function removeCards(onComplete:Function):void
        {
            var numCards:int = _cards.numChildren;
            
            for (var i:int=0; i<numCards; ++i)
            {
                var card:Card = _cards.getChildAt(i) as Card;
                var onRemoved:Function = i < numCards - 1 ? null : complete;
                removeCard(card, i * 0.075, onRemoved);
            }
            
            function complete():void
            {
                onComplete();
            }
        }
        
        public function concealAllCards():void
        {
            for (var i:int=0; i<_cards.numChildren; ++i)
                turnCard(_cards.getChildAt(i) as Card, 0, onCardConcealed);
        }
        
        public function advanceTime(time:Number):void
        {
            _juggler.advanceTime(time);
        }
        
        private function createCardPlane(numColumns:int, numRows:int):Sprite
        {
            var plane:Sprite = new Sprite();
            addChild(plane);
            
            var iconTextures:Vector.<Texture> = Assets.getTextures("icon-");
            shuffleArray(iconTextures);
            
            var cards:Array = [];
            for (var i:int=0; i<numColumns * numRows / 2; ++i)
            {
                var iconTexture:Texture = iconTextures.pop();
                cards.push(new Card(i, iconTexture));
                cards.push(new Card(i, iconTexture));
            }
            
            shuffleArray(cards);
            
            var margin:Number = 20;
            var cardSize:Number = cards[0].width;
            var offsetX:Number = (numColumns * cardSize + (numColumns - 1) * margin) / -2;
            var offsetY:Number = (numRows    * cardSize + (numRows    - 1) * margin) / -2;
            var count:int = 0;
            
            for (var col:int=0; col<numColumns; ++col)
            {
                for (var row:int=0; row<numRows; ++row)
                {
                    var card:Card = cards.pop();
                    card.x = (cardSize + margin) * col + cardSize / 2 + offsetX;
                    card.y = (cardSize + margin) * row + cardSize / 2 + offsetY;
                    card.useHandCursor = true;
                    card.touchGroup = true;
                    card.touchable = false;
                    card.addEventListener(TouchEvent.TOUCH, onCardTouched);
                    plane.addChild(card);
                }
            }
            
            return plane;
        }
        
        // event handlers
        
        private function onCardTouched(event:TouchEvent):void
        {
            var card:Card = event.target as Card;
            var touch:Touch = event.getTouch(card, TouchPhase.ENDED);
            
            if (touch && _selectedCards.length < 2)
            {
                _selectedCards.push(card);
                card.touchable = false;
                turnCard(card, 0, onCardRevelead);
            }
        }
        
        private function onCardRevelead(card:Card):void
        {
            if (_selectedCards.indexOf(card) == 1)
            {
                if (_selectedCards[0].id == _selectedCards[1].id)
                {
                    _numTurnedCards += 2;
                    _selectedCards = [];
                    
                    if (_numTurnedCards == _cards.numChildren)
                        dispatchEventWith(Event.COMPLETE, true);
                }
                else
                {
                    turnCard(_selectedCards[0], ANIM_TIME);
                    turnCard(_selectedCards[1], ANIM_TIME, function():void
                    {
                        _selectedCards[0].touchable = _selectedCards[1].touchable = true;
                        _selectedCards = [];
                    });
                }
            }
        }
        
        private function onCardConcealed(card:Card):void
        {
            card.touchable = true;
        }
        
        // animation
        
        private function dealCard(card:Card, delay:Number=0):void
        {
            card.alpha = 0;
            card.z = -150;
            
            _juggler.tween(card, ANIM_TIME, {
                z: 0,
                alpha: 1.0,
                delay: delay,
                transition: Transitions.EASE_OUT
            });
        }
        
        private function removeCard(card:Card, delay:Number=0, onComplete:Function=null):void
        {
            card.alpha = 1.0;
            card.z = 0;
            
            _juggler.tween(card, ANIM_TIME, {
                z: -150,
                alpha: 0.0,
                delay: delay,
                onComplete: onComplete,
                onCompleteArgs: [card],
                transition: Transitions.EASE_IN
            });
        }
        
        private function turnCard(card:Card, delay:Number=0, onComplete:Function=null):void
        {
            // We reduce draw calls via a small trick: each *3d-transformed* card will cause
            // a draw call. By swaping the up- and downside of the card before the animation and
            // then making sure it ends with a 'rotationY' of zero, the card will only be
            // 3d-transformed while it's being turned -- not when it lies flat.

            card.swapSides();
            card.rotationY = Math.PI;
            card.concealed = !card.concealed;
            
            _juggler.removeTweens(card);
            _juggler.tween(card, ANIM_TIME, { 
                rotationY: 0,
                delay: delay,
                onComplete: onComplete,
                onCompleteArgs: [card],
                transition: Transitions.EASE_IN_OUT
            });
        }
        
        // helpers
        
        private function shuffleArray(array:*):void
        {
            var length:int = array.length;
            
            for (var i:int=0; i<length; ++i)
                array.splice(Math.random() * array.length, 0, array.pop());
        }
    }
}
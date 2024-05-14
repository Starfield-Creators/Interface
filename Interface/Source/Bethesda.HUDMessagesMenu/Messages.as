package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   
   public class Messages extends BSDisplayObject
   {
      
      private static var MAX_SHOWN:uint = 4;
      
      private static var END_ANIM_FRAME:uint = 70;
       
      
      public var MessageArray:Vector.<String>;
      
      public var QueuedMessageArray:Vector.<String>;
      
      public var ShownMessageArray:Vector.<HUDMessageItem>;
      
      private var MessageSpacing:uint = 4;
      
      private var bAnimating:Boolean;
      
      private var ySpacing:Number;
      
      private var bqueuedMessage:Boolean = false;
      
      private var fadingOutMessage:Boolean = false;
      
      private const _maxClipHeight:Number = 150;
      
      public function Messages()
      {
         super();
         this.MessageArray = new Vector.<String>();
         this.QueuedMessageArray = new Vector.<String>();
         this.ShownMessageArray = new Vector.<HUDMessageItem>();
         this.bAnimating = false;
         BSUIDataManager.Subscribe("HUDMessageData",this.onDataUpdate);
         addEventListener(Event.ENTER_FRAME,this.Update);
      }
      
      private function get ShownCount() : int
      {
         return this.ShownMessageArray.length;
      }
      
      private function UpdatePositions() : *
      {
         var _loc2_:HUDMessageItem = null;
         var _loc3_:* = undefined;
         var _loc4_:HUDMessageItem = null;
         var _loc5_:HUDMessageItem = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         var _loc11_:* = undefined;
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc1_:int = this.ShownCount;
         if(_loc1_ == 1)
         {
            _loc2_ = this.ShownMessageArray[0];
            if(!_loc2_.fadeInStarted)
            {
               if(_loc2_.CanFadeIn())
               {
                  _loc2_.FadeIn();
               }
               this.bAnimating = true;
               this.fadingOutMessage = false;
            }
            else if(this.MessageArray.length == 0 && !this.fadingOutMessage && _loc2_.CanFadeOut())
            {
               _loc2_.FadeOut();
               this.bAnimating = false;
               this.fadingOutMessage = true;
            }
            else
            {
               this.bAnimating = false;
               this.fadingOutMessage = false;
            }
         }
         else if(_loc1_ > 1)
         {
            _loc3_ = _loc1_ - 1;
            _loc4_ = this.ShownMessageArray[_loc3_];
            _loc5_ = this.ShownMessageArray[_loc3_ - 1];
            _loc6_ = _loc4_.height;
            _loc7_ = _loc5_.y;
            _loc9_ = uint((_loc8_ = _loc6_ + this.MessageSpacing) - _loc7_);
            this.bAnimating = _loc9_ > 0 || _loc4_.bIsDirty;
            if(!_loc4_.bIsDirty)
            {
               if(_loc10_ = _loc4_.CanFadeIn() && height + _loc4_.height + this.MessageSpacing < this._maxClipHeight)
               {
                  _loc4_.FadeIn();
               }
               if(this.bAnimating && _loc4_.fadeInStarted)
               {
                  _loc11_ = 1;
                  _loc12_ = 0;
                  while(_loc12_ < _loc3_)
                  {
                     this.ShownMessageArray[_loc12_].y += _loc11_;
                     _loc12_++;
                  }
               }
               else if(!this.fadingOutMessage)
               {
                  _loc13_ = !_loc10_ && _loc4_.CanFadeIn();
                  if(!this.bqueuedMessage || _loc1_ == MAX_SHOWN || _loc13_ && this.ShownMessageArray[0].CanFadeOut())
                  {
                     this.fadingOutMessage = true;
                     this.ShownMessageArray[0].FadeOut();
                  }
               }
            }
         }
      }
      
      private function RemoveMessages(param1:Boolean) : *
      {
         var _loc3_:Vector.<HUDMessageItem> = null;
         var _loc2_:int = int(this.ShownMessageArray.length - 1);
         while(_loc2_ >= 0)
         {
            if(!param1 || this.ShownMessageArray[_loc2_].currentFrame >= END_ANIM_FRAME)
            {
               _loc3_ = this.ShownMessageArray.splice(_loc2_,1);
               this.removeChild(_loc3_[0]);
               this.fadingOutMessage = false;
            }
            _loc2_--;
         }
      }
      
      private function CanAddMessage() : Boolean
      {
         return !this.bAnimating && !this.fadingOutMessage && this.ShownCount < MAX_SHOWN;
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : *
      {
         if(param1.data.bClearMessages)
         {
            this.RemoveMessages(false);
            this.QueuedMessageArray.splice(0,this.QueuedMessageArray.length);
         }
         else if(param1.data.NextMessage.sText != "")
         {
            if(this.visible)
            {
               this.MessageArray.push(param1.data.NextMessage.sText);
            }
            else
            {
               this.QueuedMessageArray.push(param1.data.NextMessage.sText);
            }
            GlobalFunc.PlayMenuSound(param1.data.NextMessage.sSound);
         }
      }
      
      private function Update() : *
      {
         var _loc3_:HUDMessageItem = null;
         if(this.visible)
         {
            while(this.QueuedMessageArray.length > 0)
            {
               this.MessageArray.push(this.QueuedMessageArray.shift());
            }
         }
         this.bqueuedMessage = this.MessageArray.length > 0;
         var _loc1_:* = this.ShownCount > 0;
         this.RemoveMessages(true);
         if(this.bqueuedMessage && this.CanAddMessage())
         {
            _loc3_ = new HUDMessageItem();
            this.addChild(_loc3_);
            this.ShownMessageArray.push(_loc3_);
            _loc3_.SetText(this.MessageArray.shift());
         }
         this.UpdatePositions();
         var _loc2_:* = this.ShownCount > 0;
         if(_loc1_ || _loc2_)
         {
            SetIsDirty();
         }
      }
   }
}

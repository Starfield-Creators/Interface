package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DisplayMessage extends MovieClip
   {
       
      
      public var Message_mc:MovieClip;
      
      public var Symbol_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private var _activeMessage:Boolean = false;
      
      private var _minWidth:Number = 1;
      
      private var _minHeight:Number = 1;
      
      private var _startingX:Number;
      
      private var _largeTextMode:Boolean = false;
      
      private const HORIZONTAL_PADDING:Number = 20;
      
      private const VERTICAL_PADDING:Number = 7;
      
      private const CENTER_SPACING:Number = 1200;
      
      public function DisplayMessage()
      {
         super();
         if(!this._largeTextMode)
         {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.Message_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.activeMessage = false;
         this._minWidth = this.Symbol_mc.width + (this.Message_mc.x - (this.Symbol_mc.x + this.Symbol_mc.width)) + this.HORIZONTAL_PADDING * 2;
         this._minHeight = this.Symbol_mc.height + this.VERTICAL_PADDING * 2;
         this._startingX = this.x;
         BSUIDataManager.Subscribe("WorkshopMessageData",this.OnMessageDataUpdate);
      }
      
      private function get Message_tf() : TextField
      {
         return this.Message_mc.Message_tf;
      }
      
      private function set activeMessage(param1:Boolean) : void
      {
         this._activeMessage = param1;
         this.visible = this._activeMessage;
      }
      
      private function OnMessageDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc6_:TextLineMetrics = null;
         GlobalFunc.SetText(this.Message_tf,param1.data.sMessageText);
         this.activeMessage = param1.data.sMessageText != "";
         var _loc2_:Number = this._minHeight;
         var _loc3_:Number = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < this.Message_tf.numLines)
         {
            _loc6_ = this.Message_tf.getLineMetrics(_loc4_);
            if(_loc4_ > 0)
            {
               _loc2_ += _loc6_.height;
            }
            if(_loc3_ < _loc6_.width)
            {
               _loc3_ = _loc6_.width;
            }
            _loc4_++;
         }
         var _loc5_:Number = this._minWidth + _loc3_;
         this.Background_mc.width = _loc5_;
         this.Background_mc.height = _loc2_;
         this.x = this._startingX + (this.CENTER_SPACING - _loc5_) / 2;
      }
   }
}

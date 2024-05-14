package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class XPIncreaseWidget extends MovieClip
   {
       
      
      public var XPText_mc:MovieClip;
      
      public var XPBar_mc:MovieClip;
      
      public var XPText_tf:TextField;
      
      private var CurrentXPDisplayAmount:uint = 0;
      
      private var OrigBarWidth:Number = 0;
      
      private const EVENT_ANIM_DONE:String = "AnimDone";
      
      public function XPIncreaseWidget()
      {
         super();
         this.XPText_tf = this.XPText_mc.XPText_tf;
         this.OrigBarWidth = this.XPBar_mc.width;
         BSUIDataManager.Subscribe("XPData",this.onDataChange);
      }
      
      private function InUse() : Boolean
      {
         return hasEventListener(this.EVENT_ANIM_DONE);
      }
      
      public function onDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.XPUpdatesA.length)
         {
            this.CurrentXPDisplayAmount += param1.data.XPUpdatesA[_loc2_].uiXPAmount;
            _loc2_++;
         }
         if(param1.data.XPUpdatesA.length > 0)
         {
            this.XPBar_mc.XPBarInnerClip_mc.width = param1.data.XPUpdatesA[param1.data.XPUpdatesA.length - 1].fProgressPercent * this.OrigBarWidth;
         }
         this.TryDisplayXp();
      }
      
      public function SetVisible(param1:Boolean) : void
      {
         this.visible = param1;
         this.TryDisplayXp();
      }
      
      private function onAnimDone(param1:Event) : *
      {
         removeEventListener(this.EVENT_ANIM_DONE,this.onAnimDone);
         this.TryDisplayXp();
      }
      
      private function TryDisplayXp() : void
      {
         if(!this.InUse() && this.visible && this.CurrentXPDisplayAmount > 0)
         {
            GlobalFunc.SetText(this.XPText_tf,this.CurrentXPDisplayAmount.toString() + " $$XP");
            this.CurrentXPDisplayAmount = 0;
            addEventListener(this.EVENT_ANIM_DONE,this.onAnimDone);
            gotoAndPlay("Show");
         }
      }
   }
}

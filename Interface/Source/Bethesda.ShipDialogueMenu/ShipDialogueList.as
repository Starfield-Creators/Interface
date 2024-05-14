package
{
   import Shared.AS3.BSScrollingContainer;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ShipDialogueList extends BSScrollingContainer
   {
      
      private static const ANIM_OPENING:uint = EnumHelper.GetEnum(0);
      
      private static const ANIM_OPEN:uint = EnumHelper.GetEnum();
      
      private static const ANIM_CLOSING:uint = EnumHelper.GetEnum();
      
      private static const ANIM_CLOSED:uint = EnumHelper.GetEnum();
      
      public static const ON_ENTRY_CLOSE_ANIM_FINISH:String = "OnEntryCloseAnimFinish";
      
      public static const ON_LIST_CLOSE_ANIM_FINISH:String = "OnListCloseAnimFinish";
       
      
      public var Title_mc:MovieClip;
      
      public var IncomingText_mc:MovieClip;
      
      private var OpenAnimationCounter:int = 0;
      
      private var CloseAnimationCounter:int = 0;
      
      private var LastAnimation:uint;
      
      public function ShipDialogueList()
      {
         this.LastAnimation = ANIM_CLOSED;
         super();
      }
      
      public function get IncomingTextInternal_mc() : MovieClip
      {
         return this.IncomingText_mc.Internal_mc;
      }
      
      private function OnOutgoingAnimationFinished() : *
      {
         if(this.LastAnimation != ANIM_OPENING)
         {
            if(this.LastAnimation != ANIM_OPEN)
            {
               this.LastAnimation = ANIM_OPENING;
            }
            this.OpenAnimationCounter = 0;
            addEventListener(Event.ENTER_FRAME,this.OnOpenAnimationPlay);
         }
      }
      
      public function TriggerCloseAnimation() : *
      {
         if(this.LastAnimation != ANIM_CLOSING)
         {
            if(this.LastAnimation != ANIM_CLOSED)
            {
               this.LastAnimation = ANIM_CLOSING;
            }
            this.CloseAnimationCounter = 0;
            addEventListener(Event.ENTER_FRAME,this.OnCloseAnimationPlay);
         }
      }
      
      private function OnOpenAnimationPlay() : *
      {
         var _loc1_:MovieClip = null;
         if(this.OpenAnimationCounter < entryList.length && this.LastAnimation != ANIM_OPEN)
         {
            _loc1_ = GetClipByIndex(this.OpenAnimationCounter);
            if(_loc1_ != null && _loc1_.currentFrameLabel != "Open")
            {
               _loc1_.gotoAndPlay("RollOn");
            }
            ++this.OpenAnimationCounter;
         }
         else
         {
            if(this.LastAnimation != ANIM_CLOSING)
            {
               this.LastAnimation = ANIM_OPEN;
            }
            removeEventListener(Event.ENTER_FRAME,this.OnOpenAnimationPlay);
         }
      }
      
      private function OnCloseAnimationPlay() : *
      {
         var _loc1_:MovieClip = null;
         if(this.CloseAnimationCounter < entryList.length && this.LastAnimation != ANIM_CLOSED)
         {
            _loc1_ = GetClipByIndex(this.CloseAnimationCounter);
            if(_loc1_ != null && _loc1_.currentFrameLabel != "Closed")
            {
               _loc1_.gotoAndPlay("RollOff");
            }
            ++this.CloseAnimationCounter;
         }
         else
         {
            if(this.LastAnimation != ANIM_OPENING)
            {
               this.LastAnimation = ANIM_CLOSED;
            }
            removeEventListener(Event.ENTER_FRAME,this.OnCloseAnimationPlay);
            dispatchEvent(new Event(ON_ENTRY_CLOSE_ANIM_FINISH,true,true));
         }
      }
      
      public function OnRollOffComplete() : *
      {
         dispatchEvent(new Event(ON_LIST_CLOSE_ANIM_FINISH,true,true));
      }
      
      public function SetTitleText(param1:String) : *
      {
         GlobalFunc.SetText(this.Title_mc.Text_tf,param1);
      }
   }
}

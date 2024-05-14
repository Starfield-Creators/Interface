package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ArtifactHealthBoost extends MovieClip
   {
       
      
      public var Label_mc:MovieClip;
      
      public function ArtifactHealthBoost()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.visible = false;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         BSUIDataManager.Subscribe("PlayerHealthBoostData",this.OnPlayerHealthDataUpdate);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function OnPlayerHealthDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         var _loc3_:* = int(_loc2_.fHealthBoost);
         if(_loc3_ > 0)
         {
            this.addEventListener("AnimCompleteEvent",this.HealthBoostAnimationDone);
            GlobalFunc.SetText(this.Label_mc.text_tf,"$MAX HEALTH INCREASED BY",false,false,0,false,0,[String(_loc3_)]);
            this.visible = true;
            this.gotoAndPlay("Open");
         }
      }
      
      private function HealthBoostAnimationDone(param1:Event) : void
      {
         this.removeEventListener("AnimCompleteEvent",this.HealthBoostAnimationDone);
         this.visible = false;
      }
   }
}

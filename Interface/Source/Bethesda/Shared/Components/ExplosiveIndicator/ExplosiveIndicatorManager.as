package Shared.Components.ExplosiveIndicator
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   
   public class ExplosiveIndicatorManager extends BSDisplayObject
   {
       
      
      private var Clips:Array;
      
      public function ExplosiveIndicatorManager()
      {
         this.Clips = new Array();
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ExplosiveIndicatorData",this.OnExplosiveDataUpdate);
      }
      
      private function OnExplosiveDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc4_:Object = null;
         var _loc5_:ExplosiveIndicatorBase = null;
         var _loc2_:Object = param1.data;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.ExplosivesA.length)
         {
            _loc4_ = _loc2_.ExplosivesA[_loc3_];
            if((_loc5_ = this.GetClipAtIndex(_loc3_)) != null)
            {
               _loc5_.visible = true;
               _loc5_.SetExplosive(_loc4_);
            }
            _loc3_++;
         }
         while(_loc3_ < this.Clips.length)
         {
            this.GetClipAtIndex(_loc3_).visible = false;
            _loc3_++;
         }
      }
      
      private function GetClipAtIndex(param1:int) : ExplosiveIndicatorBase
      {
         var _loc2_:* = undefined;
         if(param1 > this.Clips.length)
         {
            GlobalFunc.TraceWarning("index has gone past Clips.length");
         }
         if(this.Clips.length == param1)
         {
            _loc2_ = new ExplosiveIndicatorBase();
            addChild(_loc2_);
            this.Clips.push(_loc2_);
         }
         return this.Clips[param1];
      }
   }
}

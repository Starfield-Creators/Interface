package
{
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class BoostComponent extends MovieClip
   {
       
      
      public var BoostFuel_mc:MovieClip;
      
      private var LastBoostFuel:Number = -1;
      
      private var LowBoostThreshold:Number = 0;
      
      private var WasBelowLowBoostThreshold:Boolean = false;
      
      private var BoostButton:ButtonBase;
      
      public function BoostComponent()
      {
         super();
      }
      
      public function ShipHudDataUpdate(param1:Object) : *
      {
         this.UpdateBoostFuel(this.LastBoostFuel,param1.fLowBoostThreshold);
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         this.UpdateBoostFuel(param1.boost,this.LowBoostThreshold);
      }
      
      private function UpdateBoostFuel(param1:Number, param2:Number) : *
      {
         var _loc3_:* = false;
         var _loc4_:String = null;
         if(this.LastBoostFuel != param1 || this.LowBoostThreshold != param2)
         {
            this.LowBoostThreshold = param2;
            this.BoostFuel_mc.gotoAndStop(GlobalFunc.MapLinearlyToRange(this.BoostFuel_mc.framesLoaded,1,0,1,param1,true));
            _loc3_ = param1 <= this.LowBoostThreshold;
            if(param1 == 1)
            {
               GlobalFunc.PlayMenuSound("UICockpitHUD_Afterburner_1Full");
            }
            else if(_loc3_ && !this.WasBelowLowBoostThreshold)
            {
               GlobalFunc.PlayMenuSound("UICockpitHUD_Afterburner_2Low");
            }
            else if(param1 == 0)
            {
               GlobalFunc.PlayMenuSound("UICockpitHUD_Afterburner_3Depleted");
            }
            _loc4_ = "";
            if(param1 == 0 && this.LastBoostFuel > 0)
            {
               _loc4_ = "FuelEmpty";
            }
            else if(_loc3_ && !this.WasBelowLowBoostThreshold)
            {
               _loc4_ = "FuelLow";
            }
            else if(!_loc3_ && this.WasBelowLowBoostThreshold)
            {
               _loc4_ = "FuelNotLow";
            }
            else if(param1 > 0 && this.LastBoostFuel == 0)
            {
               _loc4_ = "FuelNotEmpty";
            }
            if(_loc4_ != "")
            {
               gotoAndPlay(_loc4_);
               if(this.BoostButton != null)
               {
                  this.BoostButton.gotoAndPlay(_loc4_);
               }
            }
            this.LastBoostFuel = param1;
            this.WasBelowLowBoostThreshold = _loc3_;
         }
      }
      
      public function SetBoostButton(param1:ButtonBase) : *
      {
         this.BoostButton = param1;
      }
   }
}

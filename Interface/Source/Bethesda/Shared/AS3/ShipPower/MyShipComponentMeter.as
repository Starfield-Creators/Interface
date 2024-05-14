package Shared.AS3.ShipPower
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class MyShipComponentMeter extends ShipPowerMeter
   {
      
      private static const FLASH_ANIM_SUFFIX:String = "FlashRed";
      
      private static const COMPONENT_REPAIRED_SOUND:String = "UICockpitShipDamageComponentGreen";
      
      private static const COMPONENT_YELLOW_SOUND:String = "UICockpitShipDamageComponentYellow";
       
      
      public var ActiveSelection_mc:MovieClip;
      
      public var ComponentMeterFrame_mc:MovieClip;
      
      private var LastAnimLabel:String = "";
      
      private var QueuedInvalidActionAnimation:Boolean = false;
      
      public function MyShipComponentMeter()
      {
         super();
         this.ActiveSelection_mc.gotoAndStop("Blue");
         this.ComponentMeterFrame_mc.gotoAndStop("Blue");
      }
      
      override public function Update() : *
      {
         var _loc1_:String = null;
         super.Update();
         if(componentObject != null)
         {
            _loc1_ = this.GetCurrentBracketColor();
            if(!this.QueuedInvalidActionAnimation)
            {
               if(this.ComponentMeterFrame_mc.currentFrameLabel != _loc1_ && this.LastAnimLabel != _loc1_ + "Flash")
               {
                  this.LastAnimLabel = _loc1_;
                  this.ComponentMeterFrame_mc.gotoAndStop(this.LastAnimLabel);
                  if(_loc1_ == "Orange")
                  {
                     GlobalFunc.PlayMenuSound(COMPONENT_YELLOW_SOUND);
                  }
                  if(_loc1_ == "Blue")
                  {
                     GlobalFunc.PlayMenuSound(COMPONENT_REPAIRED_SOUND);
                  }
               }
            }
            else
            {
               if(this.ActiveSelection_mc.visible)
               {
                  this.ActiveSelection_mc.gotoAndPlay("BlueFlashRed");
               }
               else if(_loc1_ != "Red")
               {
                  this.LastAnimLabel = _loc1_ + "Flash";
                  this.ComponentMeterFrame_mc.gotoAndPlay(this.LastAnimLabel);
               }
               this.QueuedInvalidActionAnimation = false;
            }
         }
      }
      
      private function GetCurrentBracketColor() : String
      {
         var _loc2_:uint = 0;
         var _loc1_:String = "Blue";
         if(componentObject.componentMaxPower > 0)
         {
            _loc2_ = componentObject.damagePhys + componentObject.damageEM;
            if(_loc2_ >= componentObject.componentMaxPower)
            {
               _loc1_ = "Red";
            }
            else if(_loc2_ > componentObject.componentMaxPower * 0.5)
            {
               _loc1_ = "Orange";
            }
         }
         return _loc1_;
      }
      
      public function PlayInvalidActionAnimation() : *
      {
         this.QueuedInvalidActionAnimation = true;
         this.Update();
      }
      
      public function SetSelected(param1:Boolean) : *
      {
         if(this.ActiveSelection_mc.visible != param1)
         {
            if(param1)
            {
               this.ActiveSelection_mc.gotoAndStop("Blue");
            }
            else
            {
               this.ComponentMeterFrame_mc.gotoAndStop(this.GetCurrentBracketColor());
            }
            this.ActiveSelection_mc.visible = param1;
            this.ComponentMeterFrame_mc.visible = !param1;
         }
      }
   }
}

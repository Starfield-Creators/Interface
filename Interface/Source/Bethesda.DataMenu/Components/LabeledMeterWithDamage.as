package Components
{
   import Shared.GlobalFunc;
   import flash.display.Shape;
   
   public class LabeledMeterWithDamage extends LabeledMeterMC
   {
       
      
      private var DamageFillBarClip:Shape;
      
      private const DamageFillColor:uint = 14849830;
      
      private var PredictiveHealthFillBarClip:Shape;
      
      private const PredictiveHealthFillColor:uint = 4587421;
      
      public function LabeledMeterWithDamage()
      {
         this.DamageFillBarClip = new Shape();
         this.PredictiveHealthFillBarClip = new Shape();
         super();
         this.DamageFillBarClip.name = "DamageFillBar";
         addChild(this.DamageFillBarClip);
         this.DamageFillBarClip.x = Background_mc.x;
         this.DamageFillBarClip.y = Background_mc.y;
         this.PredictiveHealthFillBarClip.name = "PredictiveHealthFillBar";
         addChild(this.PredictiveHealthFillBarClip);
         this.PredictiveHealthFillBarClip.x = Background_mc.x;
         this.PredictiveHealthFillBarClip.y = Background_mc.y;
      }
      
      private function UpdateDamageFill() : *
      {
      }
      
      public function SetCurrentDamage(param1:Number) : *
      {
         var _loc2_:Number = MaximumValue != 0 ? param1 / MaximumValue : 0;
         _loc2_ = GlobalFunc.Clamp(_loc2_,0,1);
         var _loc3_:Number = Background_mc.width * _loc2_;
         this.DamageFillBarClip.graphics.clear();
         this.DamageFillBarClip.graphics.beginFill(this.DamageFillColor);
         this.DamageFillBarClip.graphics.drawRect(Background_mc.width - _loc3_,0,_loc3_,Background_mc.height);
         this.DamageFillBarClip.graphics.endFill();
      }
      
      public function SetHealthGainPercent(param1:Number) : *
      {
         var _loc2_:Number = TargetFillValue / MaximumValue;
         var _loc3_:Number = GlobalFunc.Clamp(param1,0,1 - _loc2_);
         var _loc4_:Number = Background_mc.width * _loc3_;
         var _loc5_:* = Background_mc.width * _loc2_;
         this.DamageFillBarClip.graphics.clear();
         this.DamageFillBarClip.graphics.beginFill(this.PredictiveHealthFillColor);
         this.DamageFillBarClip.graphics.drawRect(_loc5_,0,_loc4_,Background_mc.height);
         this.DamageFillBarClip.graphics.endFill();
      }
   }
}

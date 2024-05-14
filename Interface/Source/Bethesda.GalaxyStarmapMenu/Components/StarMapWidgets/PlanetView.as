package Components.StarMapWidgets
{
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   
   public class PlanetView extends BodyView
   {
      
      private static const START_TIME_TO_EXPAND:Number = 0.1;
      
      private static const EXPAND_TIME_PER_ROW:Number = 0.15;
      
      private static const MOON_TO_MOON_SPACING:Number = 9;
      
      private static const PLANET_TO_MOON_SPACING:Number = 10;
      
      private static const PLANET_TO_SHIP_SPACING:Number = 4;
      
      private static const MOON_RADIUS:Number = MoonView.MOON_SIZE * 0.5;
      
      private static const MOON_SPACING:Number = MOON_RADIUS + MOON_TO_MOON_SPACING;
       
      
      public function PlanetView()
      {
         super();
      }
      
      override protected function GetChildBodyClass() : Class
      {
         return MoonView;
      }
      
      public function ExpandMoons() : *
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         var _loc1_:uint = Math.ceil(NumChildren / 2);
         var _loc2_:Number = START_TIME_TO_EXPAND + _loc1_ * EXPAND_TIME_PER_ROW;
         var _loc3_:Number = START_TIME_TO_EXPAND + EXPAND_TIME_PER_ROW * _loc1_;
         var _loc4_:Number = Body_mc.height / 2 + PLANET_TO_MOON_SPACING;
         var _loc5_:* = 0;
         while(_loc5_ < ChildClipsA.length)
         {
            (_loc6_ = ChildClipsA[_loc5_]).visible = true;
            _loc7_ = MOON_RADIUS / 2 + MOON_TO_MOON_SPACING / 2;
            if(_loc5_ == NumChildren - 1 && NumChildren % 2 == 1)
            {
               _loc7_ = 0;
            }
            if(_loc5_ % 2 == 1)
            {
               _loc7_ *= -1;
            }
            this.ExpandMoon(_loc6_,_loc7_,_loc4_,_loc2_,_loc3_);
            if(_loc5_ % 2 == 1)
            {
               _loc4_ += MOON_SPACING;
               _loc2_ -= EXPAND_TIME_PER_ROW;
               _loc3_ -= EXPAND_TIME_PER_ROW;
            }
            _loc5_++;
         }
      }
      
      private function ExpandMoon(param1:Object, param2:Number, param3:Number, param4:Number, param5:Number = 0.5) : *
      {
         param3 *= -1;
         if(param1 != null)
         {
            eaze(param1).apply({
               "x":param2,
               "y":-5
            }).delay(param4).easing(Quadratic.easeOut).to(param5,{"y":param3});
         }
      }
      
      public function ContractMoons() : *
      {
         var _loc5_:MovieClip = null;
         var _loc1_:uint = Math.ceil(NumChildren / 2);
         var _loc2_:Number = START_TIME_TO_EXPAND;
         var _loc3_:Number = START_TIME_TO_EXPAND;
         var _loc4_:* = 0;
         while(_loc4_ < ChildClipsA.length)
         {
            _loc5_ = ChildClipsA[_loc4_];
            this.ContractMoon(_loc5_,_loc2_,_loc3_);
            if(_loc4_ % 2 == 1)
            {
               _loc2_ += EXPAND_TIME_PER_ROW;
               _loc3_ += EXPAND_TIME_PER_ROW;
            }
            _loc4_++;
         }
      }
      
      private function ContractMoon(param1:Object, param2:Number, param3:Number = 0.5) : *
      {
         if(param1 != null)
         {
            eaze(param1).delay(param2).easing(Quadratic.easeOut).to(param3,{"y":-5}).apply({"visible":false});
         }
      }
      
      override public function ExpandChildBodies(param1:uint) : *
      {
         this.ContractMoons();
         super.ExpandChildBodies(param1);
      }
      
      override protected function onContractionComplete(param1:BodyView) : *
      {
         var _loc4_:BodyView = null;
         super.onContractionComplete(param1);
         var _loc2_:* = true;
         var _loc3_:* = 0;
         while(_loc2_ && _loc3_ < NumChildren)
         {
            _loc2_ = !(_loc4_ = ChildClipsA[_loc3_] as BodyView).visible;
            _loc3_++;
         }
         if(_loc2_)
         {
            this.ExpandMoons();
         }
      }
   }
}

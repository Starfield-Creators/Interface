package Components
{
   import Shared.GlobalFunc;
   import Shared.TextUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DeltaTextValue extends MovieClip
   {
      
      public static const NEUTRAL_DELTA:String = "equal";
      
      public static const POSITIVE_DELTA:String = "greater";
      
      public static const NEGATIVE_DELTA:String = "less";
      
      public static const POSITIVE_DELTA_INV:String = "greater_inverted";
      
      public static const NEGATIVE_DELTA_INV:String = "less_inverted";
      
      private static const VALUE_PRECISION:uint = 2;
      
      public static const ARROW_TEXT_OFFSET:* = 5;
       
      
      public var Text_mc:MovieClip;
      
      public var Arrow_mc:MovieClip;
      
      public var InvertComparison:Boolean = false;
      
      public function DeltaTextValue()
      {
         super();
      }
      
      public static function GetValueAndDelta(param1:Object, param2:Object, param3:String) : Object
      {
         var _loc4_:Object = new Object();
         var _loc5_:Number = param2 != null ? Number(param2[param3]) : 0;
         _loc4_.Value = param1 != null ? param1[param3] : 0;
         _loc4_.Delta = _loc4_.Value - _loc5_;
         return _loc4_;
      }
      
      private function get Value_tf() : TextField
      {
         return this.Text_mc.Text_tf;
      }
      
      private function GetFrameLabel(param1:Number) : String
      {
         var _loc2_:String = NEUTRAL_DELTA;
         if(param1 > 0)
         {
            _loc2_ = this.InvertComparison ? POSITIVE_DELTA_INV : POSITIVE_DELTA;
         }
         else if(param1 < 0)
         {
            _loc2_ = this.InvertComparison ? NEGATIVE_DELTA_INV : NEGATIVE_DELTA;
         }
         return _loc2_;
      }
      
      public function Update(param1:Number, param2:Number = 0, param3:uint = 2, param4:String = "", param5:Boolean = false, param6:Number = 3) : void
      {
         var _loc7_:String = null;
         gotoAndStop(this.GetFrameLabel(param2));
         if(param5 == true)
         {
            _loc7_ = TextUtils.TruncateNumericText(param1,param6,param4);
         }
         else
         {
            _loc7_ = GlobalFunc.FormatNumberToString(param1,param3) + param4;
         }
         GlobalFunc.SetText(this.Value_tf,_loc7_);
         if(this.Arrow_mc != null)
         {
            this.Arrow_mc.Internal_mc.x = this.Text_mc.x + this.Text_mc.Text_tf.textWidth + ARROW_TEXT_OFFSET;
         }
      }
      
      public function UpdateToDefaultText(param1:String) : void
      {
         gotoAndStop(this.GetFrameLabel(0));
         GlobalFunc.SetText(this.Value_tf,param1);
      }
   }
}

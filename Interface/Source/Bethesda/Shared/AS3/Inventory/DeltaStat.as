package Shared.AS3.Inventory
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DeltaStat extends MovieClip
   {
      
      private static const COMPARE_EQUAL:int = EnumHelper.GetEnum(1);
      
      private static const COMPARE_LESS:int = EnumHelper.GetEnum();
      
      private static const COMPARE_MORE:int = EnumHelper.GetEnum();
      
      private static const COMPARE_LESS_INVERT:int = EnumHelper.GetEnum();
      
      private static const COMPARE_MORE_INVERT:int = EnumHelper.GetEnum();
       
      
      public var Label_tf:TextField;
      
      public var Value_mc:MovieClip;
      
      public var Arrow_mc:MovieClip;
      
      public function DeltaStat()
      {
         super();
         Extensions.enabled = true;
      }
      
      public function get Value_tf() : TextField
      {
         return this.Value_mc.Text_tf;
      }
      
      public function SetData(param1:String, param2:String, param3:Number = 0, param4:Boolean = false, param5:uint = 0) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:TextLineMetrics = null;
         if(param5 == 0)
         {
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         else
         {
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_NONE);
            TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_NONE);
         }
         if(GlobalFunc.CloseToNumber(param3,0))
         {
            gotoAndStop(COMPARE_EQUAL);
         }
         else if(param3 < 0)
         {
            gotoAndStop(param4 ? COMPARE_LESS_INVERT : COMPARE_LESS);
         }
         else
         {
            gotoAndStop(param4 ? COMPARE_MORE_INVERT : COMPARE_MORE);
         }
         GlobalFunc.SetText(this.Label_tf,param1);
         GlobalFunc.SetText(this.Value_tf,param2,false,false,param5);
         _loc6_ = 5;
         var _loc8_:Number = ((_loc7_ = this.Value_tf.getLineMetrics(0)).x + _loc7_.width + _loc6_) / this.Arrow_mc.scaleX;
         this.Arrow_mc.Internal_mc.x = _loc8_;
      }
   }
}

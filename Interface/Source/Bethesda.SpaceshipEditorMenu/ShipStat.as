package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipStat extends ShipStatBase
   {
       
      
      public var Title_mc:MovieClip;
      
      public var Value_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public function ShipStat()
      {
         super();
      }
      
      private function get TitleText() : TextField
      {
         return this.Title_mc.text_tf;
      }
      
      private function get ValueText() : TextField
      {
         return this.Value_mc.Text_mc.text_tf;
      }
      
      public function SetTitle(param1:String) : void
      {
         GlobalFunc.SetText(this.TitleText,param1);
      }
      
      public function SetValue(param1:String, param2:Number) : void
      {
         GlobalFunc.SetText(this.ValueText,param1);
         this.UpdateArrow(param2);
      }
      
      public function UpdateArrow(param1:int) : *
      {
         if(param1 < 0)
         {
            this.Value_mc.gotoAndStop(VALUE_LESS);
            this.Value_mc.Arrow_mc.gotoAndStop(VALUE_LESS);
            this.Value_mc.Arrow_mc.x = this.Value_mc.Text_mc.text_tf.textWidth + PADDING;
         }
         else if(param1 > 0)
         {
            this.Value_mc.gotoAndStop(VALUE_GREATER);
            this.Value_mc.Arrow_mc.gotoAndStop(VALUE_GREATER);
            this.Value_mc.Arrow_mc.x = this.Value_mc.Text_mc.text_tf.textWidth + PADDING;
         }
         else
         {
            this.Value_mc.gotoAndStop(VALUE_EQUAL);
            this.Value_mc.Arrow_mc.gotoAndStop(VALUE_EQUAL);
         }
      }
      
      public function SetStatType(param1:int) : *
      {
         this.Icon_mc.visible = true;
         switch(param1)
         {
            case STAT_TYPE_REACTOR_A:
               this.Icon_mc.gotoAndStop(STAT_REACTOR_A);
               break;
            case STAT_TYPE_REACTOR_B:
               this.Icon_mc.gotoAndStop(STAT_REACTOR_B);
               break;
            case STAT_TYPE_REACTOR_C:
               this.Icon_mc.gotoAndStop(STAT_REACTOR_C);
               break;
            case STAT_TYPE_REACTOR_M:
               this.Icon_mc.gotoAndStop(STAT_REACTOR_M);
               break;
            case STAT_TYPE_MASS:
               this.Icon_mc.gotoAndStop(STAT_MASS);
               break;
            case STAT_TYPE_DAMAGE:
               this.Icon_mc.gotoAndStop(STAT_DAMAGE);
               break;
            case STAT_TYPE_HULL:
               this.Icon_mc.gotoAndStop(STAT_HULL);
               break;
            case STAT_TYPE_CARGO:
               this.Icon_mc.gotoAndStop(STAT_CARGO);
               break;
            case STAT_TYPE_CREW:
               this.Icon_mc.gotoAndStop(STAT_CREW);
               break;
            case STAT_TYPE_JUMP_RANGE:
               this.Icon_mc.gotoAndStop(STAT_JUMP_RANGE);
               break;
            case STAT_TYPE_SHIELD:
               this.Icon_mc.gotoAndStop(STAT_SHIELD);
               break;
            default:
               this.Icon_mc.visible = false;
         }
      }
   }
}

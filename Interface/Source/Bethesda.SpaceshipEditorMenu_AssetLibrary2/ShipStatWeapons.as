package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipStatWeapons extends ShipStatBase
   {
      
      private static const NUM_WEAPON_GROUPS:uint = 3;
       
      
      public var W0Title_mc:MovieClip;
      
      public var W0Value_mc:MovieClip;
      
      public var W1Title_mc:MovieClip;
      
      public var W1Value_mc:MovieClip;
      
      public var W2Title_mc:MovieClip;
      
      public var W2Value_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      private var WeaponClips:Array;
      
      private var WeaponTitles:Array;
      
      private var WeaponValues:Array;
      
      public function ShipStatWeapons()
      {
         super();
      }
      
      private function get W0TitleText() : TextField
      {
         return this.W0Title_mc.text_tf;
      }
      
      private function get W1TitleText() : TextField
      {
         return this.W1Title_mc.text_tf;
      }
      
      private function get W2TitleText() : TextField
      {
         return this.W2Title_mc.text_tf;
      }
      
      private function get W0ValueText() : TextField
      {
         return this.W0Value_mc.Text_mc.text_tf;
      }
      
      private function get W1ValueText() : TextField
      {
         return this.W1Value_mc.Text_mc.text_tf;
      }
      
      private function get W2ValueText() : TextField
      {
         return this.W2Value_mc.Text_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.WeaponClips = [this.W0Value_mc,this.W1Value_mc,this.W2Value_mc];
         this.WeaponTitles = [this.W0TitleText,this.W1TitleText,this.W2TitleText];
         this.WeaponValues = [this.W0ValueText,this.W1ValueText,this.W2ValueText];
         this.Icon_mc.gotoAndStop(STAT_DAMAGE);
      }
      
      public function SetTitle(param1:String, param2:uint) : void
      {
         GlobalFunc.SetText(this.WeaponTitles[param2],param1);
      }
      
      public function SetValue(param1:String, param2:int, param3:uint) : void
      {
         if(param3 < NUM_WEAPON_GROUPS)
         {
            GlobalFunc.SetText(this.WeaponValues[param3],param1);
            this.UpdateArrow(param2,param3);
         }
      }
      
      public function UpdateArrow(param1:int, param2:uint) : *
      {
         if(param1 < 0)
         {
            this.WeaponClips[param2].Arrow_mc.gotoAndStop(VALUE_LESS);
            this.WeaponClips[param2].gotoAndStop(VALUE_LESS);
         }
         else if(param1 > 0)
         {
            this.WeaponClips[param2].Arrow_mc.gotoAndStop(VALUE_GREATER);
            this.WeaponClips[param2].gotoAndStop(VALUE_GREATER);
         }
         else
         {
            this.WeaponClips[param2].Arrow_mc.gotoAndStop(VALUE_EQUAL);
            this.WeaponClips[param2].gotoAndStop(VALUE_EQUAL);
         }
         this.WeaponClips[param2].Arrow_mc.x = this.WeaponClips[param2].Text_mc.text_tf.textWidth + PADDING;
      }
   }
}

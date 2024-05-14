package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipStatsFooter extends BSDisplayObject
   {
      
      private static const LABEL_CHAR_LENGTH:* = 10;
      
      private static const VALUE_EQUAL:String = "equal";
      
      private static const VALUE_LESS:String = "less";
      
      private static const VALUE_GREATER:String = "greater";
      
      private static const VALUE_LESS_INVERTED:String = "less_inverted";
      
      private static const VALUE_GREATER_INVERTED:String = "greater_inverted";
      
      private static const PADDING:int = 4;
       
      
      public var Weapon1Title_mc:MovieClip;
      
      public var Weapon2Title_mc:MovieClip;
      
      public var Weapon3Title_mc:MovieClip;
      
      public var Weapon1Value_mc:MovieClip;
      
      public var Weapon2Value_mc:MovieClip;
      
      public var Weapon3Value_mc:MovieClip;
      
      public var HealthValue_mc:MovieClip;
      
      public var ShieldValue_mc:MovieClip;
      
      public var CargoValue_mc:MovieClip;
      
      public var CrewValue_mc:MovieClip;
      
      public var JumpRangeValue_mc:MovieClip;
      
      public var MobilityValue_mc:MovieClip;
      
      public var SpeedValue_mc:MovieClip;
      
      public var MassValue_mc:MovieClip;
      
      public var HealthLabel_mc:MovieClip;
      
      public var ShieldLabel_mc:MovieClip;
      
      public var CargoLabel_mc:MovieClip;
      
      public var CrewLabel_mc:MovieClip;
      
      public var JumpRangeLabel_mc:MovieClip;
      
      public var MobilityLabel_mc:MovieClip;
      
      public var SpeedLabel_mc:MovieClip;
      
      public var MassLabel_mc:MovieClip;
      
      public var WeaponTitles:Array;
      
      public var WeaponValues:Array;
      
      public function ShipStatsFooter()
      {
         this.WeaponTitles = new Array();
         this.WeaponValues = new Array();
         super();
      }
      
      private function get LargeTextMode() : Boolean
      {
         return false;
      }
      
      private function get HealthValueText() : TextField
      {
         return this.HealthValue_mc.Text_mc.text_tf;
      }
      
      private function get ShieldValueText() : TextField
      {
         return this.ShieldValue_mc.Text_mc.text_tf;
      }
      
      private function get CargoValueText() : TextField
      {
         return this.CargoValue_mc.Text_mc.text_tf;
      }
      
      private function get CrewValueText() : TextField
      {
         return this.CrewValue_mc.Text_mc.text_tf;
      }
      
      private function get JumpRangeValueText() : TextField
      {
         return this.JumpRangeValue_mc.Text_mc.text_tf;
      }
      
      private function get MobilityValueText() : TextField
      {
         return this.MobilityValue_mc.Text_mc.text_tf;
      }
      
      private function get SpeedValueText() : TextField
      {
         return this.SpeedValue_mc.Text_mc.text_tf;
      }
      
      private function get MassValueText() : TextField
      {
         return this.MassValue_mc.Text_mc.text_tf;
      }
      
      private function get HealthLabel() : TextField
      {
         return this.HealthLabel_mc.Text_tf;
      }
      
      private function get ShieldLabel() : TextField
      {
         return this.ShieldLabel_mc.Text_tf;
      }
      
      private function get CargoLabel() : TextField
      {
         return this.CargoLabel_mc.Text_tf;
      }
      
      private function get CrewLabel() : TextField
      {
         return this.CrewLabel_mc.Text_tf;
      }
      
      private function get JumpRangeLabel() : TextField
      {
         return this.JumpRangeLabel_mc.Text_tf;
      }
      
      private function get MobilityLabel() : TextField
      {
         return this.MobilityLabel_mc.Text_tf;
      }
      
      private function get SpeedLabel() : TextField
      {
         return this.SpeedLabel_mc.Text_tf;
      }
      
      private function get MassLabel() : TextField
      {
         return this.MassLabel_mc.Text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         this.WeaponTitles = [this.Weapon1Title_mc,this.Weapon2Title_mc,this.Weapon3Title_mc];
         this.WeaponValues = [this.Weapon1Value_mc,this.Weapon2Value_mc,this.Weapon3Value_mc];
         if(this.LargeTextMode)
         {
            this.TruncateTextCharLength(this.HealthLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.ShieldLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.CargoLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.CrewLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.JumpRangeLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.MobilityLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.SpeedLabel,LABEL_CHAR_LENGTH);
            this.TruncateTextCharLength(this.MassLabel,LABEL_CHAR_LENGTH);
         }
      }
      
      public function UpdateValues(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1.bShowingPreview);
         this.SetStatText(_loc2_,this.HealthValue_mc,this.HealthValueText,param1.iHealth,param1.iHealthDiff);
         this.SetStatText(_loc2_,this.ShieldValue_mc,this.ShieldValueText,param1.iShield,param1.iShieldDiff);
         this.SetStatText(_loc2_,this.CargoValue_mc,this.CargoValueText,param1.iCargo,param1.iCargoDiff);
         this.SetStatText(_loc2_,this.CrewValue_mc,this.CrewValueText,param1.iCrew,param1.iCrewDiff);
         this.SetStatText(_loc2_,this.JumpRangeValue_mc,this.JumpRangeValueText,param1.iJumpRange,param1.iJumpRangeDiff,false,"LY");
         this.SetStatText(_loc2_,this.MobilityValue_mc,this.MobilityValueText,param1.iMobility,param1.iMobilityDiff);
         this.SetStatText(_loc2_,this.SpeedValue_mc,this.SpeedValueText,param1.iSpeed,param1.iSpeedDiff);
         this.SetStatText(_loc2_,this.MassValue_mc,this.MassValueText,param1.iMass,param1.iMassDiff,true);
         var _loc3_:uint = 0;
         while(_loc3_ < param1.aWeaponGroupNames.length)
         {
            GlobalFunc.SetText(this.WeaponTitles[_loc3_].Text_tf,param1.aWeaponGroupNames[_loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.aWeaponGroupsDmg.length)
         {
            this.SetStatText(_loc2_,this.WeaponValues[_loc3_],this.WeaponValues[_loc3_].Text_mc.text_tf,param1.aWeaponGroupsDmg[_loc3_],param1.aWeaponGroupsDmgDiff[_loc3_]);
            _loc3_++;
         }
      }
      
      private function SetStatText(param1:Boolean, param2:MovieClip, param3:TextField, param4:Number, param5:Number, param6:Boolean = false, param7:String = "") : *
      {
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         if(!param1 || param5 == 0)
         {
            GlobalFunc.SetText(param3,GlobalFunc.FormatNumberToString(param4) + param7);
         }
         else
         {
            _loc8_ = param5 > 0 ? " +" : " -";
            _loc9_ = param4 - param5;
            GlobalFunc.SetText(param3,GlobalFunc.FormatNumberToString(_loc9_) + _loc8_ + GlobalFunc.FormatNumberToString(Math.abs(param5)) + param7);
         }
         this.UpdateArrows(param5,param2,param6);
      }
      
      public function UpdateArrows(param1:Number, param2:MovieClip, param3:Boolean = false) : *
      {
         var _loc4_:String = null;
         if(param1 < 0)
         {
            _loc4_ = !param3 ? VALUE_LESS : VALUE_LESS_INVERTED;
            param2.gotoAndStop(_loc4_);
            param2.Arrow_mc.gotoAndStop(_loc4_);
            param2.Arrow_mc.x = param2.Text_mc.text_tf.textWidth / 2 + PADDING;
         }
         else if(param1 > 0)
         {
            _loc4_ = !param3 ? VALUE_GREATER : VALUE_GREATER_INVERTED;
            param2.gotoAndStop(_loc4_);
            param2.Arrow_mc.gotoAndStop(_loc4_);
            param2.Arrow_mc.x = param2.Text_mc.text_tf.textWidth / 2 + PADDING;
         }
         else
         {
            _loc4_ = VALUE_EQUAL;
            param2.gotoAndStop(_loc4_);
            param2.Arrow_mc.gotoAndStop(_loc4_);
         }
      }
      
      private function TruncateTextCharLength(param1:TextField, param2:Number, param3:String = "…") : *
      {
         var _loc5_:uint = 0;
         trace(param1.text.length,param2,param1.text);
         var _loc4_:*;
         if(_loc4_ = param1.text.length > param2)
         {
            _loc5_ = param1.text.length - param2;
            param1.text = param1.text.substr(0,param1.text.length - _loc5_);
            if(param1.text.charAt(param1.length - 1) == " ")
            {
               param1.text = param1.text.slice(0,-1);
            }
            param1.appendText(param3);
            trace(param1.text.length,param2,param1.text);
         }
      }
   }
}

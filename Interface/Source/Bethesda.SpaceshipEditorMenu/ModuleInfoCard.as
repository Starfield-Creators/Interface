package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class ModuleInfoCard extends BSDisplayObject
   {
      
      private static const CREDIT_ENTRY:String = "Credit_StatEntry_";
      
      private static const CREDIT_NO_DESCRIPTION:String = "Credit_NoDescription_";
      
      private static const BUILD_ENTRY:String = "Build_StatEntry_";
      
      private static const RESOURCE_ENTRY:String = "Cost_StatEntry_";
      
      private static const DESCRIPTION_LINE_LENGTH:Number = 36;
      
      private static const MODULE_CLASS_TEXT:String = "$CLASS";
      
      private static const DEFAULT:String = "Default";
      
      private static const HIGHER_VALUE:String = "HigherValue";
      
      private static const LOWER_VALUE:String = "LowerValue";
      
      private static const MAX_STATS:* = 10;
       
      
      public var ModuleLabel_mc:MovieClip;
      
      public var Logo_mc:MovieClip;
      
      public var InfoCardContent_mc:MovieClip;
      
      private const MAX_SKILLS:Number = 2;
      
      public function ModuleInfoCard()
      {
         super();
      }
      
      private function get ModuleLabelText() : TextField
      {
         return this.ModuleLabel_mc.text_tf;
      }
      
      private function get DescriptionText() : TextField
      {
         return this.InfoCardContent_mc.Description_mc.text_tf;
      }
      
      private function get CostValueText() : TextField
      {
         return this.InfoCardContent_mc.CostValue_mc.text_tf;
      }
      
      private function get MassValueText() : TextField
      {
         return this.InfoCardContent_mc.MassValue_mc.text_tf;
      }
      
      private function get HealthValueText() : TextField
      {
         return this.InfoCardContent_mc.HealthValue_mc.text_tf;
      }
      
      private function get BuilderAnimString() : String
      {
         return CREDIT_ENTRY;
      }
      
      private function get ShowBuilderDescription() : Boolean
      {
         return true;
      }
      
      private function get ShouldTruncateDescription() : Boolean
      {
         return false;
      }
      
      override public function onAddedToStage() : void
      {
         this.visible = false;
      }
      
      public function UpdateValues(param1:Object, param2:Boolean) : *
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc10_:MovieClip = null;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:Object = null;
         GlobalFunc.SetText(this.ModuleLabelText,param1.sModuleName);
         GlobalFunc.SetText(this.CostValueText,GlobalFunc.FormatNumberToString(param1.iModuleCost));
         GlobalFunc.SetText(this.MassValueText,GlobalFunc.FormatNumberToString(param1.iModuleMass));
         var _loc3_:Array = param1.aStats;
         var _loc4_:int = 1;
         var _loc5_:int = Math.min(_loc3_.length,MAX_STATS);
         for each(_loc6_ in _loc3_)
         {
            if(_loc4_ > _loc5_)
            {
               break;
            }
            _loc10_ = this.InfoCardContent_mc["StatEntry" + _loc4_ + "_mc"];
            GlobalFunc.SetText(_loc10_.StatLabel_mc.text_tf,_loc6_.text);
            TextFieldEx.setTextAutoSize(_loc10_.StatLabel_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            if(_loc6_.text == MODULE_CLASS_TEXT)
            {
               GlobalFunc.SetText(_loc10_.StatValue_mc.text_tf,String.fromCharCode(_loc6_.fValue));
            }
            else if(_loc6_.bPercentage)
            {
               _loc12_ = _loc6_.fValue * 100;
               GlobalFunc.SetText(_loc10_.StatValue_mc.text_tf,GlobalFunc.FormatNumberToString(_loc12_) + "%");
            }
            else
            {
               GlobalFunc.SetText(_loc10_.StatValue_mc.text_tf,GlobalFunc.FormatNumberToString(_loc6_.fValue,2));
            }
            _loc11_ = DEFAULT;
            if(_loc6_.fDiff > 0)
            {
               _loc11_ = HIGHER_VALUE;
            }
            else if(_loc6_.fDiff < 0)
            {
               _loc11_ = LOWER_VALUE;
            }
            _loc10_.gotoAndStop(_loc11_);
            _loc10_.visible = true;
            _loc4_++;
         }
         _loc7_ = String((param2 ? this.BuilderAnimString : CREDIT_ENTRY) + _loc5_);
         var _loc8_:uint = 0;
         while(_loc8_ < this.numChildren)
         {
            if((_loc13_ = this.getChildAt(_loc8_)) is MovieClip)
            {
               (_loc13_ as MovieClip).gotoAndStop(_loc7_);
            }
            _loc8_++;
         }
         if(this.ShowBuilderDescription || !param2)
         {
            GlobalFunc.SetText(this.DescriptionText,param1.sDescription);
            if(this.ShouldTruncateDescription)
            {
               this.TruncateText(this.DescriptionText);
            }
         }
         this.SetLogo(param1.sLogoID);
         this.UpdateAttributes(param1.aRequiredAttributes);
         var _loc9_:int = Math.min(totalFrames,this.ModuleLabelText.numLines);
         this.ModuleLabel_mc.gotoAndStop(_loc9_);
         gotoAndStop(_loc9_);
         this.visible = param1.bShowWidget;
      }
      
      private function SetLogo(param1:String) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = "Empty";
         for each(_loc3_ in this.Logo_mc.currentLabels)
         {
            if(param1 == _loc3_.name)
            {
               _loc2_ = _loc3_.name;
               break;
            }
         }
         this.Logo_mc.gotoAndStop(_loc2_);
      }
      
      private function UpdateAttributes(param1:Array) : void
      {
         var _loc3_:ModuleAttributeIcon = null;
         this.InfoCardContent_mc.AttributeReqsSection_mc.gotoAndStop(param1.length + 1);
         var _loc2_:uint = 0;
         while(_loc2_ < this.MAX_SKILLS && _loc2_ < param1.length)
         {
            _loc3_ = _loc3_ = this.GetAttributeClip(_loc2_);
            _loc3_.LoadClip(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function GetAttributeClip(param1:uint) : ModuleAttributeIcon
      {
         return this.InfoCardContent_mc.AttributeReqsSection_mc["Attribute" + param1 + "_mc"];
      }
      
      private function TruncateText(param1:TextField, param2:String = "…") : *
      {
         var _loc3_:Boolean = param1.numLines > 3 || param1.getLineLength(param1.numLines - 1) > DESCRIPTION_LINE_LENGTH;
         if(_loc3_)
         {
            while(param1.numLines > 3 || param1.getLineLength(param1.numLines - 1) > DESCRIPTION_LINE_LENGTH)
            {
               param1.text = param1.text.substr(0,param1.text.length - 1);
            }
            while(param1.text.charAt(param1.length - 1) == " " || param1.text.charAt(param1.length - 1) == ".")
            {
               param1.text = param1.text.slice(0,-1);
            }
            param1.appendText(param2);
         }
      }
   }
}

package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SystemInfoCard extends BSDisplayObject
   {
      
      private static const CREDIT_ENTRY:String = "Credit_StatEntry_";
      
      private static const BUILD_ENTRY:String = "Build_StatEntry_";
      
      private static const RESOURCE_ENTRY:String = "Cost_StatEntry_";
      
      private static const MODULE_CLASS_TEXT:String = "$CLASS";
      
      private static const MAX_STATS:* = 10;
       
      
      public var ModuleLabel_mc:MovieClip;
      
      public var Logo_mc:MovieClip;
      
      public var InfoCardContent_mc:MovieClip;
      
      private const MAX_SKILLS:Number = 2;
      
      public function SystemInfoCard()
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
      
      override public function onAddedToStage() : void
      {
         this.visible = false;
         BSUIDataManager.Subscribe("ShipHangarModuleInfoData",this.onShipStatsDataUpdate);
      }
      
      private function onShipStatsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         this.UpdateValues(_loc2_);
      }
      
      public function UpdateValues(param1:Object) : *
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         GlobalFunc.SetText(this.ModuleLabelText,param1.sModuleName);
         GlobalFunc.SetText(this.CostValueText,GlobalFunc.FormatNumberToString(param1.iModuleCost));
         GlobalFunc.SetText(this.MassValueText,GlobalFunc.FormatNumberToString(param1.iModuleMass));
         GlobalFunc.SetText(this.DescriptionText,param1.sDescription);
         var _loc2_:Array = param1.aStats;
         var _loc3_:int = 1;
         var _loc4_:int = Math.min(_loc2_.length,MAX_STATS);
         for each(_loc5_ in _loc2_)
         {
            if(_loc3_ > _loc4_)
            {
               break;
            }
            _loc9_ = this.InfoCardContent_mc["StatEntry" + _loc3_ + "_mc"];
            GlobalFunc.SetText(_loc9_.StatLabel_mc.text_tf,_loc5_.text);
            if(_loc5_.text == MODULE_CLASS_TEXT)
            {
               GlobalFunc.SetText(_loc9_.StatValue_mc.text_tf,String.fromCharCode(_loc5_.fValue));
            }
            else if(_loc5_.bPercentage)
            {
               _loc10_ = _loc5_.fValue * 100;
               GlobalFunc.SetText(_loc9_.StatValue_mc.text_tf,GlobalFunc.FormatNumberToString(_loc10_) + "%");
            }
            else
            {
               GlobalFunc.SetText(_loc9_.StatValue_mc.text_tf,GlobalFunc.FormatNumberToString(_loc5_.fValue,2));
            }
            _loc9_.visible = true;
            _loc3_++;
         }
         _loc6_ = CREDIT_ENTRY + _loc4_;
         _loc7_ = 0;
         while(_loc7_ < this.numChildren)
         {
            if((_loc11_ = this.getChildAt(_loc7_)) is MovieClip)
            {
               (_loc11_ as MovieClip).gotoAndStop(_loc6_);
            }
            _loc7_++;
         }
         this.SetLogo(param1.sLogoID);
         this.UpdateAttributes(param1.aRequiredAttributes);
         var _loc8_:int = Math.min(totalFrames,this.ModuleLabelText.numLines);
         this.ModuleLabel_mc.gotoAndStop(_loc8_);
         gotoAndStop(_loc8_);
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
         var _loc3_:AttributeIcon = null;
         this.InfoCardContent_mc.AttributeReqsSection_mc.gotoAndStop(param1.length + 1);
         var _loc2_:uint = 0;
         while(_loc2_ < this.MAX_SKILLS && _loc2_ < param1.length)
         {
            _loc3_ = _loc3_ = this.GetAttributeClip(_loc2_);
            _loc3_.LoadClip(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function GetAttributeClip(param1:uint) : AttributeIcon
      {
         return this.InfoCardContent_mc.AttributeReqsSection_mc["Attribute" + param1 + "_mc"];
      }
   }
}

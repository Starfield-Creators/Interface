package Components.PlanetInfoCard
{
   import Components.LabeledMeterColorConfig;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class StarmapBodyDataInfo extends BodyDataInfo
   {
      
      public static const METER_TEXT:uint = 12040119;
      
      public static const METER_BACKGROUND:uint = 5131854;
      
      public static const METER_FILL:uint = 12961221;
       
      
      public var Trait1_mc:TraitsIcon;
      
      public var Trait2_mc:TraitsIcon;
      
      public var Trait3_mc:TraitsIcon;
      
      public var Trait4_mc:TraitsIcon;
      
      public var Trait5_mc:TraitsIcon;
      
      public var TraitsAmount_mc:MovieClip;
      
      public var TraitsHeader_mc:MovieClip;
      
      public var ResourcePanelMask_mc:MovieClip;
      
      public var TraitIcons:Array;
      
      public var UseTraitIcons:Boolean = false;
      
      public var ResourcePanelMaskOriginalWidth:Number = 0;
      
      public function StarmapBodyDataInfo()
      {
         this.TraitIcons = new Array();
         super();
         SurveyMeter_mc.SetColorConfig(new LabeledMeterColorConfig(METER_FILL,METER_FILL,METER_FILL,METER_FILL,METER_FILL,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_BACKGROUND));
         var _loc1_:int = 1;
         var _loc2_:TraitsIcon = this["Trait" + _loc1_ + "_mc"];
         while(_loc2_ != null)
         {
            this.TraitIcons.push(_loc2_);
            _loc1_++;
            _loc2_ = this["Trait" + _loc1_ + "_mc"];
         }
      }
      
      public function get IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         if(this.IsLargeTextMode)
         {
            this.ResourcePanelMaskOriginalWidth = this.ResourcePanelMask_mc.width;
         }
      }
      
      public function SetHoverNameplates(param1:MovieClip) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.TraitIcons.length)
         {
            this.TraitIcons[_loc2_].PlanetInfoHoverNameplate_mc = param1;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < Resources.length)
         {
            Resources[_loc3_].PlanetInfoHoverNameplate_mc = param1;
            _loc3_++;
         }
      }
      
      override protected function SetTraits(param1:Object) : *
      {
         var _loc2_:Boolean = this.UseTraitIcons && (Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL);
         PlanetTraits_mc.visible = !_loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < this.TraitIcons.length)
         {
            this.TraitIcons[_loc3_].visible = _loc2_;
            _loc3_++;
         }
         this.TraitsHeader_mc.visible = _loc2_;
         this.TraitsAmount_mc.visible = _loc2_;
         if(_loc2_)
         {
            this.SetTraitIcons(param1);
         }
         else
         {
            super.SetTraits(param1);
         }
      }
      
      private function SetTraitIcons(param1:Object) : *
      {
         var _loc3_:* = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.TraitTypesA.length)
         {
            (this.TraitIcons[_loc2_] as TraitsIcon).LoadIcon(param1.TraitsA[_loc2_],param1.TraitTypesA[_loc2_]);
            _loc2_++;
         }
         while(_loc2_ < param1.uTraitsTotal)
         {
            (this.TraitIcons[_loc2_] as TraitsIcon).ClearTrait();
            _loc2_++;
         }
         while(_loc2_ < this.TraitIcons.length)
         {
            (this.TraitIcons[_loc2_] as TraitsIcon).visible = false;
            _loc2_++;
         }
         if(param1.uTraitsTotal == 0)
         {
            this.TraitsHeader_mc.visible = false;
            this.TraitsAmount_mc.visible = false;
         }
         else
         {
            _loc3_ = "(" + param1.uTraitsCurrent + "/" + param1.uTraitsTotal + ")";
            GlobalFunc.SetText(this.TraitsAmount_mc.Text_tf,_loc3_);
         }
      }
      
      public function SetResourcePanelVisible(param1:Boolean) : *
      {
         if(this.IsLargeTextMode)
         {
            this.ResourcePanelMask_mc.width = param1 ? this.ResourcePanelMaskOriginalWidth : 0;
         }
      }
   }
}

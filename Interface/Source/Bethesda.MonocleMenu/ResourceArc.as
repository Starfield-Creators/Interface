package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class ResourceArc extends BSDisplayObject
   {
      
      private static const FONT_TAG_NORMAL_OPEN:String = "<font size=\'18\'>";
      
      private static const FONT_TAG_SUBSCRIPT_OPEN:String = "<font size=\'12\'>";
      
      private static const FONT_TAG_CLOSE:String = "</font>";
      
      private static const DISABLED_COLOR:uint = 3752531;
       
      
      public var ArcCommon_mc:MovieClip;
      
      public var ArcUncommon_mc:MovieClip;
      
      public var ArcRare_mc:MovieClip;
      
      public var ArcExotic_mc:MovieClip;
      
      public var ArcUnique_mc:MovieClip;
      
      private var CommonSlotsArray:*;
      
      private var UncommonSlotsArray:Array;
      
      private var RareSlotsArray:Array;
      
      private var ExoticSlotsArray:Array;
      
      private var UniqueSlotsArray:Array;
      
      private var SpecialSlotsArray:Array;
      
      public function ResourceArc()
      {
         super();
         this.CommonSlotsArray = [this.ArcCommon_mc.slot0,this.ArcCommon_mc.slot1,this.ArcCommon_mc.slot2,this.ArcCommon_mc.slot3,this.ArcCommon_mc.slot4,this.ArcCommon_mc.slot5,this.ArcCommon_mc.slot6];
         this.UncommonSlotsArray = [this.ArcUncommon_mc.slot0,this.ArcUncommon_mc.slot1,this.ArcUncommon_mc.slot2,this.ArcUncommon_mc.slot3,this.ArcUncommon_mc.slot4,this.ArcUncommon_mc.slot5,this.ArcUncommon_mc.slot6];
         this.RareSlotsArray = [this.ArcRare_mc.slot0,this.ArcRare_mc.slot1,this.ArcRare_mc.slot2,this.ArcRare_mc.slot3,this.ArcRare_mc.slot4,this.ArcRare_mc.slot5];
         this.ExoticSlotsArray = [this.ArcExotic_mc.slot0,this.ArcExotic_mc.slot1,this.ArcExotic_mc.slot2,this.ArcExotic_mc.slot3,this.ArcExotic_mc.slot4];
         this.UniqueSlotsArray = [this.ArcUnique_mc.slot0,this.ArcUnique_mc.slot1,this.ArcUnique_mc.slot2,this.ArcUnique_mc.slot3,this.ArcUnique_mc.slot4];
         this.SpecialSlotsArray = [this.ArcCommon_mc.slot5,this.ArcCommon_mc.slot6,this.ArcUncommon_mc.slot5,this.ArcUncommon_mc.slot6,this.ArcRare_mc.slot5];
         addEventListener("ShowCommonLabel",this.onShowCommonLabel);
         addEventListener("ShowCommonEntry",this.onShowCommonEntry);
         addEventListener("ShowUncommonLabel",this.onShowUncommonLabel);
         addEventListener("ShowUncommonEntry",this.onShowUncommonEntry);
         addEventListener("ShowRareLabel",this.onShowRareLabel);
         addEventListener("ShowRareEntry",this.onShowRareEntry);
         addEventListener("ShowExoticLabel",this.onShowExoticLabel);
         addEventListener("ShowExoticEntry",this.onShowExoticEntry);
         addEventListener("ShowUniqueLabel",this.onShowUniqueLabel);
         addEventListener("ShowUniqueEntry",this.onShowUniqueEntry);
         addEventListener("OpenResourceArc",this.onOpenResource);
         addEventListener("CloseResourceArc",this.onCloseResource);
      }
      
      private function onShowCommonLabel(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource1Common");
      }
      
      private function onShowCommonEntry(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource1CommonPing");
      }
      
      private function onShowUncommonLabel(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource2Uncommon");
      }
      
      private function onShowUncommonEntry(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource2UncommonPing");
      }
      
      private function onShowRareLabel(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource3Rare");
      }
      
      private function onShowRareEntry(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource3RarePing");
      }
      
      private function onShowExoticLabel(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource4Exotic");
      }
      
      private function onShowExoticEntry(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource4ExoticPing");
      }
      
      private function onShowUniqueLabel(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource5Unique");
      }
      
      private function onShowUniqueEntry(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerResource5UniquePing");
      }
      
      private function onOpenResource(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerOpen");
      }
      
      private function onCloseResource(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapScannerClose");
      }
      
      private function PlayAnimation(param1:String) : *
      {
         gotoAndPlay(param1);
         this.ArcCommon_mc.gotoAndPlay(param1);
         this.ArcUncommon_mc.gotoAndPlay(param1);
         this.ArcRare_mc.gotoAndPlay(param1);
         this.ArcExotic_mc.gotoAndPlay(param1);
         this.ArcUnique_mc.gotoAndPlay(param1);
      }
      
      private function UpdateResourceArc(param1:Array, param2:Array, param3:Boolean = true) : *
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc4_:* = new ColorTransform();
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            if((_loc6_ = param2[_loc5_]) != null)
            {
               _loc7_ = param1[_loc5_];
               _loc8_ = this.FormatShortName(_loc6_.sSymbol);
               _loc7_.gotoAndStop(!!_loc6_.bDisabled ? "Unknown" : "Known");
               _loc9_ = 10;
               GlobalFunc.SetText(_loc7_.element_mc.symbol_tf,_loc8_,true);
               GlobalFunc.SetText(_loc7_.element_mc.name_tf,_loc6_.sName,false,false,_loc9_);
               _loc4_.color = !!_loc6_.bDisabled ? DISABLED_COLOR : _loc6_.uColor;
               _loc7_.color_mc.transform.colorTransform = _loc4_;
               _loc7_.Tagged_mc.visible = _loc6_.bIsTrackedForCrafting;
               _loc7_.visible = true;
            }
            else if(param3)
            {
               param1[_loc5_].visible = false;
            }
            _loc5_++;
         }
      }
      
      private function FormatShortName(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:* = false;
         var _loc2_:String = FONT_TAG_NORMAL_OPEN;
         var _loc3_:Boolean = false;
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.charAt(_loc4_);
            if((_loc6_ = !isNaN(Number(_loc5_))) && !_loc3_)
            {
               _loc2_ += FONT_TAG_CLOSE + FONT_TAG_SUBSCRIPT_OPEN;
            }
            else if(!_loc6_ && _loc3_)
            {
               _loc2_ += FONT_TAG_CLOSE + FONT_TAG_NORMAL_OPEN;
            }
            _loc2_ += _loc5_;
            _loc3_ = _loc6_;
            _loc4_++;
         }
         return _loc2_ + FONT_TAG_CLOSE;
      }
      
      public function SetResourceArcInfo(param1:Object) : *
      {
         this.UpdateResourceArc(this.CommonSlotsArray,param1.aCommonResources);
         this.UpdateResourceArc(this.UncommonSlotsArray,param1.aUncommonResources);
         this.UpdateResourceArc(this.RareSlotsArray,param1.aRareResources);
         this.UpdateResourceArc(this.ExoticSlotsArray,param1.aExoticResources);
         this.UpdateResourceArc(this.UniqueSlotsArray,param1.aUniqueResources);
         this.UpdateResourceArc(this.SpecialSlotsArray,param1.aSpecialResources,false);
      }
      
      public function Open() : *
      {
         this.visible = true;
         this.PlayAnimation("open");
      }
      
      public function Close() : *
      {
         this.PlayAnimation("close");
      }
   }
}

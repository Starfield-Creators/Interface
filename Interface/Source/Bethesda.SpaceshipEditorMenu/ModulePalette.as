package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.BSInputDefines;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class ModulePalette extends BSDisplayObject
   {
      
      private static const NORMAL:String = "Normal";
      
      private static const ACTIVE:String = "Active";
       
      
      public var ModuleHeader_mc:MovieClip;
      
      public var ModuleSmallInfoHeader1_mc:MovieClip;
      
      public var ModuleMediumInfoHeader_mc:MovieClip;
      
      public var ModuleEntries_mc:BSScrollingContainer;
      
      public var ModulePaletteCategories_mc:ModulePaletteCategories;
      
      public var ModulePaletteSingleCategory_mc:MovieClip;
      
      private var IsUpgradeMode:Boolean = false;
      
      public function ModulePalette()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "ModulePaletteEntry";
         _loc1_.DisableInput = false;
         _loc1_.DisableSelection = false;
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         _loc1_.StageScroll = true;
         this.ModuleEntries_mc.Configure(_loc1_);
         this.ModuleMediumInfoHeader_mc.visible = false;
         this.ModuleSmallInfoHeader1_mc.visible = true;
      }
      
      private function get ModuleHeaderText() : TextField
      {
         return this.ModuleHeader_mc.Text_mc.text_tf;
      }
      
      private function get ModuleSmallInfo1Text() : TextField
      {
         return this.ModuleSmallInfoHeader1_mc.Text_mc.text_tf;
      }
      
      private function get ModuleMediumInfoText() : TextField
      {
         return this.ModuleMediumInfoHeader_mc.Text_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         this.ModuleEntries_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onListEntrySelected);
         this.ModuleEntries_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onListSelectionChanged);
         addEventListener(ChangeCategoryButton.CHANGE_CATEGORY_CLICKED_EVENT,this.onCategoryChangedEvent);
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         if(this.ModuleEntries_mc.disableInput)
         {
            return false;
         }
         if(param4)
         {
            if(param6 == BSInputDefines.DV_UP)
            {
               this.ModuleEntries_mc.MoveSelection(-1);
            }
            else if(param6 == BSInputDefines.DV_DOWN)
            {
               this.ModuleEntries_mc.MoveSelection(1);
            }
         }
         return true;
      }
      
      public function Update(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1.bShowWidget);
         var _loc3_:int = int(param1.iStartingIndex);
         this.IsUpgradeMode = param1.bIsUpgradeMode;
         this.ModuleEntries_mc.visible = _loc2_;
         if(_loc2_)
         {
            stage.focus = this.ModuleEntries_mc;
            GlobalFunc.SetText(this.ModuleHeaderText,param1.sCategoryName);
            GlobalFunc.SetText(this.ModuleSmallInfo1Text,param1.sStatName1);
            if(!this.IsUpgradeMode)
            {
               this.ModulePaletteCategories_mc.visible = true;
               this.ModulePaletteSingleCategory_mc.visible = false;
               this.ModulePaletteCategories_mc.SetCategoryNames(param1.sCategoryName,param1.sPrevCategoryName,param1.sNextCategoryName);
               this.ModulePaletteCategories_mc.SetCategoryIndex(param1.iCategoryIndex);
            }
            else
            {
               this.ModulePaletteCategories_mc.visible = false;
               this.ModulePaletteSingleCategory_mc.visible = true;
               GlobalFunc.SetText(this.ModulePaletteSingleCategory_mc.Text_mc.text_tf,param1.sCategoryName,false,false,0,true);
            }
            this.ModuleEntries_mc.InitializeEntries(param1.aPartList);
            if(_loc3_ > -1)
            {
               this.ModuleEntries_mc.selectedIndex = _loc3_;
            }
            else
            {
               this.ModuleEntries_mc.MoveSelection(0);
            }
         }
         else
         {
            stage.focus = null;
         }
      }
      
      public function onListEntrySelected() : void
      {
         var _loc1_:* = this.ModuleEntries_mc.selectedEntry;
         if(_loc1_.uFormID != null)
         {
            if(!this.IsUpgradeMode)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_SelectedShipPart",{"uFormID":_loc1_.uFormID}));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_SelectedUpgrade",{"uFormID":_loc1_.uFormID}));
            }
         }
         GlobalFunc.PlayMenuSound("UIMenuGeneralOK");
      }
      
      public function onListSelectionChanged() : void
      {
         if(this.ModuleEntries_mc.visible == false)
         {
            return;
         }
         var _loc1_:* = this.ModuleEntries_mc.selectedEntry;
         if(_loc1_.uFormID != null)
         {
            if(!this.IsUpgradeMode)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_PreviewShipPart",{"uFormID":_loc1_.uFormID}));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_PreviewUpgrade",{"uFormID":_loc1_.uFormID}));
            }
         }
         GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
      }
      
      public function onCategoryChangedEvent(param1:CustomEvent) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_ChangeModuleCategory",{"iCategoryOffset":param1.params.aOffset}));
      }
      
      public function SelectedEntryChangeVariant(param1:Number, param2:String, param3:Object) : void
      {
         var _loc5_:ModulePaletteEntry = null;
         var _loc4_:int = this.ModuleEntries_mc.totalEntryClips;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if((_loc5_ = this.ModuleEntries_mc.GetClipByIndex(_loc6_) as ModulePaletteEntry).Module_mc.currentFrameLabel == _loc5_.selectedFrameLabel)
            {
               _loc5_.UpdateVariantData(param1,param2,param3);
               break;
            }
            _loc6_++;
         }
      }
   }
}

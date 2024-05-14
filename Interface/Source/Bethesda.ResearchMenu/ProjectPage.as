package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ProjectPage extends MovieClip
   {
       
      
      public var ProjectHeader_mc:MovieClip;
      
      public var Materials_mc:MovieClip;
      
      public var Description_mc:MovieClip;
      
      public var InputAmount_mc:MovieClip;
      
      public var InventoryAmount_mc:MovieClip;
      
      public var RequiredSkills_mc:MovieClip;
      
      public var ResearchTree_mc:ResearchTree;
      
      public var MissingRequirements_mc:MovieClip;
      
      private var _addButtonDisabled:Boolean = false;
      
      private var _pageOpen:Boolean = false;
      
      private var _needsUpdate:Boolean = false;
      
      private var _trackingActive:Boolean = false;
      
      private var _canTrack:Boolean = false;
      
      private var _materialSortType:uint;
      
      private var _missingRequirements:Boolean = false;
      
      private var _projectData:Object = null;
      
      public function ProjectPage()
      {
         this._materialSortType = ResearchUtils.MATERIAL_SORT_DEFAULT;
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = ResearchUtils.MATERIAL_LIST_SPACING;
         _loc1_.EntryClassName = "MaterialsList_Entry";
         this.MaterialsList_mc.Configure(_loc1_);
         GlobalFunc.SetText(this.MaterialHeader_mc.Text_tf,"$Research_Materials");
         GlobalFunc.SetText(this.DescriptionHeader_mc.Text_tf,"$Description");
         GlobalFunc.SetText(this.InputHeader_mc.Text_tf,"$InputAmount");
         GlobalFunc.SetText(this.InventoryHeader_mc.Text_tf,"$Inventory");
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.AddToMaterial);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      public function get ProjectHeaderName_mc() : MovieClip
      {
         return this.ProjectHeader_mc.ProjectHeaderName_mc;
      }
      
      public function get ProjectHeaderProgress_mc() : MovieClip
      {
         return this.ProjectHeader_mc.ProjectHeaderProgress_mc;
      }
      
      public function get MaterialHeader_mc() : MovieClip
      {
         return this.Materials_mc.MaterialsHeader_mc;
      }
      
      public function get MaterialsListHeader_mc() : MovieClip
      {
         return this.Materials_mc.MaterialsListHeader_mc;
      }
      
      public function get MaterialsList_mc() : BSScrollingContainer
      {
         return this.Materials_mc.MaterialsList_mc;
      }
      
      public function get DescriptionHeader_mc() : MovieClip
      {
         return this.Description_mc.DescriptionHeader_mc;
      }
      
      public function get DescriptionSubHeader_mc() : MovieClip
      {
         return this.Description_mc.DescriptionSubHeader_mc;
      }
      
      public function get DescriptionText_mc() : MovieClip
      {
         return this.Description_mc.DescriptionText_mc;
      }
      
      public function get InputHeader_mc() : MovieClip
      {
         return this.InputAmount_mc.Header_mc;
      }
      
      public function get InputAmountText_mc() : MovieClip
      {
         return this.InputAmount_mc.Amount_mc;
      }
      
      public function get InventoryHeader_mc() : MovieClip
      {
         return this.InventoryAmount_mc.Header_mc;
      }
      
      public function get InventoryAmountText_mc() : MovieClip
      {
         return this.InventoryAmount_mc.Amount_mc;
      }
      
      public function get addButtonDisabled() : Boolean
      {
         return this._addButtonDisabled;
      }
      
      public function set addButtonDisabled(param1:Boolean) : void
      {
         if(this._addButtonDisabled != param1)
         {
            this._addButtonDisabled = param1;
            dispatchEvent(new Event(ResearchUtils.REFRESH_BUTTON_BAR,true,true));
         }
      }
      
      public function set pageOpen(param1:Boolean) : void
      {
         this._pageOpen = param1;
         this.UpdatePage();
      }
      
      public function set needsUpdate(param1:Boolean) : void
      {
         this._needsUpdate = param1;
         this.UpdatePage();
      }
      
      private function RefreshTracking() : void
      {
         var _loc1_:Boolean = this._canTrack;
         var _loc2_:Boolean = this._trackingActive;
         this._canTrack = this._projectData != null && this._pageOpen && this._projectData.fProgressPercentage < 1;
         this._trackingActive = this._projectData != null && Boolean(this._projectData.bTracking);
         if(_loc1_ != this._canTrack || _loc2_ != this._trackingActive)
         {
            dispatchEvent(new Event(ResearchUtils.REFRESH_BUTTON_BAR,true,true));
         }
      }
      
      public function Open() : void
      {
         this.pageOpen = true;
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
         this.MaterialsList_mc.selectedIndex = this._missingRequirements ? -1 : 0;
      }
      
      public function Close() : void
      {
         this.pageOpen = false;
         this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
         if(this._missingRequirements)
         {
            this.MissingRequirements_mc.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
         }
      }
      
      public function PopulateProjectPage(param1:Object) : void
      {
         this._projectData = param1;
         this.needsUpdate = true;
      }
      
      private function UpdatePage() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = false;
         var _loc3_:Number = NaN;
         if(this._projectData != null && this._pageOpen && this._needsUpdate)
         {
            _loc1_ = Boolean(this._projectData.bIsLocked) || !this._projectData.bHasRequiredSkills;
            _loc2_ = this._missingRequirements != _loc1_;
            this._missingRequirements = _loc1_;
            GlobalFunc.SetText(this.ProjectHeaderName_mc.Text_tf,this._projectData.sName);
            _loc3_ = GlobalFunc.RoundDecimal(this._projectData.fProgressPercentage * 100,0);
            GlobalFunc.SetText(this.ProjectHeaderProgress_mc.Text_tf,_loc3_ + "%");
            GlobalFunc.SetText(this.DescriptionSubHeader_mc.Text_tf,this._projectData.sName);
            GlobalFunc.SetText(this.DescriptionText_mc.Text_tf,this._projectData.sDescription);
            this.MaterialsList_mc.InitializeEntries(this._projectData.aMaterialRequirements);
            if(this.MaterialsList_mc.selectedIndex < 0 || this.MaterialsList_mc.selectedIndex >= this._projectData.aMaterialRequirements.length || _loc2_)
            {
               this.MaterialsList_mc.selectedIndex = this._missingRequirements ? -1 : 0;
            }
            if(this._missingRequirements)
            {
               this.addButtonDisabled = true;
            }
            this.SortMaterials();
            this.RequiredSkills_mc.UpdateSkills(this._projectData.aSkillRequirements);
            this.ResearchTree_mc.UpdateTreeData(this._projectData,!this._projectData.bIsLocked);
            this.RefreshTracking();
            if(this._missingRequirements && this.MissingRequirements_mc.currentFrameLabel != ResearchUtils.ON_FRAME_LABEL)
            {
               this.MissingRequirements_mc.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
            }
            else if(!this._missingRequirements && this.MissingRequirements_mc.currentFrameLabel != ResearchUtils.OFF_FRAME_LABEL)
            {
               this.MissingRequirements_mc.gotoAndStop(ResearchUtils.OFF_FRAME_LABEL);
            }
            this.MaterialsList_mc.disableInput = this._missingRequirements;
            this.MaterialsList_mc.disableSelection = this._missingRequirements;
            this.needsUpdate = false;
         }
      }
      
      public function ToggleTracking() : void
      {
         if(this._canTrack)
         {
            GlobalFunc.PlayMenuSound(this._trackingActive ? "UIMenuInventoryItemTagOff" : "UIMenuInventoryItemTagOn");
            BSUIDataManager.dispatchEvent(new Event("ResearchMenu_ToggleTrackingProject"));
         }
      }
      
      public function GetTrackingButtonText() : String
      {
         var _loc1_:String = "";
         if(this._canTrack)
         {
            _loc1_ = this._trackingActive ? "$UNTRACK PROJECT" : "$TRACK PROJECT";
         }
         return _loc1_;
      }
      
      public function NextSortType() : void
      {
         switch(this._materialSortType)
         {
            case ResearchUtils.MATERIAL_SORT_DEFAULT:
               this._materialSortType = ResearchUtils.MATERIAL_SORT_NAME;
               break;
            case ResearchUtils.MATERIAL_SORT_NAME:
               this._materialSortType = ResearchUtils.MATERIAL_SORT_INPUT;
               break;
            case ResearchUtils.MATERIAL_SORT_INPUT:
               this._materialSortType = ResearchUtils.MATERIAL_SORT_DEFAULT;
         }
         this.SortMaterials();
      }
      
      private function SortMaterials() : void
      {
         switch(this._materialSortType)
         {
            case ResearchUtils.MATERIAL_SORT_DEFAULT:
               this.MaterialsList_mc.SortEntriesOn("uDefaultSortIndex",Array.NUMERIC);
               break;
            case ResearchUtils.MATERIAL_SORT_NAME:
               this.MaterialsList_mc.SortEntriesOn("sName",Array.CASEINSENSITIVE);
               break;
            case ResearchUtils.MATERIAL_SORT_INPUT:
               this.MaterialsList_mc.SortEntries(this.MaterialInputCompareFunc);
         }
         this.MaterialsListHeader_mc.NameSort_mc.visible = this._materialSortType == ResearchUtils.MATERIAL_SORT_NAME;
         this.MaterialsListHeader_mc.InputSort_mc.visible = this._materialSortType == ResearchUtils.MATERIAL_SORT_INPUT;
      }
      
      private function MaterialInputCompareFunc(param1:*, param2:*) : int
      {
         var _loc3_:* = param1.uInputAmount == param1.uTotalRequiredAmount;
         var _loc4_:* = param2.uInputAmount == param2.uTotalRequiredAmount;
         var _loc5_:int = 0;
         if(_loc3_ && !_loc4_)
         {
            _loc5_ = 1;
         }
         else if(!_loc3_ && _loc4_)
         {
            _loc5_ = -1;
         }
         else if(param1.uInputAmount > param2.uInputAmount)
         {
            _loc5_ = -1;
         }
         else if(param1.uInputAmount < param2.uInputAmount)
         {
            _loc5_ = 1;
         }
         return _loc5_;
      }
      
      public function GetSortButtonText() : String
      {
         var _loc1_:String = "";
         switch(this._materialSortType)
         {
            case ResearchUtils.MATERIAL_SORT_DEFAULT:
               _loc1_ = "$RESEARCH_SORT_DEFAULT";
               break;
            case ResearchUtils.MATERIAL_SORT_NAME:
               _loc1_ = "$RESEARCH_SORT_NAME";
               break;
            case ResearchUtils.MATERIAL_SORT_INPUT:
               _loc1_ = "$RESEARCH_SORT_INPUT_AMOUNT";
         }
         return _loc1_;
      }
      
      private function PlayFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(ResearchUtils.FOCUS_SOUND);
      }
      
      private function OnSelectionChange() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc1_:Object = this.MaterialsList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.uTotalRequiredAmount - _loc1_.uInputAmount;
            _loc3_ = Math.min(_loc1_.uInventoryAmount,_loc2_);
            this.addButtonDisabled = _loc3_ <= 0 || this._missingRequirements;
            GlobalFunc.SetText(this.InputAmountText_mc.Text_tf,GlobalFunc.PadNumber(_loc1_.uInputAmount,ResearchUtils.NUMBER_PADDING));
            GlobalFunc.SetText(this.InventoryAmountText_mc.Text_tf,GlobalFunc.PadNumber(_loc1_.uInventoryAmount,ResearchUtils.NUMBER_PADDING));
         }
      }
      
      public function AddToMaterial() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc1_:Object = this.MaterialsList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.uTotalRequiredAmount - _loc1_.uInputAmount;
            _loc3_ = Math.min(_loc1_.uInventoryAmount,_loc2_);
            if(_loc3_ > 0)
            {
               GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
               dispatchEvent(new CustomEvent(ResearchUtils.SHOW_VOLUME_POPUP,{
                  "maxAmount":_loc3_,
                  "materialID":_loc1_.uFormID,
                  "inventoryAmount":_loc1_.uInventoryAmount,
                  "materialName":_loc1_.sName
               },true,true));
            }
         }
      }
   }
}

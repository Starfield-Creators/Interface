package
{
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CategoryPage extends MovieClip
   {
       
      
      public var ProjectListSection_mc:MovieClip;
      
      public var ModelBorder_mc:MovieClip;
      
      public var ModelBounds_mc:BSAnimating3DSceneRect;
      
      public var ResearchMaterials_mc:MovieClip;
      
      public var RequiredSkills_mc:ResearchSkillsSection;
      
      public var ResearchTree_mc:ResearchTree;
      
      private const PROJECT_STATE_NEW:int = EnumHelper.GetEnum(0);
      
      private const PROJECT_STATE_NOT_STARTED:int = EnumHelper.GetEnum();
      
      private const PROJECT_STATE_IN_PROGRESS:int = EnumHelper.GetEnum();
      
      private const PROJECT_STATE_BLOCKED:int = EnumHelper.GetEnum();
      
      private const PROJECT_STATE_COMPLETE:int = EnumHelper.GetEnum();
      
      private var _projectSortType:uint;
      
      private var _pageOpen:Boolean = false;
      
      private var _trackingActive:Boolean = false;
      
      private var _projectFilterType:uint;
      
      private var _selectButtonDisabled:Boolean = false;
      
      public function CategoryPage()
      {
         var configParams:BSScrollingConfigParams;
         this._projectSortType = ResearchUtils.PROJECT_SORT_DEFAULT;
         this._projectFilterType = ResearchUtils.PROJECT_FILTER_UNLOCKED_ONLY;
         super();
         this.ModelBounds_mc.SetBackgroundColor(1650942463);
         BS3DSceneRectManager.Register3DSceneRect(this.ModelBounds_mc);
         GlobalFunc.SetText(this.ListHeader_mc.Text_tf,"$Research_Projects");
         GlobalFunc.SetText(this.MaterialsHeader_mc.Text_tf,"$RequiredMaterials");
         configParams = new BSScrollingConfigParams();
         configParams.VerticalSpacing = ResearchUtils.PROJECT_LIST_SPACING;
         configParams.EntryClassName = "ProjectList_Entry";
         this.ProjectList_mc.Configure(configParams);
         this.ProjectList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            var _loc2_:* = true;
            switch(_projectFilterType)
            {
               case ResearchUtils.PROJECT_FILTER_UNLOCKED_ONLY:
                  _loc2_ = !param1.bIsLocked;
                  break;
               case ResearchUtils.PROJECT_FILTER_HIDE_COMPLETED:
                  _loc2_ = param1.fProgressPercentage < 1;
                  break;
               case ResearchUtils.PROJECT_FILTER_CAN_COMPLETE:
                  _loc2_ = param1.fProgressPercentage < 1 && !param1.bIsLocked && Boolean(param1.bHasRequiredSkills) && Boolean(param1.bHasAllMaterials);
                  break;
               case ResearchUtils.RESEARCH_FILTER_CAN_CONTRIBUTE:
                  _loc2_ = param1.fProgressPercentage < 1 && !param1.bIsLocked && Boolean(param1.bHasRequiredSkills) && Boolean(param1.bHasAnyMaterials);
                  break;
               case ResearchUtils.PROJECT_FILTER_CAN_PROGRESS:
                  _loc2_ = param1.fProgressPercentage < 1 && !param1.bIsLocked && Boolean(param1.bHasRequiredSkills);
                  break;
               case ResearchUtils.PROJECT_FILTER_COMPLETED_ONLY:
                  _loc2_ = param1.fProgressPercentage >= 1;
            }
            return _loc2_;
         });
      }
      
      public function get ProjectList_mc() : ProjectsList
      {
         return this.ProjectListSection_mc.ProjectList_mc;
      }
      
      public function get ListHeader_mc() : MovieClip
      {
         return this.ProjectListSection_mc.Header_mc;
      }
      
      public function get SortHeader_mc() : MovieClip
      {
         return this.ProjectListSection_mc.SortHeader_mc;
      }
      
      public function get MaterialsHeader_mc() : MovieClip
      {
         return this.ResearchMaterials_mc.Header_mc;
      }
      
      public function get projectFilterType() : uint
      {
         return this._projectFilterType;
      }
      
      public function get selectButtonDisabled() : Boolean
      {
         return this._selectButtonDisabled;
      }
      
      public function set selectButtonDisabled(param1:Boolean) : void
      {
         if(this._selectButtonDisabled != param1)
         {
            this._selectButtonDisabled = param1;
            dispatchEvent(new Event(ResearchUtils.REFRESH_BUTTON_BAR,true,true));
         }
      }
      
      public function Open() : void
      {
         this._pageOpen = true;
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.ProjectPressed);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         this.RequestDetails();
         this.SetInspectControls();
         this.ModelBounds_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnModelMouseRollOut);
         this.ModelBounds_mc.addEventListener(MouseEvent.ROLL_OVER,this.OnModelMouseRollOver);
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
      }
      
      public function Close() : void
      {
         this._pageOpen = false;
         removeEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         removeEventListener(ScrollingEvent.ITEM_PRESS,this.ProjectPressed);
         removeEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         this.ModelBounds_mc.removeEventListener(MouseEvent.ROLL_OUT,this.OnModelMouseRollOut);
         this.ModelBounds_mc.removeEventListener(MouseEvent.ROLL_OVER,this.OnModelMouseRollOver);
         this.SetInspectControls();
         this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
      }
      
      public function UpdateProjectsList(param1:Array) : void
      {
         var _loc2_:uint = 0;
         if(this.ProjectList_mc.selectedEntry != null)
         {
            _loc2_ = uint(this.ProjectList_mc.selectedEntry.uID);
         }
         this.ProjectList_mc.InitializeEntries(param1);
         if(this.ProjectList_mc.selectedIndex < 0 || this.ProjectList_mc.selectedIndex >= param1.length)
         {
            this.ProjectList_mc.selectedIndex = 0;
         }
         this.SortProjects();
         if(_loc2_ != 0)
         {
            if(!this.ProjectList_mc.SetSelectedProject(_loc2_))
            {
               this.ProjectList_mc.selectedIndex = 0;
            }
         }
      }
      
      public function UpdateProjectDetails(param1:Object) : void
      {
         this._trackingActive = param1.bTracking;
         dispatchEvent(new Event(ResearchUtils.REFRESH_BUTTON_BAR,true,true));
         this.UpdateMaterials(param1.aMaterialRequirements);
         this.RequiredSkills_mc.UpdateSkills(param1.aSkillRequirements);
         this.ResearchTree_mc.UpdateTreeData(param1,this.ProjectList_mc.selectedEntry != null && !this.ProjectList_mc.selectedEntry.bIsLocked);
      }
      
      private function UpdateMaterials(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MaterialRequirement = null;
         while(_loc2_ < param1.length && _loc2_ < ResearchUtils.MAX_MATERIALS)
         {
            _loc3_ = this.GetMaterialClipAtIndex(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.PopulateRequirement(param1[_loc2_]);
            }
            else
            {
               GlobalFunc.TraceWarning("Missing material clip for index: " + _loc2_);
            }
            _loc2_++;
         }
         while(_loc2_ < ResearchUtils.MAX_MATERIALS)
         {
            _loc3_ = this.GetMaterialClipAtIndex(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.ShowAsEmpty();
            }
            else
            {
               GlobalFunc.TraceWarning("Missing material clip for index: " + _loc2_);
            }
            _loc2_++;
         }
      }
      
      private function CanTrack() : Boolean
      {
         return this.ProjectList_mc.selectedEntry != null && this.ProjectList_mc.selectedEntry.fProgressPercentage < 1;
      }
      
      public function ToggleTracking() : void
      {
         if(this.CanTrack())
         {
            GlobalFunc.PlayMenuSound(this._trackingActive ? "UIMenuInventoryItemTagOff" : "UIMenuInventoryItemTagOn");
            BSUIDataManager.dispatchEvent(new Event("ResearchMenu_ToggleTrackingProject"));
         }
      }
      
      public function GetTrackingButtonText() : String
      {
         var _loc1_:String = "";
         if(this.CanTrack())
         {
            _loc1_ = this._trackingActive ? "$UNTRACK PROJECT" : "$TRACK PROJECT";
         }
         return _loc1_;
      }
      
      private function GetMaterialClipAtIndex(param1:uint) : MaterialRequirement
      {
         return this.ResearchMaterials_mc["Material" + param1 + "_mc"];
      }
      
      public function NextFilterType() : void
      {
         ++this._projectFilterType;
         if(this._projectFilterType >= ResearchUtils.PROJECT_FILTER_COUNT)
         {
            this._projectFilterType = ResearchUtils.PROJECT_FILTER_CAN_PROGRESS;
         }
         this.ProjectList_mc.FilterEntries();
         this.SortProjects();
         if(this.ProjectList_mc.selectedIndex == -1 && this.ProjectList_mc.entryCount > 0)
         {
            this.ProjectList_mc.selectedIndex = 0;
         }
         else if(this.ProjectList_mc.entryCount == 0)
         {
            this.ProjectList_mc.selectedIndex = -1;
         }
      }
      
      public function NextSortType() : void
      {
         switch(this._projectSortType)
         {
            case ResearchUtils.PROJECT_SORT_DEFAULT:
               this._projectSortType = ResearchUtils.PROJECT_SORT_NAME;
               break;
            case ResearchUtils.PROJECT_SORT_NAME:
               this._projectSortType = ResearchUtils.PROJECT_SORT_STATE;
               break;
            case ResearchUtils.PROJECT_SORT_STATE:
               this._projectSortType = ResearchUtils.PROJECT_SORT_DEFAULT;
         }
         this.SortProjects();
      }
      
      private function SortProjects() : void
      {
         switch(this._projectSortType)
         {
            case ResearchUtils.PROJECT_SORT_DEFAULT:
               this.ProjectList_mc.SortEntriesOn("fDefaultSortIndex",Array.NUMERIC);
               break;
            case ResearchUtils.PROJECT_SORT_NAME:
               this.ProjectList_mc.SortEntriesOn("sName",Array.CASEINSENSITIVE);
               break;
            case ResearchUtils.PROJECT_SORT_STATE:
               this.ProjectList_mc.SortEntries(this.ProjectStateCompareFunc);
         }
         this.SortHeader_mc.NameSort_mc.visible = this._projectSortType == ResearchUtils.PROJECT_SORT_NAME;
         this.SortHeader_mc.StateSort_mc.visible = this._projectSortType == ResearchUtils.PROJECT_SORT_STATE;
      }
      
      private function ProjectStateCompareFunc(param1:*, param2:*) : int
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc3_:Number = Number(param1.fProgressPercentage);
         var _loc4_:uint = !param1.bHasRequiredSkills || Boolean(param1.bIsLocked) ? uint(this.PROJECT_STATE_BLOCKED) : (_loc3_ <= 0 ? uint(this.PROJECT_STATE_NOT_STARTED) : (_loc3_ >= 1 ? uint(this.PROJECT_STATE_COMPLETE) : uint(this.PROJECT_STATE_IN_PROGRESS)));
         var _loc5_:Number = Number(param2.fProgressPercentage);
         var _loc6_:uint = !param2.bHasRequiredSkills || Boolean(param2.bIsLocked) ? uint(this.PROJECT_STATE_BLOCKED) : (_loc5_ <= 0 ? uint(this.PROJECT_STATE_NOT_STARTED) : (_loc5_ >= 1 ? uint(this.PROJECT_STATE_COMPLETE) : uint(this.PROJECT_STATE_IN_PROGRESS)));
         var _loc7_:int = 0;
         if(_loc4_ < _loc6_)
         {
            _loc7_ = -1;
         }
         else if(_loc4_ > _loc6_)
         {
            _loc7_ = 1;
         }
         else
         {
            _loc8_ = String(param1.sName.toLowerCase());
            _loc9_ = String(param2.sName.toLowerCase());
            if(_loc8_ < _loc9_)
            {
               _loc7_ = -1;
            }
            else if(_loc8_ > _loc9_)
            {
               _loc7_ = 1;
            }
         }
         return _loc7_;
      }
      
      public function GetSortButtonText() : String
      {
         var _loc1_:String = "";
         switch(this._projectSortType)
         {
            case ResearchUtils.PROJECT_SORT_DEFAULT:
               _loc1_ = "$RESEARCH_SORT_DEFAULT";
               break;
            case ResearchUtils.PROJECT_SORT_NAME:
               _loc1_ = "$RESEARCH_SORT_NAME";
               break;
            case ResearchUtils.PROJECT_SORT_STATE:
               _loc1_ = "$RESEARCH_SORT_STATE";
         }
         return _loc1_;
      }
      
      private function OnSelectionChange(param1:ScrollingEvent) : void
      {
         var _loc2_:Object = this.ProjectList_mc.GetDataForEntry(param1.PreviousIndex);
         if(_loc2_ != null && !_loc2_.bHasBeenViewed)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("ResearchMenu_ProjectViewed",{"projectID":_loc2_.uID}));
         }
         this.RequestDetails();
      }
      
      private function RequestDetails() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MaterialRequirement = null;
         if(this.ProjectList_mc.selectedEntry != null)
         {
            this.selectButtonDisabled = false;
            BSUIDataManager.dispatchEvent(new CustomEvent("ResearchMenu_PreviewProject",{"projectID":this.ProjectList_mc.selectedEntry.uID}));
         }
         else
         {
            this.selectButtonDisabled = true;
            BSUIDataManager.dispatchEvent(new Event("ResearchMenu_HideModel"));
            this.RequiredSkills_mc.HideSkills();
            this.ResearchTree_mc.ShowTree(false);
            _loc1_ = 0;
            while(_loc1_ < ResearchUtils.MAX_MATERIALS)
            {
               _loc2_ = this.GetMaterialClipAtIndex(_loc1_);
               if(_loc2_ != null)
               {
                  _loc2_.ShowAsEmpty();
               }
               _loc1_++;
            }
         }
      }
      
      public function ProjectPressed() : void
      {
         if(this.ProjectList_mc.selectedEntry != null)
         {
            GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
            dispatchEvent(new Event(ResearchUtils.PROJECT_PRESSED,true,true));
         }
      }
      
      private function PlayFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(ResearchUtils.FOCUS_SOUND);
      }
      
      private function OnModelMouseRollOut(param1:Event) : *
      {
         this.SetInspectControls(false);
      }
      
      private function OnModelMouseRollOver(param1:Event) : *
      {
         this.SetInspectControls(true);
      }
      
      private function SetInspectControls(param1:Boolean = false) : void
      {
         BSUIDataManager.dispatchCustomEvent("ResearchMenu_SetInspectControls",{
            "bInspectControlsActive":this._pageOpen,
            "bInspectMouseZoom":param1
         });
      }
   }
}

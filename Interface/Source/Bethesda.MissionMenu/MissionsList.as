package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSScrollingTree;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.QuestUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MissionsList extends BSScrollingTree
   {
      
      public static const ITEM_ACTIVATED:String = "MissionsList::itemActivated";
       
      
      private var ObjToggle_RestoreStateData:Object;
      
      private var RestoreExpandedEntriesData:Array;
      
      private var NextSelectedIndexGoingUp:int = -1;
      
      private var NextSelectedIndexGoingDown:int = -1;
      
      private var bMouseRolloverEnabled:Boolean = true;
      
      private const SCROLL_POSITION_OFFSET_CHECK:int = 2;
      
      public function MissionsList()
      {
         this.RestoreExpandedEntriesData = new Array();
         super();
      }
      
      override public function InitializeEntries(param1:Array) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].bIsMiscQuest === true)
            {
               _loc4_ = param1[_loc5_];
            }
            else if(param1[_loc5_].bComplete === true || param1[_loc5_].bFailed === true)
            {
               _loc3_.push(param1[_loc5_]);
            }
            else
            {
               _loc2_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         var _loc6_:Array = (_loc6_ = new Array()).concat(_loc2_);
         if(_loc4_ != null)
         {
            _loc6_.push(_loc4_);
         }
         if((_loc2_.length > 0 || _loc4_ != null) && _loc3_.length > 0)
         {
            _loc6_.push({"bIsDivider":true});
         }
         _loc6_ = _loc6_.concat(_loc3_);
         super.InitializeEntries(_loc6_);
         if(this.RestoreExpandedEntriesData.length > 0 && entryCount > 0)
         {
            _loc7_ = entryCount - 1;
            while(_loc7_ >= 0)
            {
               if(this.EntryHasChildren(entryList[_loc7_]))
               {
                  _loc8_ = 0;
                  while(_loc8_ < this.RestoreExpandedEntriesData.length)
                  {
                     if(entryList[_loc7_].uID === this.RestoreExpandedEntriesData[_loc8_].ID && entryList[_loc7_].uInstanceID === this.RestoreExpandedEntriesData[_loc8_].instanceID)
                     {
                        ShowEntryChildren(_loc7_,true);
                        break;
                     }
                     _loc8_++;
                  }
               }
               _loc7_--;
            }
         }
         if(this.ObjToggle_RestoreStateData != null)
         {
            _loc9_ = false;
            _loc5_ = 0;
            while(!_loc9_ && _loc5_ < entryList.length)
            {
               if(entryList[_loc5_].bIsDivider == null || entryList[_loc5_].bIsDivider == false)
               {
                  if(this.ObjToggle_RestoreStateData.restoreIsMiscObjective)
                  {
                     if(entryList[_loc5_].uID == 0)
                     {
                        ShowEntryChildren(_loc5_,true);
                        _loc9_ = true;
                     }
                  }
                  else if(entryList[_loc5_].uID === this.ObjToggle_RestoreStateData.restoreObjOwnerID)
                  {
                     ShowEntryChildren(_loc5_,true);
                     _loc9_ = true;
                  }
               }
               _loc5_++;
            }
            _loc10_ = false;
            _loc5_ = 0;
            while(!_loc10_ && _loc5_ < entryList.length)
            {
               if(entryList[_loc5_].bIsDivider == null || entryList[_loc5_].bIsDivider == false)
               {
                  if(!MissionsListEntry.IsMission(entryList[_loc5_]) && entryList[_loc5_].uOwnerQuestFormID === this.ObjToggle_RestoreStateData.restoreObjOwnerID && entryList[_loc5_].uIndex === this.ObjToggle_RestoreStateData.restoreObjIndex && entryList[_loc5_].uInstanceID === this.ObjToggle_RestoreStateData.restoreObjInstance)
                  {
                     SetSelectedIndex(_loc5_);
                     _loc10_ = true;
                  }
               }
               _loc5_++;
            }
            this.ObjToggle_RestoreStateData = null;
            if(!_loc10_)
            {
               SetSelectedIndex(0);
            }
         }
         this.bMouseRolloverEnabled = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      override protected function IsRootEntry(param1:Object) : Boolean
      {
         return MissionsListEntry.IsMission(param1) || param1.bIsDivider === true;
      }
      
      override protected function GetChildrenOfEntry(param1:Object) : Array
      {
         return MissionsListEntry.IsMission(param1) ? param1.aObjectives : new Array();
      }
      
      override protected function EntryHasChildren(param1:Object) : Boolean
      {
         return MissionsListEntry.IsMission(param1);
      }
      
      override protected function FilterRootEntries() : *
      {
         var _loc5_:* = undefined;
         ClearEntryList();
         var _loc1_:int = 0;
         var _loc2_:int = -1;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         for each(_loc5_ in rawEntries)
         {
            _loc5_.expanded = false;
            if(this.IsRootEntry(_loc5_) && this.EntryFilterCompare_Impl(_loc5_))
            {
               entryList.push(_loc5_);
               if(_loc5_.bIsDivider === true)
               {
                  _loc2_ = _loc1_;
               }
               else if(_loc5_.bComplete === true || _loc5_.bFailed === true)
               {
                  _loc3_ = true;
               }
               else
               {
                  _loc4_ = true;
               }
               _loc1_++;
            }
         }
         if(_loc2_ != -1)
         {
            if(!_loc3_ || !_loc4_)
            {
               entryList = entryList.slice(0,_loc2_).concat(entryList.slice(_loc2_ + 1,entryList.length));
            }
         }
         InvalidateData();
      }
      
      override protected function GetNewEntry() : BSContainerEntry
      {
         var _loc1_:MissionsListEntry = new EntryClass() as MissionsListEntry;
         return _loc1_ as BSContainerEntry;
      }
      
      override protected function EntryFilterCompare_Impl(param1:Object) : Boolean
      {
         var _loc2_:Boolean = true;
         if(param1.bIsDivider === true)
         {
            _loc2_ = true;
         }
         else if(filterMask == 1 << QuestUtils.COMPLETED_QUEST_TYPE)
         {
            _loc2_ = Boolean(param1.bComplete);
         }
         else
         {
            _loc2_ = param1.iType != null ? (filterMask & 1 << param1.iType) != 0 : true;
         }
         return _loc2_;
      }
      
      public function StoreCurrentListState() : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this.selectedEntry != null)
         {
            if(!MissionsListEntry.IsMission(selectedEntry))
            {
               this.ObjToggle_RestoreStateData = new Object();
               this.ObjToggle_RestoreStateData.restoreIsMiscObjective = this.selectedEntry.bIsMiscObjective === true;
               this.ObjToggle_RestoreStateData.restoreObjOwnerID = this.selectedEntry.uOwnerQuestFormID;
               this.ObjToggle_RestoreStateData.restoreObjIndex = this.selectedEntry.uIndex;
               this.ObjToggle_RestoreStateData.restoreObjInstance = this.selectedEntry.uInstanceID;
            }
         }
         this.RestoreExpandedEntriesData = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < entryCount)
         {
            _loc2_ = entryList[_loc1_];
            if(this.EntryHasChildren(_loc2_) && Boolean(_loc2_.expanded))
            {
               _loc3_ = {
                  "ID":_loc2_.uID,
                  "instanceID":_loc2_.uInstanceID
               };
               this.RestoreExpandedEntriesData.push(_loc3_);
            }
            _loc1_++;
         }
      }
      
      override public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         if(maxScrollPosition > 0)
         {
            _loc2_ = scrollPosition;
            if(param1.delta != 0)
            {
               scrollPosition += param1.delta > 0 ? -1 : 1;
            }
            if(_loc2_ != scrollPosition)
            {
               dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            }
            param1.stopPropagation();
         }
         else
         {
            super.onMouseWheel(param1);
         }
      }
      
      override protected function Update() : *
      {
         var _loc1_:BSContainerEntry = null;
         super.Update();
         if(scrollPosition != maxScrollPosition)
         {
            _loc1_ = GetClipByIndex(totalEntryClips - 1);
            if(_loc1_)
            {
               _loc1_.visible = false;
               _loc1_.itemIndex = -1;
            }
         }
      }
      
      override public function MoveSelection(param1:int) : *
      {
         var _loc6_:BSContainerEntry = null;
         var _loc2_:int = selectedIndex;
         var _loc3_:int = -1;
         var _loc4_:MissionsListEntry = null;
         do
         {
            _loc3_ = _loc2_;
            _loc2_ += param1;
            if(wrapAround)
            {
               if(_loc2_ < 0)
               {
                  _loc2_ = entryCount - 1;
               }
               else if(_loc2_ > entryCount - 1)
               {
                  _loc2_ = 0;
               }
            }
            else
            {
               _loc2_ = GlobalFunc.Clamp(_loc2_,0,entryCount - 1);
            }
         }
         while(((_loc4_ = !!(_loc6_ = FindClipForEntry(_loc2_)) ? _loc6_ as MissionsListEntry : null) != null || entryList[_loc2_].bIsDivider === true) && (_loc4_ == null || (!_loc4_.IsEntryFocusable() || navigateParentEntriesOnly && IsClipAChild(_loc4_) && !_loc4_.CanBeFocusedInParentEntriesOnly())) && _loc2_ != selectedIndex && _loc3_ != _loc2_);
         
         var _loc5_:int = selectedIndex;
         if(_loc2_ != _loc5_)
         {
            selectedIndex = _loc2_;
         }
      }
      
      override public function onEntryPress(param1:Event) : *
      {
         super.onEntryPress(param1);
         dispatchEvent(new Event(ITEM_ACTIVATED,true,true));
      }
      
      public function ExpandOrCollapseSelection() : *
      {
         if(canSelect && selectedIndex != -1 && this.EntryHasChildren(selectedEntry))
         {
            ShowEntryChildren(selectedIndex,!selectedEntry.expanded);
         }
      }
      
      override public function onEntryRollover(param1:Event) : *
      {
         if(this.bMouseRolloverEnabled)
         {
            super.onEntryRollover(param1);
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.bMouseRolloverEnabled = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      public function GetListOfExpandedQuestIds() : Array
      {
         var _loc3_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < entryCount)
         {
            _loc3_ = entryList[_loc2_];
            if(MissionsListEntry.IsMission(_loc3_) && Boolean(_loc3_.expanded))
            {
               _loc1_.push(_loc3_.uID);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function RestorePreviousMissionMenuState(param1:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < entryCount)
            {
               _loc5_ = entryList[_loc4_];
               if(MissionsListEntry.IsMission(_loc5_) && _loc5_.uID == param1[_loc3_])
               {
                  ShowEntryChildren(_loc4_,true);
                  _loc2_ = true;
                  break;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ContentLoaders.LibraryLoader;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class BackgroundPage extends MovieClip implements IChargenPage
   {
       
      
      public var BackgroundList_mc:BSScrollingContainer;
      
      public var Skill1_mc:BackgroundSkill;
      
      public var Skill2_mc:BackgroundSkill;
      
      public var Skill3_mc:BackgroundSkill;
      
      public var BackgroundHeader_mc:MovieClip;
      
      public var BackgroundDesc_mc:MovieClip;
      
      internal var BackgroundText_tf:TextField;
      
      internal var BackgroundDesc_tf:TextField;
      
      internal var Data:Array = null;
      
      internal var bBackgroundSelected:Boolean = false;
      
      private var BackgroundPatchLoader:LibraryLoader = null;
      
      private var bInitialized:Boolean = false;
      
      public function BackgroundPage()
      {
         super();
         this.BackgroundPatchLoader = new LibraryLoader(LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG);
         this.BackgroundPatchLoader.addEventListener(this.BackgroundPatchLoader.loadCompleteEventName,this.OnLibraryLoaded);
         BSUIDataManager.Subscribe("BackgroundData",this.OnBackgroundDataChanged);
      }
      
      private function OnBackgroundDataChanged(param1:FromClientDataEvent) : *
      {
         this.UpdateBackgroundData(param1.data.BackgroundsA);
         this.bBackgroundSelected = param1.data.BackgroundSelected;
      }
      
      private function OnLibraryLoaded(param1:Event) : *
      {
         this.BackgroundPatchLoader.removeEventListener(this.BackgroundPatchLoader.loadCompleteEventName,this.OnLibraryLoaded);
         var _loc2_:uint = 1;
         while(_loc2_ <= 3)
         {
            this["Skill" + _loc2_ + "_mc"].SetLibraryLoader(this.BackgroundPatchLoader);
            _loc2_++;
         }
         this.BackgroundText_tf = this.BackgroundHeader_mc.text_tf;
         this.BackgroundDesc_tf = this.BackgroundDesc_mc.text_tf;
         var _loc3_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc3_.VerticalSpacing = 0;
         _loc3_.EntryClassName = "BackgroundEntry";
         _loc3_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.BackgroundList_mc.Configure(_loc3_);
         this.BackgroundList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         this.BackgroundList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnListSelectionChange);
         this.BackgroundList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         this.bInitialized = true;
         if(this.Data != null)
         {
            this.UpdateBackgroundData(this.Data);
         }
      }
      
      public function GetBackgroundSelected() : Boolean
      {
         return this.bBackgroundSelected;
      }
      
      private function UpdateBackgroundData(param1:Array) : *
      {
         this.Data = param1;
         if(this.bInitialized)
         {
            this.BackgroundList_mc.InitializeEntries(param1);
            this.SetData(this.BackgroundList_mc.selectedEntry);
         }
      }
      
      public function GetSelectedBackgroundText() : String
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.Data.length)
         {
            if(this.Data[_loc1_].Perk.bSelected)
            {
               return this.Data[_loc1_].Perk.sName;
            }
            _loc1_++;
         }
         return "";
      }
      
      private function OnItemPress() : *
      {
         var _loc1_:MovieClip = this.BackgroundList_mc.FindClipForEntry(this.BackgroundList_mc.selectedIndex);
         (_loc1_ as BackgroundEntry).onClick();
      }
      
      private function SetData(param1:Object) : *
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            GlobalFunc.SetText(this.BackgroundText_tf,param1.Perk.sName);
            GlobalFunc.SetText(this.BackgroundDesc_tf,param1.Perk.sDescription);
            _loc2_ = 1;
            while(_loc2_ <= Math.min(param1.BonusPerksA.length,3))
            {
               this["Skill" + _loc2_ + "_mc"].BackgroundSkillInfo(param1.BonusPerksA[_loc2_ - 1]);
               _loc2_++;
            }
            while(_loc2_ <= 3)
            {
               this["Skill" + _loc2_ + "_mc"].BackgroundSkillInfo();
               _loc2_++;
            }
         }
         else
         {
            GlobalFunc.SetText(this.BackgroundText_tf,"");
            GlobalFunc.SetText(this.BackgroundDesc_tf,"");
         }
      }
      
      private function OnListSelectionChange(param1:ScrollingEvent) : *
      {
         this.SetData(param1.EntryObject);
      }
      
      public function UpdateData(param1:Object) : *
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return false;
      }
      
      public function onEnterPage() : *
      {
         gotoAndPlay("Open");
         stage.focus = this.BackgroundList_mc;
         this.BackgroundList_mc.selectedIndex = 0;
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":CharGenMenu.BACKGROUND_CAMERA_POSITION}));
      }
      
      public function onExitPage() : *
      {
         gotoAndPlay("Close");
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
      }
      
      public function InitFocus() : *
      {
         stage.focus = this.BackgroundList_mc;
      }
      
      private function PlayFocusSound() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_FOCUS);
      }
   }
}

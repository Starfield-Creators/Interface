package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class BulldozePopup extends MovieClip
   {
       
      
      public var BulldozeList_mc:BSScrollingContainer;
      
      private var _openStarted:Boolean = false;
      
      private var _dataReady:Boolean = false;
      
      private const LIST_SPACING:Number = 3;
      
      public function BulldozePopup()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = this.LIST_SPACING;
         _loc1_.EntryClassName = "BuildObjectList_Entry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.BulldozeList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         BSUIDataManager.Subscribe("WorkshopBulldozerData",this.OnBulldozeDataUpdate);
      }
      
      public function get currentItemHasVariants() : Boolean
      {
         return this.BulldozeList_mc.selectedEntry != null && WorkshopUtils.GetHasVariants(this.BulldozeList_mc.selectedEntry);
      }
      
      public function set show(param1:Boolean) : void
      {
         this.visible = param1;
         this.Open();
      }
      
      private function Open() : void
      {
         if(!this._openStarted && this._dataReady && this.visible)
         {
            this._openStarted = true;
            this.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
      }
      
      public function Close(param1:Boolean) : void
      {
         if(param1)
         {
            this.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
         }
         else
         {
            this.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
         }
      }
      
      private function onListSelectionChange() : void
      {
         var _loc1_:* = this.BulldozeList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_SelectedBulldozer",{"formID":WorkshopUtils.GetVariantId(_loc1_)}));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound("UIOutpostModeMenuGridFocus");
      }
      
      private function OnBulldozeDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc3_:Object = null;
         this._dataReady = param1.data.aPreviewIcons.length != 0;
         removeEventListener(ScrollingEvent.SELECTION_CHANGE,this.onListSelectionChange);
         this.BulldozeList_mc.InitializeEntries(param1.data.aPreviewIcons);
         var _loc2_:uint = 0;
         for each(_loc3_ in param1.data.aPreviewIcons)
         {
            if(_loc3_.uID == param1.data.uCurrentIconID)
            {
               break;
            }
            _loc2_++;
         }
         if(param1.data.aPreviewIcons.length > 0)
         {
            this.BulldozeList_mc.selectedIndex = _loc2_;
         }
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onListSelectionChange);
         this.Open();
      }
   }
}

package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class SelectModePopup extends MovieClip
   {
       
      
      public var ModeList_mc:WorkshopModeList;
      
      private var _openStarted:Boolean = false;
      
      private var _dataReady:Boolean = false;
      
      private const LIST_SPACING:Number = 3;
      
      public function SelectModePopup()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = this.LIST_SPACING;
         _loc1_.EntryClassName = "WorkshopModeList_Entry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.ModeList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
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
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound("UIOutpostModeMenuGridFocus");
      }
      
      public function SetCurrentMode(param1:int) : void
      {
         this.ModeList_mc.SetIndexByMode(param1);
      }
      
      public function GetCurrentMode() : int
      {
         return this.ModeList_mc.selectedIndex != -1 ? this.ModeList_mc.selectedEntry as int : WorkshopUtils.WIM_NONE;
      }
      
      public function InitializeModeList(param1:Array, param2:int) : void
      {
         var _loc4_:int = 0;
         this._dataReady = param2 != WorkshopUtils.WIM_NONE;
         this.ModeList_mc.InitializeEntries(param1);
         var _loc3_:int = -1;
         for each(_loc4_ in param1)
         {
            if(_loc4_ == param2)
            {
               break;
            }
            _loc3_++;
         }
         this.ModeList_mc.selectedIndex = _loc3_;
         this.Open();
      }
   }
}

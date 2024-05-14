package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PickpocketMenu extends IMenu
   {
       
      
      public var List_mc:PickpocketList;
      
      public var TargetName_tf:TextField;
      
      public var ButtonBar_mc:MovieClip;
      
      public var DetectedIcon_mc:MovieClip;
      
      public const EVENT_ON_ITEM_SELECT:String = "PickpocketMenu_OnItemSelect";
      
      public function PickpocketMenu()
      {
         var _loc1_:BSScrollingConfigParams = null;
         super();
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 2;
         _loc1_.EntryClassName = "PickpocketListEntry";
         this.List_mc.Configure(_loc1_);
         this.List_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemSelect);
         this.List_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onSelectionChange);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         this.ButtonBar_mc.AcceptButton_mc.SetButtonData(new ButtonBaseData("$STEAL",new UserEventData("QCAButton",this.onItemSelect)));
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.AcceptButton_mc);
         this.ButtonBar_mc.CancelButton_mc.SetButtonData(new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancelPressed)));
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.CancelButton_mc);
         this.ButtonBar_mc.RefreshButtons();
         GlobalFunc.PlayMenuSound("UIMenuPickpocketingMenuOpen");
         BSUIDataManager.Subscribe("PickpocketContainerData",this.onContainerUpdate);
         BSUIDataManager.Subscribe("PickpocketStateData",this.onStateUpdate);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            switch(param1)
            {
               case "QCAButton":
                  this.onItemSelect();
                  _loc3_ = true;
                  break;
               case "Cancel":
                  this.onCancelPressed();
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onCancelPressed() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuPickpocketingMenuClose");
         GlobalFunc.CloseMenu("PickpocketMenu");
      }
      
      private function onContainerUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         GlobalFunc.SetText(this.TargetName_tf,param1.data.sContainerName);
         if(param1.data.aItems.length > 0)
         {
            this.List_mc.EmptyMessage_tf.visible = false;
         }
         this.List_mc.InitializeEntries(param1.data.aItems);
         if(param1.data.aItems.length > 1)
         {
            _loc2_ = this.List_mc.selectedIndex != -1 ? uint(this.List_mc.selectedIndex) : 0;
            _loc3_ = _loc2_;
            if(param1.data.aItems[_loc2_].fStealChancePct <= 0)
            {
               do
               {
                  _loc2_ += 1;
                  if(_loc2_ >= param1.data.aItems.length)
                  {
                     _loc2_ = 0;
                  }
               }
               while(param1.data.aItems[_loc2_].fStealChancePct <= 0 && _loc2_ != _loc3_);
               
            }
            if(this.List_mc.selectedIndex != _loc2_)
            {
               this.List_mc.selectedIndex = _loc2_;
            }
         }
         else if(this.List_mc.selectedIndex == -1)
         {
            this.List_mc.selectedIndex = 0;
         }
         stage.focus = this.List_mc;
      }
      
      private function onStateUpdate(param1:FromClientDataEvent) : void
      {
         this.DetectedIcon_mc.visible = param1.data.bIsDetectedByTarget;
      }
      
      private function onItemSelect() : void
      {
         if(this.ButtonBar_mc.AcceptButton_mc.Enabled)
         {
            BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_ITEM_SELECT,{"handleID":this.List_mc.selectedEntry.uHandleID});
         }
         else
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         }
      }
      
      private function onSelectionChange() : void
      {
         this.ButtonBar_mc.AcceptButton_mc.Enabled = this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.uStealChanceColor < 4;
      }
   }
}

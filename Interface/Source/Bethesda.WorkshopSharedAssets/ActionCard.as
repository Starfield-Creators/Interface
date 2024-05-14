package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class ActionCard extends MovieClip
   {
      
      public static const CURRENT_ACTION_CHANGED:String = "ItemCard_ActionChangedEvent";
       
      
      public var TitleSection_mc:MovieClip;
      
      public var ActionList_mc:BSScrollingContainer;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Background_mc:MovieClip;
      
      private var ActivateButton:IButton = null;
      
      private var ExitButton:IButton = null;
      
      private var _mode:uint = 0;
      
      private var _currentAction:uint = 0;
      
      private var _receivedActivatePress:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      private const ICON_PADDING:Number = 8;
      
      public function ActionCard()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "ActionList_Entry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.ActionList_mc.Configure(_loc1_);
         this.ActionList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.onSelectionChange);
         if(!this._largeTextMode)
         {
            TextFieldEx.setTextAutoSize(this.TitleSection_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this._mode = WorkshopUtils.WQM_IDLE;
         this._currentAction = WorkshopUtils.WIA_NONE;
         this._receivedActivatePress = false;
         this.PopulateButtonBars();
      }
      
      private function get selectedEntry() : Object
      {
         return this.ActionList_mc.selectedEntry;
      }
      
      public function get active() : Boolean
      {
         return this._mode == WorkshopUtils.WQM_OUTPOST_INTERACT || this._mode == WorkshopUtils.WQM_HUD_INTERACT;
      }
      
      public function get focusObject() : MovieClip
      {
         return this.active ? this.ActionList_mc : null;
      }
      
      public function set mode(param1:uint) : void
      {
         if(this._mode != param1)
         {
            if(this._mode == WorkshopUtils.WQM_IDLE)
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               gotoAndPlay(WorkshopUtils.OPEN_FRAME);
            }
            else if(this._mode == WorkshopUtils.WQM_OUTPOST_INTERACT || this._mode == WorkshopUtils.WQM_HUD_INTERACT)
            {
               gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
            }
            this._mode = param1;
            if(this._mode != WorkshopUtils.WQM_HUD_PERFORMING_ACTION)
            {
               this.currentAction = WorkshopUtils.WIA_NONE;
            }
            this._receivedActivatePress = false;
            this.ExitButton.Visible = this._mode == WorkshopUtils.WQM_HUD_INTERACT;
            this.ButtonBar_mc.RefreshButtons();
            stage.focus = this.focusObject;
         }
      }
      
      public function get currentAction() : uint
      {
         return this._currentAction;
      }
      
      public function set currentAction(param1:uint) : void
      {
         if(this._currentAction != param1)
         {
            this._currentAction = param1;
            dispatchEvent(new CustomEvent(CURRENT_ACTION_CHANGED,{"action":this._currentAction},true,true));
         }
      }
      
      private function PopulateButtonBars() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ActivateButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT",new UserEventData("Confirm",this.OnActivate)),this.ButtonBar_mc);
         this.ExitButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("QMCancel",this.OnExit)),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onSelectionChange(param1:ScrollingEvent) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      public function UpdateCardData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:* = false;
         if(param1 != null)
         {
            WorkshopUtils.SetSingleLineText(this.TitleSection_mc.Text_tf,param1.sDisplayName,this._largeTextMode);
            this.TitleSection_mc.IconHolder_mc.ResourceIcon_mc.gotoAndStop(WorkshopUtils.GetResourceIconFrameLabel(param1.uResourceType));
            _loc2_ = this.TitleSection_mc.Text_tf.x + this.TitleSection_mc.Text_tf.getLineMetrics(0).width + this.ICON_PADDING;
            this.TitleSection_mc.IconHolder_mc.x = _loc2_;
            _loc3_ = new Array();
            _loc4_ = uint(param1.uAllowedActionsFlag);
            if((_loc5_ = this._mode == WorkshopUtils.WQM_HUD_INTERACT) && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_FULL_MODE))
            {
               _loc3_.push({
                  "action":"$OUTPOST",
                  "callback":this.OnStartFullOutpost
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_MOVE))
            {
               _loc3_.push({
                  "action":"$MOVE",
                  "callback":this.OnMoveItem
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_REVERT))
            {
               _loc3_.push({
                  "action":"$REVERT",
                  "callback":this.OnRevertItem
               });
            }
            if(WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_GROUP_SELECT))
            {
               _loc3_.push({
                  "action":"$GROUP SELECT",
                  "callback":this.OnGroupSelect
               });
            }
            if(WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_BLUEPRINT))
            {
               _loc3_.push({
                  "action":"$BLUEPRINT",
                  "callback":this.OnBlueprint
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_DELETE))
            {
               _loc3_.push({
                  "action":"$DELETE",
                  "callback":this.OnDelete
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_REPLACE))
            {
               _loc3_.push({
                  "action":"$REPLACE",
                  "callback":this.OnReplace
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_REPAIR))
            {
               _loc3_.push({
                  "action":"$REPAIR",
                  "callback":this.OnRepair
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_TRANSFER_LINK))
            {
               _loc3_.push({
                  "action":"$OutputLink",
                  "callback":this.OnTransferLink
               });
            }
            if(_loc5_ && WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_SET_COLORS))
            {
               _loc3_.push({
                  "action":"$ChangeColors",
                  "callback":this.OnSetColors
               });
            }
            if(WorkshopUtils.CheckActionFlags(_loc4_,WorkshopUtils.WIA_WIRE))
            {
               _loc3_.push({
                  "action":"$WIRE",
                  "callback":this.OnWire
               });
            }
            this.ActionList_mc.InitializeEntries(_loc3_);
            this.ActionList_mc.selectedIndex = 0;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_ && param1 == "Confirm")
         {
            if(this._receivedActivatePress && !param2)
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
            this._receivedActivatePress = param2;
         }
         else
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function OnActivate() : void
      {
         if(this.selectedEntry)
         {
            this.selectedEntry.callback.call();
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         }
      }
      
      private function OnExit() : void
      {
         BSUIDataManager.dispatchEvent(new Event("WorkshopQuickMenu_ExitMenu"));
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
      }
      
      private function OnMoveItem() : void
      {
         this.currentAction = WorkshopUtils.WIA_MOVE;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnRevertItem() : void
      {
         this.currentAction = WorkshopUtils.WIA_REVERT;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnDelete() : void
      {
         this.currentAction = WorkshopUtils.WIA_DELETE;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.SET_ACTION_HANDLES,{"actionType":WorkshopUtils.ABT_DELETE}));
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnGroupSelect() : void
      {
      }
      
      private function OnBlueprint() : void
      {
      }
      
      private function OnReplace() : void
      {
      }
      
      private function OnWire() : void
      {
         this.currentAction = WorkshopUtils.WIA_WIRE;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnStartFullOutpost() : void
      {
         this.currentAction = WorkshopUtils.WIA_FULL_MODE;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnTransferLink() : void
      {
         this.currentAction = WorkshopUtils.WIA_TRANSFER_LINK;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnRepair() : void
      {
         this.currentAction = WorkshopUtils.WIA_REPAIR;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
      
      private function OnSetColors() : void
      {
         this.currentAction = WorkshopUtils.WIA_SET_COLORS;
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":this._currentAction}));
      }
   }
}

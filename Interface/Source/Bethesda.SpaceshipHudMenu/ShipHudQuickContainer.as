package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.QuickContainer.ContainerData;
   import Shared.AS3.QuickContainer.QuickContainerListEntry;
   import Shared.AS3.RolloverReticle;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.RepeatingButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class ShipHudQuickContainer extends BSDisplayObject
   {
      
      public static const ShipHudQuickContainer_TransferMenu:String = "ShipHudQuickContainer_TransferMenu";
      
      public static const ShipHudQuickContainer_TransferItem:String = "ShipHudQuickContainer_TransferItem";
      
      private static const RETICLE_HALF_WIDTH:Number = 17.8;
       
      
      public var List_mc:BSScrollingContainer;
      
      public var TargetName_tf:TextField;
      
      public var PlayerInvData_mc:ContainerData;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Header_mc:MovieClip;
      
      private var TakeButtonHintData:ButtonBaseData;
      
      private var TransferButtonHintData:ButtonBaseData;
      
      private var UpDownButton:RepeatingButtonData;
      
      private var DirectionButton_mc:IButton;
      
      private var TargetObj:Object = null;
      
      private var TargetOnlyData:Object = null;
      
      private var LastTargetID:uint = 4294967295;
      
      private var MonocleMode:Boolean = false;
      
      private var LastCanLoot:Boolean = false;
      
      private var ReticleObject:RolloverReticle;
      
      public function ShipHudQuickContainer()
      {
         this.TakeButtonHintData = new ButtonBaseData("$TAKE",new UserEventData("SelectTarget",this.onTakePressed),false,false);
         this.TransferButtonHintData = new ButtonBaseData("$Transfer",new UserEventData("XButton",this.onTransferPressed),false,false);
         this.UpDownButton = new RepeatingButtonData("",[new UserEventData("Up",this.onUpPress),new UserEventData("Down",this.onDownPress)],RepeatingButtonData.DEFAULT_REPEAT_INTERVAL_MS,false,false,"","");
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 4;
         _loc1_.EntryClassName = "Shared.AS3.QuickContainer.QuickContainerListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.List_mc.Configure(_loc1_);
         this.PlayerInvData_mc.SetCapacityLabel("$CAPACITY");
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.TakeButton,this.TakeButtonHintData);
         this.ButtonBar_mc.AddButtonWithData(this.TransferButton,this.TransferButtonHintData);
         this.DirectionButton_mc = ButtonFactory.AddToButtonBar("QCRepeatingButton",this.UpDownButton,this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChanged);
         QuickContainerListEntry.IsStealing = false;
      }
      
      private function get TakeButton() : IButton
      {
         return this.ButtonBar_mc.TakeButton_mc;
      }
      
      private function get TransferButton() : IButton
      {
         return this.ButtonBar_mc.TransferButton_mc;
      }
      
      private function get SelectedEntry() : Object
      {
         return this.List_mc.selectedEntry;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ReticleObject = new RolloverReticle(this);
         var _loc1_:Rectangle = this.Header_mc.getBounds(this);
         this.ReticleObject.SetAnchor(_loc1_.left,_loc1_.bottom);
      }
      
      private function GetRadius(param1:Number, param2:Number) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = Math.abs(this.ReticleObject.AnchorX - param1);
         var _loc4_:Number = Math.abs(this.ReticleObject.AnchorY - param2);
         var _loc5_:Number = 0;
         if(_loc3_ == 0 || _loc4_ == 0)
         {
            _loc5_ = RETICLE_HALF_WIDTH;
         }
         else
         {
            _loc6_ = RETICLE_HALF_WIDTH / (1 + _loc4_ / _loc3_);
            _loc7_ = RETICLE_HALF_WIDTH - _loc6_;
            _loc5_ = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
         }
         return _loc5_;
      }
      
      public function OnItemsChanged(param1:Object) : void
      {
         this.List_mc.InitializeEntries(param1.aItems);
         if(this.List_mc.selectedIndex < 0)
         {
            this.List_mc.selectedIndex = 0;
         }
         this.PlayerInvData_mc.UpdateAdditionalCapacityFromItem(this.SelectedEntry);
      }
      
      private function OnSelectionChanged(param1:Event) : void
      {
         this.PlayerInvData_mc.UpdateAdditionalCapacityFromItem(this.SelectedEntry);
      }
      
      public function UpdatePlayerData(param1:Object) : *
      {
         this.PlayerInvData_mc.UpdateData(param1.fCurrentCargoWeight,param1.fMaxCargoWeight);
      }
      
      public function UpdateTargetData(param1:Object) : *
      {
         var _loc2_:int = int(param1.iInfoTargetIndex);
         this.TargetObj = _loc2_ != -1 ? param1.targetArray.dataA[_loc2_] : null;
         this.OnTargetUpdate();
      }
      
      public function UpdateTargetHigh(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc4_:Point = null;
         _loc2_ = int(param1.iInfoTargetIndex);
         var _loc3_:Object = _loc2_ != -1 ? param1.targetArray[_loc2_] : null;
         if(_loc3_ != null && this.CanShow())
         {
            _loc4_ = GlobalFunc.ConvertScreenPercentsToLocalPoint(_loc3_.screenPositionX,_loc3_.screenPositionY,this);
            this.ReticleObject.SetReticleRadius(this.GetRadius(_loc4_.x,_loc4_.y));
            this.ReticleObject.SetReticleLocation(_loc4_.x,_loc4_.y);
         }
      }
      
      public function UpdateTargetOnlyData(param1:Object) : *
      {
         this.TargetOnlyData = param1;
         this.OnTargetUpdate();
      }
      
      public function OnTargetUpdate() : *
      {
         var _loc1_:Boolean = this.CanShow();
         if(visible != _loc1_)
         {
            if(_loc1_)
            {
               this.ReticleObject.BeginUpdatingLineAnim();
            }
            else
            {
               this.ReticleObject.Clear();
            }
            visible = _loc1_;
         }
         if(visible && this.LastTargetID != this.TargetObj.uniqueID)
         {
            GlobalFunc.SetText(this.TargetName_tf,this.TargetObj.name);
            this.LastTargetID = this.TargetObj.uniqueID;
         }
         var _loc2_:Boolean = this.CanLoot();
         if(this.LastCanLoot != _loc2_)
         {
            this.TakeButton.Enabled = _loc2_;
            this.TakeButton.Visible = _loc2_;
            this.TransferButton.Enabled = _loc2_;
            this.TransferButton.Visible = _loc2_;
            this.DirectionButton_mc.Enabled = _loc2_;
            this.ButtonBar_mc.RefreshButtons();
            this.LastCanLoot = _loc2_;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.CanLoot())
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onTakePressed() : *
      {
         if(this.CanLoot() && Boolean(this.SelectedEntry))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHudQuickContainer_TransferItem,{"uHandleID":this.SelectedEntry.uHandleID}));
         }
      }
      
      private function onTransferPressed() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHudQuickContainer_TransferMenu));
      }
      
      private function CanLoot() : Boolean
      {
         return this.TargetObj != null && this.TargetOnlyData != null && Boolean(this.TargetOnlyData.blootingAllowed) && !this.TargetOnlyData.blootingDisabled;
      }
      
      private function CanShow() : Boolean
      {
         return this.TargetObj != null && this.TargetOnlyData != null && Boolean(this.TargetOnlyData.blootingAllowed) && (!this.TargetOnlyData.blootingDisabled || this.MonocleMode);
      }
      
      private function onLeftPress() : *
      {
      }
      
      private function onRightPress() : *
      {
      }
      
      private function onUpPress() : *
      {
         this.List_mc.MoveSelection(-1);
      }
      
      private function onDownPress() : *
      {
         this.List_mc.MoveSelection(1);
      }
      
      public function OnMonocleModeChange(param1:CustomEvent) : *
      {
         this.MonocleMode = param1.params.Active;
         this.OnTargetUpdate();
      }
   }
}

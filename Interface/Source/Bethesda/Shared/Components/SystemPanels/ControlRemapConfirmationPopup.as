package Shared.Components.SystemPanels
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   
   public class ControlRemapConfirmationPopup extends MovieClip
   {
       
      
      public var Warning_mc:MovieClip;
      
      public var ControlInfo_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var _active:Boolean = false;
      
      protected var ConfirmButtonData:ButtonBaseData;
      
      protected var CancelButtonData:ButtonBaseData;
      
      public function ControlRemapConfirmationPopup()
      {
         this.ConfirmButtonData = new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept));
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel));
         super();
         Extensions.enabled = true;
         this.ControlInfo_mc.Label_mc.Text_tf.autoSize = TextFieldAutoSize.RIGHT;
         this.ControlInfo_mc.Icon_mc.Icon_tf.autoSize = TextFieldAutoSize.LEFT;
         this.ControlInfo_mc.PCKey_mc.PCKey_tf.autoSize = TextFieldAutoSize.LEFT;
         BSUIDataManager.Subscribe("RemapConfirmationData",this.OnRemapConfirmationDataUpdate);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : *
      {
         this.visible = param1;
         this._active = param1;
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,this.CancelButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ProcessEventForButtonBar(param1,param2);
      }
      
      protected function ProcessEventForButtonBar(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function OnRemapConfirmationDataUpdate(param1:FromClientDataEvent) : void
      {
         GlobalFunc.SetText(this.ControlInfo_mc.Label_mc.Text_tf,"$" + param1.data.sContextName + "_" + param1.data.sUserEvent);
         var _loc2_:String = "";
         var _loc3_:uint = 1;
         if(param1.data.InUseBinding.aPCKeyName.length > 0)
         {
            _loc2_ = String(param1.data.InUseBinding.aPCKeyName[0]);
            while(_loc3_ < param1.data.InUseBinding.aPCKeyName.length)
            {
               _loc2_ += " " + param1.data.InUseBinding.aPCKeyName[_loc3_];
               _loc3_++;
            }
            GlobalFunc.SetText(this.ControlInfo_mc.PCKey_mc.PCKey_tf,_loc2_);
            this.ControlInfo_mc.Icon_mc.Icon_tf.visible = false;
         }
         else if(param1.data.InUseBinding.aButtonName.length > 0)
         {
            _loc2_ = String(GlobalFunc.NameToTextMap[param1.data.InUseBinding.aButtonName[0]]);
            while(_loc3_ < param1.data.InUseBinding.aButtonName.length)
            {
               _loc2_ += " " + GlobalFunc.NameToTextMap[param1.data.InUseBinding.aButtonName[_loc3_]];
               _loc3_++;
            }
            GlobalFunc.SetText(this.ControlInfo_mc.Icon_mc.Icon_tf,_loc2_);
            GlobalFunc.SetText(this.ControlInfo_mc.PCKey_mc.PCKey_tf,"");
            this.ControlInfo_mc.Icon_mc.Icon_tf.visible = true;
         }
         this.active = true;
      }
      
      private function onAccept() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_RemapConfirmed",{"confirmed":true}));
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_RemapConfirmed",{"confirmed":false}));
      }
   }
}

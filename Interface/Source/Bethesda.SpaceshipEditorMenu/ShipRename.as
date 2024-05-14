package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import Shared.TextUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class ShipRename extends BSDisplayObject
   {
      
      private static const MAX_SHIP_NAME_LENGTH:uint = 14;
      
      private static const ROLL_ON:String = "rollOn";
      
      private static const NORMAL:String = "Normal";
      
      private static const ACTIVE:String = "Active";
      
      public static const ShipEditor_OnRenameShipAccept:String = "ShipEditor_OnRenameShipAccept";
      
      public static const ShipEditor_OnRenameShipCancel:String = "ShipEditor_OnRenameShipCancel";
      
      public static const ShipEditor_OnRenameInputCancelled:String = "ShipEditor_OnRenameInputCancelled";
      
      public static const ShipEditor_OnRenameStartEditText:String = "ShipEditor_OnRenameStartEditText";
      
      public static const ShipEditor_OnRenameEndEditText:String = "ShipEditor_OnRenameEndEditText";
       
      
      public var Header_mc:MovieClip;
      
      public var ShipName_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var FullscreenBG_mc:MovieClip;
      
      private var bEnteringText:Boolean = false;
      
      private var OriginalName:String;
      
      public function ShipRename()
      {
         super();
         this.ButtonBar_mc.Initialize(1,15);
         ButtonFactory.AddToButtonBar("EditorButton",new ButtonBaseData("$RENAME",[new UserEventData("Rename",null,"Rename")]),this.ButtonBar_mc);
         ButtonFactory.AddToButtonBar("EditorButton",new ButtonBaseData("$CONFIRM",[new UserEventData("Accept",this.OnAccept)]),this.ButtonBar_mc);
         ButtonFactory.AddToButtonBar("EditorButton",new ButtonBaseData("$CANCEL",[new UserEventData("Cancel",this.OnCancel)]),this.ButtonBar_mc);
      }
      
      private function get HeaderText() : TextField
      {
         return this.Header_mc.text_tf;
      }
      
      private function get ShipNameText() : TextField
      {
         return this.ShipName_mc.Text_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         GlobalFunc.SetText(this.HeaderText,"$ShipRenameHeader");
         BSUIDataManager.Subscribe("ShipRenameInitialization",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(_loc2_.bVisible)
            {
               Show(_loc2_);
            }
            else
            {
               Hide();
            }
         });
         BSUIDataManager.Subscribe("ShipRenameData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(bEnteringText != _loc2_.bEditText)
            {
               if(_loc2_.bEditText)
               {
                  StartEditText();
               }
               else
               {
                  bEnteringText = false;
                  DisableShipNameTextfield();
               }
            }
         });
         BSUIDataManager.Subscribe("ShipRenameDisplayUpdate",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            GlobalFunc.SetText(ShipNameText,_loc2_.sShipName);
         });
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.Hide();
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.bEnteringText)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               this.AcceptEditText();
            }
            else if(param1.keyCode == Keyboard.ESCAPE)
            {
               this.CancelEditText();
            }
         }
      }
      
      public function OnAccept() : void
      {
         if(this.bEnteringText)
         {
            this.AcceptEditText();
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_OnHintButtonActivated",{"buttonAction":"Exit"}));
         }
      }
      
      public function OnCancel() : void
      {
         if(this.bEnteringText)
         {
            this.CancelEditText();
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_OnHintButtonActivated",{"buttonAction":"Cancel"}));
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function Show(param1:Object) : *
      {
         GlobalFunc.SetText(this.ShipNameText,param1.sShipName);
         if(!visible)
         {
            gotoAndPlay(ROLL_ON);
         }
         visible = true;
      }
      
      public function Hide() : *
      {
         this.visible = false;
      }
      
      public function StartEditText() : *
      {
         var _loc2_:String = null;
         if(this.bEnteringText)
         {
            return;
         }
         this.bEnteringText = true;
         var _loc1_:* = this.ShipNameText;
         _loc2_ = TextUtils.TrimString(_loc1_.text);
         _loc1_.text = _loc2_;
         this.OriginalName = _loc2_;
         _loc1_.type = TextFieldType.INPUT;
         _loc1_.selectable = true;
         _loc1_.maxChars = MAX_SHIP_NAME_LENGTH;
         _loc1_.setSelection(0,_loc1_.text.length);
         stage.focus = _loc1_;
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
      }
      
      public function AcceptEditText() : *
      {
         var _loc1_:String = TextUtils.TrimString(this.ShipNameText.text);
         if(!_loc1_)
         {
            this.CancelEditText();
            return;
         }
         this.DisableShipNameTextfield();
         if(_loc1_ != this.ShipNameText.text)
         {
            GlobalFunc.SetText(this.ShipNameText,_loc1_);
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipEditor_OnRenameEndEditText,{"sShipName":_loc1_}));
         this.bEnteringText = false;
      }
      
      public function CancelEditText(param1:Boolean = false) : *
      {
         this.DisableShipNameTextfield();
         GlobalFunc.SetText(this.ShipNameText,this.OriginalName);
         if(!param1)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipEditor_OnRenameInputCancelled));
         }
         this.bEnteringText = false;
      }
      
      private function DisableShipNameTextfield() : void
      {
         this.ShipNameText.type = TextFieldType.DYNAMIC;
         this.ShipNameText.setSelection(0,0);
         this.ShipNameText.selectable = false;
         this.ShipNameText.maxChars = 0;
         stage.focus = this;
      }
   }
}

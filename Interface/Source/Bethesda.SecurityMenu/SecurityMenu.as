package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class SecurityMenu extends IMenu
   {
      
      public static const MOVE_DIGI_PICK_REMAIN:String = "MoveDigiPickRemain";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var DigiKeyPanel_mc:MovieClip;
      
      public var DigiPick_mc:MovieClip;
      
      public var DigiPickRemain_mc:MovieClip;
      
      private var ButtonCancelLastPick:IButton = null;
      
      private var ButtonAutoAttempt:ProgressButton = null;
      
      private var ButtonUseKey:IButton = null;
      
      private var ButtonStartGame:IButton = null;
      
      private var ButtonEliminateUnusedKeys:IButton = null;
      
      private var PickCountSubs:Array;
      
      private var GameStarted:Boolean = false;
      
      private var DigiPickRemainStartingYPosition:Number = 0;
      
      private var DataInitialized:Boolean = false;
      
      internal var KeyArrayA:Array;
      
      internal var Data:Object;
      
      private const THUMBSTICK_THRESHOLD:Number = 0.3;
      
      private const MAX_DIGIPICKS_TO_DISPLAY:Number = 999;
      
      private var ExitingMenu:* = false;
      
      public function SecurityMenu()
      {
         this.PickCountSubs = new Array();
         this.KeyArrayA = new Array();
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         this.ButtonAutoAttempt = ButtonFactory.AddToButtonBar("ProgressButton",new ButtonBaseData("$AutoSlot",[new UserEventData("YButton",this.OnAutoAttempt)],true,false,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,["9"]),this.ButtonBar_mc) as ProgressButton;
         this.ButtonCancelLastPick = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL_PICK",[new UserEventData("CancelPick",this.OnCancelPick)],true,false,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,["9"]),this.ButtonBar_mc);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$PREVIOUS_KEY",[new UserEventData("LShoulder",this.onPreviousKey)],true,false),this.ButtonBar_mc);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$NEXT_KEY",[new UserEventData("RShoulder",this.onNextKey)],true,false),this.ButtonBar_mc);
         this.ButtonStartGame = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$START_SECURITY_GAME",[new UserEventData("Accept",this.TryUseKey)],true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,["9"]),this.ButtonBar_mc);
         this.ButtonEliminateUnusedKeys = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$EliminateUnusedKeys",[new UserEventData("EliminateUnusedKeys",this.OnEliminateUnusedKeys)],true,false),this.ButtonBar_mc);
         this.ButtonUseKey = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$USE_KEY",[new UserEventData("Accept",this.TryUseKey)],true,false),this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonCancel,new ButtonBaseData("$EXIT",[new UserEventData("Cancel",this.ExitMenu)]));
         this.ButtonBar_mc.RefreshButtons();
         this.DigiPick_mc.gotoAndPlay("show");
         this.DigiKeyPanel_mc.gotoAndPlay("show");
         this.DigiKeyPanel_mc.KeyPanel_mc.gotoAndPlay("show");
         this.DigiKeyPanel_mc.addEventListener(DigiKeyPanel.REFRESH_PICK_RING,this.RefreshPickRing);
         this.DigiKeyPanel_mc.addEventListener(DigiKeyPanel.TRY_USE_KEY,this.TryUseKey);
         this.DigiKeyPanel_mc.addEventListener(MOVE_DIGI_PICK_REMAIN,this.HandleMoveDigiPickRemainEvent);
         this.DigiPickRemainStartingYPosition = this.DigiPickRemain_mc.y;
         BSUIDataManager.Subscribe("SecurityData",this.OnSecurityDataChanged);
         BSUIDataManager.Subscribe("FireForgetEventData",this.OnFireForgetEventData);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         stage.focus = this;
      }
      
      private function get ButtonCancel() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function ExitMenu() : *
      {
         if(!this.ExitingMenu)
         {
            this.ExitingMenu = true;
            if(this.GameStarted)
            {
               BSUIDataManager.dispatchEvent(new Event("SecurityMenu_ConfirmExit",true));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new Event("SecurityMenu_CloseMenu",true));
            }
         }
      }
      
      public function OnCancelPick() : *
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         BSUIDataManager.dispatchEvent(new Event("SecurityMenu_BackOutKey",true));
      }
      
      private function RefreshPickRing() : *
      {
         var _loc1_:Object = {
            "uiRotatePosition":this.DigiKeyPanel_mc.GetCurrentKeyRotation(),
            "uiPickDataA":this.Data.KeyDataA.dataA[this.DigiKeyPanel_mc.selectedKey].TeethA.slice()
         };
         this.DigiPick_mc.SetPickRingData(_loc1_);
      }
      
      private function HandleMoveDigiPickRemainEvent(param1:CustomEvent) : *
      {
         this.DigiPickRemain_mc.y = this.DigiPickRemainStartingYPosition + param1.params.movement;
      }
      
      public function OnEliminateUnusedKeys() : *
      {
         BSUIDataManager.dispatchEvent(new Event("SecurityMenu_EliminateUnusedKeys",true));
      }
      
      public function OnAutoAttempt() : *
      {
         BSUIDataManager.dispatchEvent(new Event("SecurityMenu_GetRingHint",true));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == false)
         {
            switch(param1)
            {
               case "Cancel":
                  this.ExitMenu();
                  break;
               case "CancelPick":
                  this.OnCancelPick();
                  break;
               case "YButton":
                  if(this.Data.fAutoAttemptCount >= 1)
                  {
                     this.OnAutoAttempt();
                  }
                  break;
               case "EliminateUnusedKeys":
                  if(this.ButtonEliminateUnusedKeys.Visible && this.ButtonEliminateUnusedKeys.Enabled)
                  {
                     this.OnEliminateUnusedKeys();
                  }
                  break;
               case "LShoulder":
                  this.onNextKey();
                  this.RefreshPickRing();
                  break;
               case "RShoulder":
                  this.onPreviousKey();
                  this.RefreshPickRing();
                  break;
               case "Activate":
               case "Accept":
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
                  this.TryUseKey();
            }
         }
         return _loc3_;
      }
      
      public function OnRightStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         if(this.DataInitialized)
         {
            if(param4)
            {
               if(Math.abs(param1) > this.THUMBSTICK_THRESHOLD)
               {
                  if(param1 > 0)
                  {
                     this.onPreviousKey();
                  }
                  else
                  {
                     this.onNextKey();
                  }
                  this.RefreshPickRing();
               }
               else if(Math.abs(param2) > this.THUMBSTICK_THRESHOLD)
               {
                  if(param2 > 0)
                  {
                     this.onNextRowKey();
                  }
                  else
                  {
                     this.onPreviousRowKey();
                  }
                  this.RefreshPickRing();
               }
            }
         }
      }
      
      private function TryUseKey() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("SecurityMenu_TryUseKey",{
            "uKeyIndex":this.DigiKeyPanel_mc.selectedKey,
            "uRotation":this.DigiPick_mc.pickRotation
         }));
      }
      
      private function StartGame() : *
      {
         this.GameStarted = true;
         this.ButtonUseKey.Visible = true;
         this.ButtonStartGame.Visible = false;
         this.ButtonAutoAttempt.Visible = true;
         this.ButtonCancelLastPick.Visible = true;
         this.ButtonEliminateUnusedKeys.Visible = !this.Data.bHaveEliminatedUnusedKeys && Boolean(this.Data.bEliminateUnusedKeysOptionVisible);
         this.ButtonEliminateUnusedKeys.Enabled = !this.Data.bHaveEliminatedUnusedKeys && Boolean(this.Data.bEliminateUnusedKeysOptionAvailable) && this.Data.uiDigiPickCount > 0;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnSecurityDataChanged(param1:FromClientDataEvent) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         this.Data = param1.data;
         if(this.Data)
         {
            if(this.Data.bUnlocked == true)
            {
               this.DigiPick_mc.gotoAndPlay("hide");
               this.DigiKeyPanel_mc.gotoAndPlay("hide");
               this.DigiKeyPanel_mc.KeyPanel_mc.gotoAndPlay("hide");
               return;
            }
            GlobalFunc.SetText(this.DigiKeyPanel_mc.LinkedObject_mc.text_tf,this.Data.strLockedRefName.toUpperCase());
            GlobalFunc.SetText(this.DigiKeyPanel_mc.SecurityLevel_mc.text_tf,this.Data.strLockLevel.toUpperCase());
            this.DigiPick_mc.RingHighlightingEnabled = this.Data.bRingHighlightingEnabled;
            this.DigiPick_mc.SetDigiPickData(this.Data);
            this.DigiKeyPanel_mc.SetKeyData(this.Data.KeyDataA.dataA);
            if(this.Data.KeyDataA.dataA.length > 0)
            {
               _loc4_ = {
                  "uiRotatePosition":this.DigiKeyPanel_mc.GetCurrentKeyRotation(),
                  "uiPickDataA":this.Data.KeyDataA.dataA[this.DigiKeyPanel_mc.selectedKey].TeethA.slice()
               };
               this.DigiPick_mc.SetPickRingData(_loc4_);
            }
            this.DigiKeyPanel_mc.SelectUnusedKey(this.Data.KeyDataA.dataA);
            if(this.ButtonCancelLastPick && this.ButtonAutoAttempt && Boolean(this.ButtonStartGame))
            {
               this.ButtonCancelLastPick.SetButtonData(new ButtonBaseData("$CANCEL_PICK",[new UserEventData("XButton",this.OnCancelPick)],this.Data.uiDigiPickCount > 1,this.GameStarted,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,[this.Data.uiDigiPickCount.toString()]));
               this.ButtonAutoAttempt.SetButtonData(new ButtonBaseData("$AutoSlot",[new UserEventData("YButton",this.OnAutoAttempt)],this.Data.fAutoAttemptCount >= 1,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,[Math.floor(this.Data.fAutoAttemptCount).toString()]));
               this.ButtonAutoAttempt.FillPercent = this.Data.fAutoAttemptCount - Math.floor(this.Data.fAutoAttemptCount);
               this.ButtonStartGame.SetButtonData(new ButtonBaseData("$START_SECURITY_GAME",[new UserEventData("Accept",this.TryUseKey)],true,!this.GameStarted,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,[this.Data.uiDigiPickCount.toString()]));
            }
            _loc2_ = Math.min(this.Data.uiDigiPickCount,this.MAX_DIGIPICKS_TO_DISPLAY);
            GlobalFunc.SetText(this.DigiPickRemain_mc.DigiPicksNum_mc.text_tf,_loc2_.toString());
            _loc3_ = this.GameStarted ? 1 : 2;
            this.ButtonEliminateUnusedKeys.Visible = !this.Data.bHaveEliminatedUnusedKeys && Boolean(this.Data.bEliminateUnusedKeysOptionVisible);
            this.ButtonEliminateUnusedKeys.Enabled = !this.Data.bHaveEliminatedUnusedKeys && Boolean(this.Data.bEliminateUnusedKeysOptionAvailable) && this.Data.uiDigiPickCount >= _loc3_;
            if(!this.DataInitialized)
            {
               this.DataInitialized = true;
               this.DigiPick_mc.Start();
               this.DigiKeyPanel_mc.Start(this.RefreshPickRing);
               this.DigiKeyPanel_mc.ShowKeyRingPanel();
               this.ButtonUseKey.Visible = true;
               this.ButtonStartGame.Visible = false;
               this.ButtonAutoAttempt.Visible = true;
               this.ButtonCancelLastPick.Visible = true;
               this.ButtonBar_mc.RefreshButtons();
            }
         }
      }
      
      private function OnFireForgetEventData(param1:FromClientDataEvent) : *
      {
         if(GlobalFunc.HasFireForgetEvent(param1.data,"SecurityMenu_GameStarted"))
         {
            this.StartGame();
         }
         else if(GlobalFunc.HasFireForgetEvent(param1.data,"SecurityMenu_ExitCancelled"))
         {
            this.ExitingMenu = false;
         }
      }
      
      public function onRotateLeft() : *
      {
         if(this.DataInitialized)
         {
            this.DigiPick_mc.RotateLeft();
            this.DigiKeyPanel_mc.HandleRotation(false);
            GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Rotate");
         }
      }
      
      public function onRotateRight() : *
      {
         if(this.DataInitialized)
         {
            this.DigiPick_mc.RotateRight();
            this.DigiKeyPanel_mc.HandleRotation(true);
            GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Rotate");
         }
      }
      
      public function onNextKey() : *
      {
         this.DigiKeyPanel_mc.SelectNextUnusedKey(this.Data.KeyDataA.dataA,false);
         GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Select_Shape");
      }
      
      public function onPreviousKey() : *
      {
         this.DigiKeyPanel_mc.SelectNextUnusedKey(this.Data.KeyDataA.dataA,true);
         GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Select_Shape");
      }
      
      public function onNextRowKey() : *
      {
         this.DigiKeyPanel_mc.SelectNextRowUnusedKey(this.Data.KeyDataA.dataA,true);
         GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Select_Shape");
      }
      
      public function onPreviousRowKey() : *
      {
         this.DigiKeyPanel_mc.SelectNextRowUnusedKey(this.Data.KeyDataA.dataA,false);
         GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Select_Shape");
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            this.onRotateLeft();
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.onRotateRight();
            param1.stopPropagation();
         }
      }
   }
}

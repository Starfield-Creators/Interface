package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextLineMetrics;
   
   public class CompleteConfirm extends MovieClip
   {
      
      public static const COMPLETE_CONFIRM_IS_INACTIVE:String = "Complete_Confirm_Is_Inactive";
      
      public static const CYCLE_PRONOUN:String = "CharGen_CyclePronoun";
      
      public static const SET_PRONOUN:String = "CharGen_SetPronoun";
      
      private static const LABEL_SPACING:uint = 10;
      
      public static const UPDATE_BUTTONS:String = "CompleteConfirm::UpdateButtons";
      
      public static const FROM_TIMELINE_CLOSE_ANIM_FINISHED:String = "FROM_TIMELINE_CLOSE_ANIM_FINISHED";
      
      public static const START_MENU_CLOSE:String = "START_MENU_CLOSE";
       
      
      public var EnterName_mc:MovieClip;
      
      public var SkillsetTraits_mc:MovieClip;
      
      public var ConfirmButtonBar_mc:ButtonBar;
      
      private var bWaitForUpdate:Boolean = false;
      
      private var bActive:Boolean = false;
      
      private var bPronounChangedByUser:Boolean = false;
      
      private var bBackgroundSelected:Boolean = false;
      
      private const BUTTON_COLOR:uint = 2308933;
      
      private var SalonMode:Boolean = false;
      
      private var KBM:Boolean = false;
      
      private var ButtonName:IButton = null;
      
      private var ButtonPronoun:IButton = null;
      
      private var ButtonConfirm:IButton = null;
      
      private var ButtonCancel:IButton = null;
      
      private var CancelButtonData:ButtonBaseData = null;
      
      private var CancelTextEntryButtonData:ButtonBaseData = null;
      
      private var bClosing:Boolean = false;
      
      public function CompleteConfirm()
      {
         super();
         this.EnterName_mc.addEventListener(MouseEvent.CLICK,this.StartTextEntry);
         this.EnterName_mc.addEventListener(MouseEvent.ROLL_OVER,this.onNameRollover);
         this.EnterName_mc.addEventListener(MouseEvent.ROLL_OUT,this.onNameRollout);
         this.EnterName_mc.addEventListener(UPDATE_BUTTONS,this.UpdateButtons);
         BSUIDataManager.Subscribe("BackgroundData",this.OnBackgroundDataChanged);
         stage.addEventListener(BodyTypeStepper.ON_BODY_TYPE_CHANGED,this.HandleOnBodyTypeChanged);
         this.ConfirmButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel));
         this.CancelTextEntryButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Pause",this.onCancel));
         this.ButtonName = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$NAME_CHARACTER",new UserEventData("Accept",this.onEditName)),this.ConfirmButtonBar_mc);
         this.ButtonPronoun = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$PRONOUN",new UserEventData("YButton",this.onPronounCycle)),this.ConfirmButtonBar_mc);
         this.ButtonConfirm = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("XButton",this.ConfirmComplete)),this.ConfirmButtonBar_mc);
         this.ButtonCancel = ButtonFactory.AddToButtonBar("BasicButton",this.CancelButtonData,this.ConfirmButtonBar_mc);
         this.ConfirmButtonBar_mc.ButtonBarColor = this.BUTTON_COLOR;
         this.ConfirmButtonBar_mc.RefreshButtons();
      }
      
      private function get ignoreInput() : Boolean
      {
         return this.bWaitForUpdate || this.bClosing;
      }
      
      private function OnBackgroundDataChanged(param1:FromClientDataEvent) : *
      {
         this.bBackgroundSelected = param1.data.BackgroundSelected;
      }
      
      private function UpdateButtons() : *
      {
         var _loc1_:* = this.EnterName_mc.enteringText;
         this.ButtonName.Visible = !this.KBM || !_loc1_;
         this.ButtonPronoun.Visible = !this.KBM || !_loc1_;
         this.ButtonConfirm.Visible = !this.KBM || !_loc1_;
         this.ButtonCancel.SetButtonData(_loc1_ && this.KBM ? this.CancelTextEntryButtonData : this.CancelButtonData);
         this.ConfirmButtonBar_mc.RefreshButtons();
      }
      
      public function get enteringText() : Boolean
      {
         return this.EnterName_mc.enteringText;
      }
      
      public function SetData(param1:Object) : *
      {
         var _loc2_:TextLineMetrics = this.SkillsetTraits_mc.SkillSetLabel_mc.text_tf.getLineMetrics(0);
         this.SkillsetTraits_mc.Skillset_mc.x = _loc2_.x + _loc2_.width + LABEL_SPACING;
         GlobalFunc.SetText(this.SkillsetTraits_mc.Skillset_mc.text_tf,param1.sSkillSetText);
         var _loc3_:TextLineMetrics = this.SkillsetTraits_mc.TraitsTextLabel_mc.text_tf.getLineMetrics(0);
         this.SkillsetTraits_mc.TraitsNum_mc.x = _loc3_.x + _loc3_.width + LABEL_SPACING;
         GlobalFunc.SetText(this.SkillsetTraits_mc.TraitsNum_mc.text_tf,"(" + param1.uTraitCount.toString() + "/3):");
         var _loc4_:TextLineMetrics = this.SkillsetTraits_mc.TraitsNum_mc.text_tf.getLineMetrics(0);
         this.SkillsetTraits_mc.TraitsText_mc.x = this.SkillsetTraits_mc.TraitsNum_mc.x + _loc4_.x + _loc4_.width + LABEL_SPACING;
         GlobalFunc.SetText(this.SkillsetTraits_mc.TraitsText_mc.text_tf,param1.sTraitText);
         GlobalFunc.SetText(this.EnterName_mc.NameClip_mc.PronounText_tf,param1.sPronounChoice);
         this.SalonMode = param1.bSalonMode;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(this.ignoreInput)
         {
            return false;
         }
         if(!param2)
         {
            if(param1 == "Cancel")
            {
               this.onCancel();
               return true;
            }
            if(param1 == "XButton")
            {
               this.ConfirmComplete();
            }
            else
            {
               if(param1 == "Accept")
               {
                  if(this.EnterName_mc.enteringText)
                  {
                     this.EndTextEntry();
                  }
                  else
                  {
                     this.onAccept();
                  }
                  return true;
               }
               if(param1 == "YButton")
               {
                  this.onPronounCycle();
               }
            }
         }
         return false;
      }
      
      private function onEditName() : *
      {
         if(!this.EnterName_mc.enteringText)
         {
            this.StartTextEntry(this.KBM);
         }
      }
      
      private function onCancel() : *
      {
         if(this.ignoreInput)
         {
            return;
         }
         if(this.EnterName_mc.enteringText)
         {
            this.EndTextEntry();
         }
         dispatchEvent(new Event(COMPLETE_CONFIRM_IS_INACTIVE,true,true));
         gotoAndPlay("Close");
         this.active = false;
      }
      
      private function onAccept() : *
      {
         if(this.ignoreInput)
         {
            return;
         }
         if(this.EnterName_mc.enteringText)
         {
            this.ConfirmComplete();
         }
         else if(stage.focus == this.EnterName_mc)
         {
            this.StartTextEntry(this.KBM);
         }
      }
      
      private function onPronounCycle() : *
      {
         this.bPronounChangedByUser = true;
         BSUIDataManager.dispatchEvent(new Event(CYCLE_PRONOUN,true));
      }
      
      private function HandleOnBodyTypeChanged(param1:CustomEvent) : *
      {
         if(!this.bPronounChangedByUser)
         {
            if(param1.params.iBodyType == BodyTypeStepper.TYPE_2)
            {
               this.SetPronounBySex(CharGenMenu.FEMALE);
            }
            else
            {
               this.SetPronounBySex(CharGenMenu.MALE);
            }
         }
      }
      
      private function SetPronounBySex(param1:int) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(SET_PRONOUN,{"iPronoun":param1 + 1}));
      }
      
      private function ConfirmComplete() : *
      {
         if(this.ignoreInput)
         {
            return;
         }
         if(this.EnterName_mc.enteringText)
         {
            this.bWaitForUpdate = true;
            stage.addEventListener(CharGenMenu.CHAR_GEN_DATA_UPDATED,this.OnCharGenDataUpdated);
            this.EndTextEntry();
            return;
         }
         if(this.SalonMode || this.EnterName_mc.playerNameChanged && this.bBackgroundSelected)
         {
            this.bClosing = true;
            addEventListener(FROM_TIMELINE_CLOSE_ANIM_FINISHED,this.closeFinished);
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CLOSE);
            gotoAndPlay("Close");
         }
         else if(!this.bBackgroundSelected)
         {
            BSUIDataManager.dispatchEvent(new Event("CharGen_ShowChooseBackgroundMessage",true));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event(CharGenMenu.CharGen_ShowPlayerRenameMessage,true));
         }
      }
      
      private function closeFinished() : *
      {
         dispatchEvent(new Event(START_MENU_CLOSE,true,true));
      }
      
      private function OnCharGenDataUpdated(param1:Event) : *
      {
         this.bWaitForUpdate = false;
         this.ConfirmComplete();
         stage.removeEventListener(CharGenMenu.CHAR_GEN_DATA_UPDATED,this.OnCharGenDataUpdated);
      }
      
      private function StartTextEntry(param1:Boolean = false) : *
      {
         this.EnterName_mc.StartTextEntry(param1);
         this.UpdateButtons();
      }
      
      private function EndTextEntry() : *
      {
         this.EnterName_mc.EndEditText();
         this.UpdateButtons();
      }
      
      public function OnControlMapChange(param1:Boolean) : *
      {
         this.KBM = param1;
         this.UpdateButtons();
      }
      
      public function SetActiveForKBM() : *
      {
         this.KBM = true;
         this.active = true;
      }
      
      public function set active(param1:Boolean) : *
      {
         this.bActive = param1;
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetBlockInputUnderPopup",{"bShouldBlock":this.bActive}));
         if(param1)
         {
            stage.focus = this.EnterName_mc;
            this.visible = true;
            if(this.KBM)
            {
               this.StartTextEntry(this.KBM);
            }
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function get active() : Boolean
      {
         return this.bActive;
      }
      
      private function onNameRollover() : *
      {
         if(this.KBM && !this.EnterName_mc.enteringText)
         {
            stage.focus = this.EnterName_mc;
            this.EnterName_mc.gotoAndStop("selected");
         }
      }
      
      private function onNameRollout() : *
      {
         if(!this.EnterName_mc.enteringText)
         {
            this.EnterName_mc.gotoAndStop("unselected");
         }
      }
   }
}

package
{
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSStepper;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CharGenMenu extends IMenu
   {
      
      public static const CharGen_CloseMenu:String = "CharGen_CloseMenu";
      
      public static const CharGen_ShowPlayerRenameMessage:String = "CharGen_ShowPlayerRenameMessage";
      
      public static const CharGen_ConfirmExit:String = "CharGen_ConfirmExit";
      
      public static const CHAR_GEN_DATA_UPDATED:String = "CHAR_GEN_DATA_UPDATED";
      
      public static const UPDATE_BUTTONS:String = "UPDATE_BUTTONS";
      
      public static const BIOMETRIC_PAGE:uint = 0;
      
      public static const BODY_PAGE:uint = 1;
      
      public static const FACE_PAGE:uint = 2;
      
      public static const BACKGROUND_PAGE:uint = 3;
      
      public static const TRAITS_PAGE:uint = 4;
      
      public static var bNameChanged:Boolean = false;
      
      public static const MALE:int = 0;
      
      public static const FEMALE:int = 1;
      
      public static const OTHER:int = 2;
      
      public static const CHARGEN_MENU_SOUND_OPEN:String = "UIMenuChargenMenuOpen";
      
      public static const CHARGEN_MENU_SOUND_CLOSE:String = "UIMenuChargenMenuClose";
      
      public static const CHARGEN_MENU_SOUND_FOCUS:String = "UIMenuChargenGenericFocus";
      
      public static const CHARGEN_MENU_SOUND_TRAIT_SELECT:String = "UIMenuChargenTraitSelect";
      
      public static const CHARGEN_MENU_SOUND_REFINE:String = "UIMenuChargenRefine";
      
      public static const CHARGEN_MENU_SOUND_REFINE_CHANGE:String = "UIMenuChargenRefineChange";
      
      public static const CHARGEN_MENU_SOUND_REFINE_FOCUS:String = "UIMenuChargenRefineFocus";
      
      public static const CHARGEN_MENU_SOUND_BODY_TYPE_SELECT:String = "UIMenuChargenBodyTypeSelect";
      
      public static const CHARGEN_MENU_SOUND_BODY_TYPE_DESELECT:String = "UIMenuChargenBodyTypeDeselect";
      
      public static const CHARGEN_MENU_SOUND_CHECK_APPLY:String = "UIMenuChargenCheckApply";
      
      public static const CHARGEN_MENU_SOUND_CHECK_REMOVE:String = "UIMenuChargenCheckRemove";
      
      public static const CHARGEN_MENU_SOUND_EXIT:String = "UIMenuChargenMenuExit";
      
      public static const CHARGEN_MENU_SOUND_CHARACTER_NAME_TYPE:String = "UIMenuChargenCharacterNameCharacterType";
      
      public static const FROM_TIMELINE_MENU_CLOSE_ANIM_FINISHED:String = "FROM_TIMELINE_MENU_CLOSE_ANIM_FINISHED";
      
      public static const FROM_TIMELINE_DISABLE_PAPERDOLL:String = "UIMenuChargenMenuDisablePaperdoll";
      
      internal static const FACE_CAMERA_POSITION:uint = 0;
      
      internal static const BODY_CAMERA_POSITION:uint = 1;
      
      internal static const BACKGROUND_CAMERA_POSITION:uint = 2;
      
      internal static const PRESET_CAMERA_POSITION:uint = 3;
      
      internal static const TRAITS_CAMERA_POSITION:uint = 4;
      
      private static var CharacterDirty:Boolean = false;
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CharGen_Menu_Header_mc:MovieClip;
      
      public var Logo_GenomicSolutions_mc:MovieClip;
      
      public var GenomeQuery_mc:MovieClip;
      
      public var Grid_mc:MovieClip;
      
      public var Grid_Dots_mc:MovieClip;
      
      public var BiometricPage_mc:BiometricPage;
      
      public var BodyPage_mc:MovieClip;
      
      public var FacePage_mc:MovieClip;
      
      public var BackgroundPage_mc:BackgroundPage;
      
      public var TraitsPage_mc:MovieClip;
      
      public var AlertPopup_mc:MovieClip;
      
      public var Tab_mc:TabBar;
      
      public var SalonMenu_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var CompletePopup_mc:CompleteConfirm;
      
      public var ChargenPaperdollSceneRect_mc:BSAnimating3DSceneRect;
      
      public var ConfirmDestroy_mc:ChargenConfirmDestructiveChanges;
      
      public var PagesA:Array;
      
      public var CurrentPage:uint = 0;
      
      private var ChargenData:Object;
      
      private var ButtonCancel:IButton = null;
      
      private var ButtonAccept:IButton = null;
      
      private var ButtonModify:IButton = null;
      
      private var ButtonChange:IButton = null;
      
      private var ButtonRotate:IButton = null;
      
      private var PreviewHabSuit:IButton = null;
      
      private var ButtonBack:IButton = null;
      
      private var ButtonSelect:IButton = null;
      
      private var ButtonConfrim:IButton = null;
      
      private var LastFocus:InteractiveObject = null;
      
      private var TabsA:Array;
      
      private var PronounsA:Array;
      
      private var SalonMode:Boolean = false;
      
      private var RightMouseButtonHeld:Boolean = false;
      
      private var PaperDollRotateLastMouseX:Number = 0;
      
      private var PaperDollRotateLastMouseY:Number = 0;
      
      private var ControlMapData:Object = null;
      
      private var PagesInitialized:Boolean = true;
      
      private const BUTTON_COLOR:uint = 2308933;
      
      private var Initialized:Boolean = false;
      
      public function CharGenMenu()
      {
         this.PagesA = new Array();
         this.TabsA = new Array();
         this.PronounsA = ["$HE_HIM","$SHE_HER","$THEY_THEM"];
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         this.ButtonAccept = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CUSTOMIZE",[new UserEventData("Accept",this.FacePage_mc.onAccept)]),this.ButtonBar_mc);
         this.ButtonModify = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$MODIFY",[new UserEventData("LeftStick",null)]),this.ButtonBar_mc);
         this.ButtonSelect = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT",[new UserEventData("Accept",this.BodyPage_mc.SetWeightActive)]),this.ButtonBar_mc);
         this.ButtonConfrim = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",[new UserEventData("Accept",this.BodyPage_mc.onConfirm)]),this.ButtonBar_mc);
         this.ButtonChange = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CHANGE",[new UserEventData("Left",null),new UserEventData("Right",null)]),this.ButtonBar_mc);
         (this.ButtonChange as ButtonBase).addEventListener(MouseEvent.CLICK,this.onButtonChangeClick);
         this.PreviewHabSuit = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$Chargen_PreviewHabSuit",[new UserEventData("R3",this.onPreviewHabSuit)]),this.ButtonBar_mc);
         this.ButtonRotate = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$ROTATE",[new UserEventData("Rotate",null)]),this.ButtonBar_mc);
         this.ButtonCancel = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$FINISH",[new UserEventData("XButton",this.ShowNameAndConfirm)]),this.ButtonBar_mc);
         this.ButtonBack = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$BACK",[new UserEventData("Cancel",null)]),this.ButtonBar_mc);
         this.ButtonBar_mc.ButtonBarColor = this.BUTTON_COLOR;
         this.ButtonBar_mc.RefreshButtons();
         this.TraitsPage_mc.SetTraitCountTextField(this.Tab_mc.Traits_mc.text_tf);
         this.Tab_mc.LB_mc.SetButtonData(new ButtonBaseData("",new UserEventData("LShoulder",this.onTabLeft)));
         this.Tab_mc.RB_mc.SetButtonData(new ButtonBaseData("",new UserEventData("RShoulder",this.onTabRight)));
         this.CompletePopup_mc.addEventListener(CompleteConfirm.COMPLETE_CONFIRM_IS_INACTIVE,this.HandleCompletePopupIsInactive);
         this.CompletePopup_mc.addEventListener(UPDATE_BUTTONS,this.UpdateButtons);
         BSUIDataManager.Subscribe("ChargenData",this.OnChargenDataChanged);
         BSUIDataManager.Subscribe("ChargenMenuModeData",this.OnMenuModeDataChanged);
         this.addEventListener(MouseEvent.MOUSE_MOVE,function(param1:MouseEvent):*
         {
            if(RightMouseButtonHeld)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_RotatePaperdoll",{
                  "fMouseXChange":stage.mouseX - PaperDollRotateLastMouseX,
                  "fMouseYChange":stage.mouseY - PaperDollRotateLastMouseY
               }));
               PaperDollRotateLastMouseX = stage.mouseX;
               PaperDollRotateLastMouseY = stage.mouseY;
            }
         });
         this.ChargenPaperdollSceneRect_mc.SetBackgroundColor(3317809663);
         BS3DSceneRectManager.Register3DSceneRect(this.ChargenPaperdollSceneRect_mc);
         this.BodyPage_mc.addEventListener(UPDATE_BUTTONS,this.UpdateButtons);
         this.BiometricPage_mc.FacialFeatures_mc.addEventListener(BSStepper.CONFIRM_INPUT_CHANGED,this.ConfirmPresetChange);
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_OPEN);
         this.ConfirmDestroy_mc.addEventListener(ChargenConfirmDestructiveChanges.CONFIRM_FINISHED,this.onDestructionConfirmFinished);
         this.CompletePopup_mc.addEventListener(CompleteConfirm.START_MENU_CLOSE,this.onCompleted);
      }
      
      public static function get nameChanged() : *
      {
         return bNameChanged;
      }
      
      public static function set characterDirty(param1:Boolean) : *
      {
         CharacterDirty = param1;
      }
      
      private function SwitchToBiometric() : *
      {
         this.SetCurrentPage(BIOMETRIC_PAGE);
      }
      
      private function SwitchToBody() : *
      {
         this.SetCurrentPage(BODY_PAGE);
      }
      
      private function SwitchToFace() : *
      {
         this.SetCurrentPage(FACE_PAGE);
      }
      
      private function SwitchToBackground() : *
      {
         this.SetCurrentPage(BACKGROUND_PAGE);
      }
      
      private function SwitchToTraits() : *
      {
         this.SetCurrentPage(TRAITS_PAGE);
      }
      
      private function onCompleted() : *
      {
         if(this.SalonMode)
         {
            BSUIDataManager.dispatchEvent(new Event(CharGen_CloseMenu,true));
         }
         else
         {
            switch(this.CurrentPage)
            {
               case BIOMETRIC_PAGE:
               case BODY_PAGE:
               case FACE_PAGE:
                  gotoAndPlay("CloseFirstThreeTabs");
                  break;
               case BACKGROUND_PAGE:
               case TRAITS_PAGE:
                  gotoAndPlay("Close");
            }
            addEventListener(FROM_TIMELINE_MENU_CLOSE_ANIM_FINISHED,this.onCloseMenu);
         }
      }
      
      private function onCloseMenu() : *
      {
         BSUIDataManager.dispatchEvent(new Event(CharGen_CloseMenu,true));
      }
      
      private function SetPage(param1:uint) : *
      {
         if(!this.Initialized && !this.SalonMode)
         {
            this.Initialized = true;
            gotoAndPlay(1);
         }
         else
         {
            switch(param1)
            {
               case BIOMETRIC_PAGE:
                  gotoAndStop("BiometricPage");
                  break;
               case BODY_PAGE:
                  gotoAndStop("BodyPage");
                  break;
               case FACE_PAGE:
                  gotoAndStop("FacePage");
                  break;
               case BACKGROUND_PAGE:
                  gotoAndStop("BackgroundPage");
                  break;
               case TRAITS_PAGE:
                  gotoAndStop("TraitsPage");
            }
         }
      }
      
      private function SetCurrentPage(param1:uint) : *
      {
         this.SetPage(param1);
         if(!this.SalonMode)
         {
            switch(param1)
            {
               case BIOMETRIC_PAGE:
               case BODY_PAGE:
               case FACE_PAGE:
                  this.Background_mc.gotoAndStop("Chargen");
                  break;
               case BACKGROUND_PAGE:
               case TRAITS_PAGE:
                  this.Background_mc.gotoAndStop("ChargenPaperdollHidden");
            }
         }
         var _loc2_:uint = this.CurrentPage;
         if(_loc2_ == BODY_PAGE)
         {
            this.PagesA[_loc2_].clip.ForceWeightInactive();
         }
         if(this.CurrentPage != param1)
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralCategory");
         }
         this.CurrentPage = param1;
         if(this.TabsA.length > 0)
         {
            this.TabsA[_loc2_].gotoAndStop("Unselected");
            this.TabsA[this.CurrentPage].gotoAndStop("Selected");
         }
         this.PagesA[_loc2_].clip.onExitPage();
         stage.focus = this.PagesA[this.CurrentPage].clip;
         if(this.ChargenData != null)
         {
            this.PagesA[this.CurrentPage].clip.UpdateData(this.ChargenData);
         }
         this.UpdateButtons();
         this.PagesA[this.CurrentPage].clip.onEnterPage();
      }
      
      protected function TryUpdatePagesControlMapData() : *
      {
         var _loc1_:uint = 0;
         this.PagesInitialized = this.PagesA.length > 0;
         if(this.PagesInitialized)
         {
            _loc1_ = 0;
            while(_loc1_ < this.PagesA.length && this.PagesA[this.CurrentPage].clip != null)
            {
               this.PagesA[_loc1_].clip.OnControlMapChanged(this.ControlMapData);
               _loc1_++;
            }
         }
         if(this.PagesInitialized)
         {
            removeEventListener(Event.ENTER_FRAME,this.TryUpdatePagesControlMapData);
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         this.ControlMapData = GlobalFunc.CloneObject(param1);
         super.OnControlMapChanged(param1);
         if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE && this.CurrentPage < this.TabsA.length && !this.CompletePopup_mc.active)
         {
            switch(this.CurrentPage)
            {
               case BIOMETRIC_PAGE:
                  this.BiometricPage_mc.InitFocus();
                  break;
               case BODY_PAGE:
                  this.BodyPage_mc.InitFocus();
                  break;
               case FACE_PAGE:
                  this.FacePage_mc.InitFocus();
                  break;
               case BACKGROUND_PAGE:
                  this.BackgroundPage_mc.InitFocus();
                  break;
               case TRAITS_PAGE:
                  this.TraitsPage_mc.InitFocus();
            }
         }
         this.CompletePopup_mc.OnControlMapChange(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE);
         addEventListener(Event.ENTER_FRAME,this.TryUpdatePagesControlMapData);
      }
      
      private function OnChargenDataChanged(param1:FromClientDataEvent) : void
      {
         this.ChargenData = param1.data;
         this.CompletePopup_mc.SetData({
            "uTraitCount":this.TraitsPage_mc.QTraitCount(),
            "sSkillSetText":this.BackgroundPage_mc.GetSelectedBackgroundText(),
            "sTraitText":this.TraitsPage_mc.QTraitsText(),
            "sPronounChoice":this.PronounsA[this.ChargenData.uPronounChoice - 1],
            "bSalonMode":this.SalonMode
         });
         bNameChanged = param1.data.bPlayerNamed;
         if(this.CurrentPage < this.PagesA.length)
         {
            this.PagesA[this.CurrentPage].clip.UpdateData(this.ChargenData);
         }
         stage.dispatchEvent(new Event(CHAR_GEN_DATA_UPDATED));
      }
      
      private function ConfirmPresetChange(param1:CustomEvent) : void
      {
         if(CharacterDirty)
         {
            this.ConfirmDestroy_mc.SetActive(true,param1.params.Func);
            stage.focus = this.ConfirmDestroy_mc;
         }
         else
         {
            param1.params.Func();
         }
      }
      
      private function onDestructionConfirmFinished() : *
      {
         this.BiometricPage_mc.InitFocus();
      }
      
      private function OnMenuModeDataChanged(param1:FromClientDataEvent) : void
      {
         this.ChargenData = param1.data;
         switch(this.ChargenData.uiMode)
         {
            case 2:
               this.gotoAndStop(BODY_PAGE);
               this.Tab_mc.gotoAndStop("Salon");
               this.Header_mc.gotoAndStop("Salon");
               this.Background_mc.gotoAndStop("Salon");
               this.TabsA.splice(0);
               this.TabsA.push(this.Tab_mc.Biometric_mc);
               this.TabsA.push(this.Tab_mc.Body_mc);
               this.TabsA.push(this.Tab_mc.Face_mc);
               this.TabsA.push(this.Tab_mc.Background_mc);
               this.TabsA.push(this.Tab_mc.Traits_mc);
               this.PagesA.splice(0);
               this.PagesA.push({
                  "clip":this.BiometricPage_mc,
                  "visible":false
               });
               this.PagesA.push({
                  "clip":this.BodyPage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.FacePage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.BackgroundPage_mc,
                  "visible":false
               });
               this.PagesA.push({
                  "clip":this.TraitsPage_mc,
                  "visible":false
               });
               this.SetCurrentPage(BODY_PAGE);
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":BODY_CAMERA_POSITION}));
               this.SalonMode = true;
               break;
            default:
               this.Tab_mc.gotoAndStop("Chargen");
               this.Header_mc.gotoAndStop("Chargen");
               this.Background_mc.gotoAndStop("Chargen");
               this.TabsA.splice(0);
               this.TabsA.push(this.Tab_mc.Biometric_mc);
               this.TabsA.push(this.Tab_mc.Body_mc);
               this.TabsA.push(this.Tab_mc.Face_mc);
               this.TabsA.push(this.Tab_mc.Background_mc);
               this.TabsA.push(this.Tab_mc.Traits_mc);
               this.PagesA.splice(0);
               this.PagesA.push({
                  "clip":this.BiometricPage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.BodyPage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.FacePage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.BackgroundPage_mc,
                  "visible":true
               });
               this.PagesA.push({
                  "clip":this.TraitsPage_mc,
                  "visible":true
               });
               this.SetCurrentPage(BIOMETRIC_PAGE);
         }
         this.TabsA.push(this.Tab_mc.Biometric_mc);
         this.Tab_mc.Biometric_mc.addEventListener(MouseEvent.CLICK,this.SwitchToBiometric);
         this.TabsA.push(this.Tab_mc.Body_mc);
         this.Tab_mc.Body_mc.addEventListener(MouseEvent.CLICK,this.SwitchToBody);
         this.TabsA.push(this.Tab_mc.Face_mc);
         this.Tab_mc.Face_mc.addEventListener(MouseEvent.CLICK,this.SwitchToFace);
         this.TabsA.push(this.Tab_mc.Background_mc);
         this.Tab_mc.Background_mc.addEventListener(MouseEvent.CLICK,this.SwitchToBackground);
         this.TabsA.push(this.Tab_mc.Traits_mc);
         this.Tab_mc.Traits_mc.addEventListener(MouseEvent.CLICK,this.SwitchToTraits);
      }
      
      public function IsCompletePopupActive() : Boolean
      {
         return this.CompletePopup_mc.active;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == false)
         {
            if(this.CompletePopup_mc.active)
            {
               _loc3_ = this.CompletePopup_mc.ProcessUserEvent(param1,param2);
            }
            else if(this.ConfirmDestroy_mc.active)
            {
               _loc3_ = this.ConfirmDestroy_mc.ProcessUserEvent(param1,param2);
            }
            else if(param1 == "LShoulder")
            {
               this.onTabLeft();
               _loc3_ = true;
            }
            else if(param1 == "RShoulder")
            {
               this.onTabRight();
               _loc3_ = true;
            }
            else if(param1 == "XButton")
            {
               this.ShowNameAndConfirm();
            }
            else if(param1 == "R3")
            {
               this.onPreviewHabSuit();
            }
            else
            {
               _loc3_ = Boolean(this.PagesA[this.CurrentPage].clip.ProcessUserEvent(param1,param2));
            }
         }
         if(param1 == "Rotate")
         {
            this.RightMouseButtonHeld = param2;
            this.PaperDollRotateLastMouseX = stage.mouseX;
            this.PaperDollRotateLastMouseY = stage.mouseY;
         }
         return _loc3_;
      }
      
      private function FindPreviousPage() : uint
      {
         var _loc1_:uint = this.CurrentPage;
         var _loc2_:int = int(this.CurrentPage - 1);
         while(_loc1_ == this.CurrentPage && _loc2_ >= 0)
         {
            if(this.PagesA[_loc2_].visible == true)
            {
               _loc1_ = uint(_loc2_);
            }
            _loc2_--;
         }
         return _loc1_;
      }
      
      private function onTabLeft() : *
      {
         var _loc1_:uint = this.FindPreviousPage();
         if(this.CurrentPage > 0 && _loc1_ != this.CurrentPage)
         {
            this.SetCurrentPage(_loc1_);
         }
      }
      
      private function FindNextPage() : uint
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = this.CurrentPage;
         if(this.CurrentPage < this.PagesA.length - 1)
         {
            _loc2_ = this.CurrentPage;
            while(_loc1_ == this.CurrentPage && _loc2_ < this.PagesA.length)
            {
               if(this.PagesA[_loc2_].visible == true)
               {
                  _loc1_ = _loc2_;
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      private function onTabRight() : *
      {
         var _loc1_:uint = this.FindNextPage();
         if(this.CurrentPage < this.PagesA.length - 1 && _loc1_ != this.CurrentPage)
         {
            this.SetCurrentPage(_loc1_);
         }
      }
      
      private function ShowNameAndConfirm() : *
      {
         if(this.SalonMode || this.BackgroundPage_mc.GetBackgroundSelected())
         {
            this.CompletePopup_mc.SetData({
               "uTraitCount":this.TraitsPage_mc.QTraitCount(),
               "sSkillSetText":this.BackgroundPage_mc.GetSelectedBackgroundText(),
               "sTraitText":this.TraitsPage_mc.QTraitsText(),
               "sPronounChoice":this.PronounsA[this.ChargenData.uPronounChoice - 1],
               "bSalonMode":this.SalonMode
            });
            this.CompletePopup_mc.gotoAndPlay("Open");
            this.LastFocus = stage.focus;
            stage.focus = this.CompletePopup_mc;
            if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
            {
               this.CompletePopup_mc.SetActiveForKBM();
            }
            else
            {
               this.CompletePopup_mc.active = true;
            }
            this.SetMouseEventsForCompleteConfirm(false);
            this.UpdateButtons();
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_EXIT);
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event("CharGen_ShowChooseBackgroundMessage",true));
         }
      }
      
      private function HandleCompletePopupIsInactive(param1:Event) : *
      {
         this.SetMouseEventsForCompleteConfirm(true);
         stage.focus = this.LastFocus;
         this.UpdateButtons();
      }
      
      private function SetMouseEventsForCompleteConfirm(param1:Boolean) : *
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_) as MovieClip;
            if(Boolean(_loc3_) && _loc3_ != this.CompletePopup_mc)
            {
               _loc3_.mouseEnabled = _loc3_.mouseChildren = param1;
            }
            _loc2_++;
         }
      }
      
      public function UpdateButtons() : *
      {
         switch(this.currentFrame - 1)
         {
            case BIOMETRIC_PAGE:
               this.PreviewHabSuit.Visible = false;
               this.ButtonCancel.Visible = true;
               this.ButtonAccept.Visible = false;
               this.ButtonModify.Visible = false;
               this.ButtonChange.Visible = true;
               this.ButtonSelect.Visible = false;
               this.ButtonBack.Visible = false;
               this.ButtonConfrim.Visible = false;
               this.ButtonRotate.Visible = true;
               break;
            case BODY_PAGE:
               this.PreviewHabSuit.Visible = true;
               this.ButtonCancel.Visible = true;
               this.ButtonAccept.Visible = false;
               this.ButtonModify.Visible = Boolean(this.BodyPage_mc.ShowModify()) && uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
               this.ButtonChange.Visible = false;
               this.ButtonConfrim.Visible = !this.BodyPage_mc.ShowSelect() && Boolean(this.BodyPage_mc.ShowBack());
               this.ButtonSelect.Visible = this.BodyPage_mc.ShowSelect();
               this.ButtonBack.Visible = this.BodyPage_mc.ShowBack();
               this.ButtonRotate.Visible = true;
               break;
            case FACE_PAGE:
               this.PreviewHabSuit.Visible = false;
               this.ButtonCancel.Visible = true;
               this.ButtonAccept.Visible = true;
               this.ButtonModify.Visible = false;
               this.ButtonChange.Visible = !this.FacePage_mc.IsSliderListActive();
               this.ButtonSelect.Visible = false;
               this.ButtonBack.Visible = false;
               this.ButtonConfrim.Visible = false;
               this.ButtonRotate.Visible = true;
               break;
            case BACKGROUND_PAGE:
               this.PreviewHabSuit.Visible = false;
               this.ButtonCancel.Visible = true;
               this.ButtonAccept.Visible = false;
               this.ButtonModify.Visible = false;
               this.ButtonChange.Visible = false;
               this.ButtonSelect.Visible = false;
               this.ButtonBack.Visible = false;
               this.ButtonConfrim.Visible = false;
               this.ButtonRotate.Visible = false;
               break;
            case TRAITS_PAGE:
               this.PreviewHabSuit.Visible = false;
               this.ButtonCancel.Visible = true;
               this.ButtonAccept.Visible = false;
               this.ButtonModify.Visible = false;
               this.ButtonChange.Visible = false;
               this.ButtonSelect.Visible = false;
               this.ButtonBack.Visible = false;
               this.ButtonConfrim.Visible = false;
               this.ButtonRotate.Visible = false;
         }
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function onButtonChangeClick() : *
      {
         switch(this.currentFrame - 1)
         {
            case BIOMETRIC_PAGE:
               this.BiometricPage_mc.onPresetChangeRight();
               break;
            case FACE_PAGE:
               this.FacePage_mc.onChangeButtonHit();
         }
      }
      
      public function onPreviewHabSuit() : *
      {
         if(this.CurrentPage == BODY_PAGE)
         {
            BSUIDataManager.dispatchEvent(new Event("CharGen_TogglePreviewHabSuit",true));
         }
      }
   }
}

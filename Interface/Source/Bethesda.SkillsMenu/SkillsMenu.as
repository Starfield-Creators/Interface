package
{
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.SkillsUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class SkillsMenu extends IMenu
   {
      
      private static var OverConstantLeftTab:* = false;
      
      private static var OverConstantRightTab:* = false;
      
      public static const UPDATE_CATEGORIES_LEFT:String = "UpdateCategoriesLeft";
      
      public static const UPDATE_CATEGORIES_RIGHT:String = "UpdateCategoriesRight";
      
      private static var _currentCategory:uint = 1;
      
      public static const SET_CATEGORY:String = "Set_Category";
      
      public static const TIMELINE_CLOSE_SCREEN:String = "Timeline_Close_Screen";
       
      
      public var InspectPopup_mc:SkillsPopupWidget;
      
      public var SkillDescription_mc:PatchInfoCard;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Tab_mc:TabBar;
      
      public var TestText_tf:TextField;
      
      public var SkillPoints_mc:MovieClip;
      
      public var Vignette_mc:MovieClip;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      public var SkillTab1:MovieClip;
      
      public var SkillTab2:MovieClip;
      
      public var SkillTab3:MovieClip;
      
      public var SkillTab4:MovieClip;
      
      public var SkillTab5:MovieClip;
      
      public var RightTabCatcher_mc:MovieClip;
      
      public var LeftTabCatcher_mc:MovieClip;
      
      public var ConstantTabLeftCatcher_mc:MovieClip;
      
      public var ConstantTabRightCatcher_mc:MovieClip;
      
      private var OverRightTabCatcher:Boolean = false;
      
      private var OverLeftTabCatcher:Boolean = false;
      
      private const ON_ACCEPT:String = "SkillsMenu_Accept";
      
      private const ON_CLOSE_MENU:String = "SkillsMenu_Cancel";
      
      private const CHANGE_CURSOR_VISIBILITY:String = "SkillsMenu_ChangeCursorVisibility";
      
      private var MaxCategory:uint = 5;
      
      private var InitializedLastCategory:Boolean = false;
      
      private var bReturningToGame:Boolean = false;
      
      private var SkillsWidget:SkillsPatchWidget;
      
      private var SkillTierText:Array;
      
      private var bClosing:Boolean = false;
      
      private var ClosingTabPostions:Array;
      
      public function SkillsMenu()
      {
         var _loc3_:* = undefined;
         this.SkillTierText = ["","_ADVANCED","_EXPERT","_MASTER"];
         this.ClosingTabPostions = new Array(5);
         super();
         var _loc1_:String = "$EXIT HOLD";
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.onExitMenu),new UserEventData("",this.onCloseSubMenuToGame)]));
         gotoAndPlay("Open");
         this.PreviewSceneRect_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PreviewSceneRect_mc);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         this.ButtonBar_mc.AddButtonWithData(this.ConfirmButton,new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept,"")));
         this.ConfirmButton.Visible = false;
         this.ButtonBar_mc.RefreshButtons();
         this.SetPopupVisibility(false,false);
         addEventListener(UPDATE_CATEGORIES_LEFT,this.ChangeCategoriesLeft);
         addEventListener(UPDATE_CATEGORIES_RIGHT,this.ChangeCategoriesRight);
         stage.addEventListener(PatchClip.PATCH_SELECTED,this.onConfirmSkill);
         stage.addEventListener(PatchClip.PATCH_SELECTION_CHANGED,this.onSelectionChanged);
         this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         this.Tab_mc.addEventListener(TabBar.TAB_LEFT,this.onTabLeft);
         this.LeftTabCatcher_mc.addEventListener(MouseEvent.CLICK,this.onTabLeft);
         this.LeftTabCatcher_mc.addEventListener(MouseEvent.ROLL_OVER,this.onTabLeftRollover);
         this.LeftTabCatcher_mc.addEventListener(MouseEvent.ROLL_OUT,this.onTabLeftRollout);
         this.Tab_mc.addEventListener(TabBar.TAB_RIGHT,this.onTabRight);
         this.RightTabCatcher_mc.addEventListener(MouseEvent.CLICK,this.onTabRight);
         this.RightTabCatcher_mc.addEventListener(MouseEvent.ROLL_OVER,this.onTabRightRollover);
         this.RightTabCatcher_mc.addEventListener(MouseEvent.ROLL_OUT,this.onTabRightRollout);
         this.Tab_mc.addEventListener(TabBar.SET_CATEGORY,this.onSetCategory);
         this.ConstantTabLeftCatcher_mc.addEventListener(MouseEvent.ROLL_OVER,this.onConstantTabLeftRollover);
         this.ConstantTabLeftCatcher_mc.addEventListener(MouseEvent.ROLL_OUT,this.onConstantTabLeftRollout);
         this.ConstantTabRightCatcher_mc.addEventListener(MouseEvent.ROLL_OVER,this.onConstantTabRightRollover);
         this.ConstantTabRightCatcher_mc.addEventListener(MouseEvent.ROLL_OUT,this.onConstantTabRightRollout);
         stage.addEventListener(SET_CATEGORY,this.onTimelineSetCategory);
         stage.addEventListener(TIMELINE_CLOSE_SCREEN,this.onTimelineCloseScreen);
         var _loc2_:int = 1;
         while(_loc2_ <= 5)
         {
            _loc3_ = this["SkillTab" + _loc2_.toString()];
            _loc3_.Header_mc.gotoAndStop("Cat" + _loc2_);
            _loc2_++;
         }
         BSUIDataManager.Subscribe("PlayerData",this.onPlayerDataUpdate);
         BSUIDataManager.Subscribe("PatchData",this.onPatchDataUpdate);
         GlobalFunc.PlayMenuSound("UIMenuSkillsMenuOpen");
         _currentCategory = SkillsUtils.COMBAT;
      }
      
      public static function get shouldScrollRight() : Boolean
      {
         return _currentCategory != previousCategory && OverConstantLeftTab;
      }
      
      public static function get shouldScrollLeft() : Boolean
      {
         return _currentCategory != nextCategory && OverConstantRightTab;
      }
      
      private static function get previousCategory() : uint
      {
         switch(_currentCategory)
         {
            case SkillsUtils.COMBAT:
               return SkillsUtils.SOCIAL;
            case SkillsUtils.SCIENCE:
               return SkillsUtils.COMBAT;
            case SkillsUtils.TECH:
               return SkillsUtils.SCIENCE;
            case SkillsUtils.SOCIAL:
               return SkillsUtils.PHYSICAL;
            case SkillsUtils.PHYSICAL:
               return SkillsUtils.PHYSICAL;
            default:
               return SkillsUtils.COMBAT;
         }
      }
      
      private static function get nextCategory() : uint
      {
         switch(_currentCategory)
         {
            case SkillsUtils.COMBAT:
               return SkillsUtils.SCIENCE;
            case SkillsUtils.SCIENCE:
               return SkillsUtils.TECH;
            case SkillsUtils.TECH:
               return SkillsUtils.TECH;
            case SkillsUtils.SOCIAL:
               return SkillsUtils.COMBAT;
            case SkillsUtils.PHYSICAL:
               return SkillsUtils.SOCIAL;
            default:
               return SkillsUtils.COMBAT;
         }
      }
      
      private function get ConfirmButton() : IButton
      {
         return this.ButtonBar_mc.ConfirmButton_mc;
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      override public function onAddedToStage() : void
      {
         this.SkillsWidget = new SkillsPatchWidget();
         this.SkillsWidget.addEventListener(SkillsPatchWidget.PATCHES_LOADED,this.onPatchChanges);
      }
      
      private function set CurrentCategory(param1:int) : *
      {
         if(param1 != _currentCategory)
         {
            GlobalFunc.PlayMenuSound("UIMenuSkillsCategoryCycle");
         }
         if(param1 < SkillsUtils.COMBAT)
         {
            _currentCategory = SkillsUtils.SOCIAL;
         }
         else if(param1 > SkillsUtils.SOCIAL)
         {
            _currentCategory = SkillsUtils.COMBAT;
         }
         else
         {
            _currentCategory = param1;
         }
      }
      
      private function get CurrentCategory() : int
      {
         return _currentCategory;
      }
      
      public function PopulateTier(param1:MovieClip, param2:MovieClip, param3:uint, param4:uint, param5:uint) : *
      {
         param2.addChild(param1);
         var _loc6_:Number;
         var _loc7_:Number = (_loc6_ = Math.min(650,110 * param4)) / (param4 - 1);
         var _loc8_:Number = 0;
         if(param4 > 0)
         {
            _loc8_ = -(_loc6_ / 2) + param3 * _loc7_;
         }
         param1.x = _loc8_;
         param1.y = 15;
      }
      
      private function FillSkillRow(param1:MovieClip, param2:String, param3:uint, param4:Boolean = false) : *
      {
         var _loc6_:* = undefined;
         var _loc5_:uint = 1;
         while(Boolean(param1[param2 + _loc5_ + "_mc"]) && _loc5_ < 5)
         {
            param1[param2 + _loc5_ + "_mc"].removeChildren();
            _loc6_ = this.SkillsWidget.PopulateSkillTier(param1[param2 + _loc5_ + "_mc"],param3,_loc5_,this.PopulateTier);
            if(param4)
            {
               param1["RowBG" + _loc5_ + "_mc"].gotoAndStop(!!_loc6_ ? "Locked" : "Unlocked");
            }
            _loc5_++;
         }
      }
      
      private function GetCategoryName(param1:uint, param2:Boolean) : *
      {
         var _loc3_:uint = this.SkillsWidget.GetPatchSelectedIndex();
         switch(param1)
         {
            case SkillsUtils.COMBAT:
               if(_loc3_ != uint.MAX_VALUE && param2)
               {
                  return "$COMBAT_SKILLS" + this.SkillTierText[(this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc3_).uSkillGroup - 1];
               }
               return "$COMBAT";
               break;
            case SkillsUtils.SCIENCE:
               if(_loc3_ != uint.MAX_VALUE && param2)
               {
                  return "$SCIENCE_SKILLS" + this.SkillTierText[(this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc3_).uSkillGroup - 1];
               }
               return "$SCIENCE";
               break;
            case SkillsUtils.TECH:
               if(_loc3_ != uint.MAX_VALUE && param2)
               {
                  return "$TECH_SKILLS" + this.SkillTierText[(this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc3_).uSkillGroup - 1];
               }
               return "$TECH";
               break;
            case SkillsUtils.PHYSICAL:
               if(_loc3_ != uint.MAX_VALUE && param2)
               {
                  return "$PHYSICAL_SKILLS" + this.SkillTierText[(this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc3_).uSkillGroup - 1];
               }
               return "$PHYSICAL";
               break;
            case SkillsUtils.SOCIAL:
               if(_loc3_ != uint.MAX_VALUE && param2)
               {
                  return "$SOCIAL_SKILLS" + this.SkillTierText[(this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc3_).uSkillGroup - 1];
               }
               return "$SOCIAL";
               break;
            default:
               return;
         }
      }
      
      private function onPatchChanges() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:uint = 1;
         while(_loc1_ < 6)
         {
            _loc2_ = this["SkillTab" + _loc1_.toString()];
            this.FillSkillRow(_loc2_,"Row",_loc1_,true);
            GlobalFunc.SetText(_loc2_.Header_mc.SkillNameText_mc.text_tf,this.GetCategoryName(_loc1_,true));
            _loc2_.Header_mc.gotoAndStop("Cat" + _loc1_);
            _loc1_++;
         }
      }
      
      private function onSelectionChanged() : *
      {
      }
      
      private function ChangeCategoriesLeft() : *
      {
         if(this.CurrentCategory != previousCategory && !this.bClosing)
         {
            this.onPatchChanges();
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         }
      }
      
      private function ChangeCategoriesRight() : *
      {
         if(this.CurrentCategory != nextCategory && !this.bClosing)
         {
            this.onPatchChanges();
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         }
      }
      
      private function onConfirmSkill() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = this.SkillsWidget.GetPatchSelectedIndex();
         if(_loc2_ != uint.MAX_VALUE)
         {
            (this.InspectPopup_mc as SkillsPopupWidget).PopulateData((this.SkillsWidget as SkillsPatchWidget).GetPatchData(_loc2_));
            this.InspectPopup_mc.addEventListener(SkillsPopupWidget.VISIBILITY_CHANGE,this.onPopupVisibilityChange);
            this.InspectPopup_mc.addEventListener(SkillsPopupWidget.CLOSE_ALL_MENUS,this.onCloseSubMenuToGame);
            this.SetPopupVisibility(true);
            this.InspectPopup_mc.gotoAndPlay("Open");
            BSUIDataManager.dispatchEvent(new Event(this.ON_ACCEPT,true));
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function onAccept() : *
      {
         if(!this.onConfirmSkill())
         {
            if(this.OverLeftTabCatcher)
            {
               this.onTabLeft();
            }
            else if(this.OverRightTabCatcher)
            {
               this.onTabRight();
            }
            else
            {
               this.Tab_mc.onAccept();
            }
         }
      }
      
      private function SetPopupVisibility(param1:Boolean, param2:Boolean = true) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(this.CHANGE_CURSOR_VISIBILITY,{"SetVisible":!param1}));
         this.InspectPopup_mc.visible = param1;
         if(this.ConfirmButton)
         {
            this.ConfirmButton.Enabled = !param1;
         }
         if(this.CancelButton)
         {
            this.CancelButton.Enabled = !param1;
         }
         if(!param1)
         {
            this.InspectPopup_mc.CloseDownPopup();
            stage.focus = this;
            if(param2)
            {
               GlobalFunc.PlayMenuSound("UIMenuSkillsPopUpClose");
            }
         }
         else if(param2)
         {
            GlobalFunc.PlayMenuSound("UIMenuSkillsPopUpOpen");
         }
      }
      
      private function GetPopupVisible() : Boolean
      {
         return this.InspectPopup_mc.visible;
      }
      
      private function onPopupVisibilityChange(param1:CustomEvent) : *
      {
         this.InspectPopup_mc.removeEventListener(SkillsPopupWidget.VISIBILITY_CHANGE,this.onPopupVisibilityChange);
         this.InspectPopup_mc.removeEventListener(SkillsPopupWidget.CLOSE_ALL_MENUS,this.onCloseSubMenuToGame);
         this.SetPopupVisibility(param1.params.visible,param1.params.playSound);
      }
      
      private function onPlayerDataUpdate(param1:FromClientDataEvent) : *
      {
         GlobalFunc.SetText(this.SkillPoints_mc.SkillPoints_tf,param1.data.uSkillPoints.toString());
      }
      
      private function onPatchDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         if(this.InspectPopup_mc.visible)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.data.Patches.dataA.length)
            {
               if(this.InspectPopup_mc.GetPerkID() == param1.data.Patches.dataA[_loc2_].uPerkID)
               {
                  (this.InspectPopup_mc as SkillsPopupWidget).PopulateData(param1.data.Patches.dataA[_loc2_]);
                  break;
               }
               _loc2_++;
            }
         }
         if(param1.data.uLastCategory != 0)
         {
            this.onLastCategoryUpdate(param1.data.uLastCategory);
         }
      }
      
      private function onLastCategoryUpdate(param1:uint) : void
      {
         if(!this.InitializedLastCategory)
         {
            this.CurrentCategory = param1;
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
            switch(this.CurrentCategory)
            {
               case SkillsUtils.COMBAT:
                  this.gotoAndStop("CombatStopFrame");
                  this["SkillTab" + SkillsUtils.COMBAT].gotoAndPlay("OpenCenter");
                  this["SkillTab" + SkillsUtils.SOCIAL].gotoAndPlay("OpenLeft");
                  this["SkillTab" + SkillsUtils.SCIENCE].gotoAndPlay("OpenRight");
                  break;
               case SkillsUtils.SCIENCE:
                  this.gotoAndStop("ScienceStopFrame");
                  this["SkillTab" + SkillsUtils.SCIENCE].gotoAndPlay("OpenCenter");
                  this["SkillTab" + SkillsUtils.COMBAT].gotoAndPlay("OpenLeft");
                  this["SkillTab" + SkillsUtils.TECH].gotoAndPlay("OpenRight");
                  break;
               case SkillsUtils.TECH:
                  this.gotoAndStop("TechStopFrame");
                  this["SkillTab" + SkillsUtils.TECH].gotoAndPlay("OpenCenter");
                  this["SkillTab" + SkillsUtils.SCIENCE].gotoAndPlay("OpenLeft");
                  break;
               case SkillsUtils.SOCIAL:
                  this.gotoAndStop("SocialStopFrame");
                  this["SkillTab" + SkillsUtils.SOCIAL].gotoAndPlay("OpenCenter");
                  this["SkillTab" + SkillsUtils.PHYSICAL].gotoAndPlay("OpenLeft");
                  this["SkillTab" + SkillsUtils.COMBAT].gotoAndPlay("OpenRight");
                  break;
               case SkillsUtils.PHYSICAL:
                  this.gotoAndStop("PhysicalStopFrame");
                  this["SkillTab" + SkillsUtils.PHYSICAL].gotoAndPlay("OpenCenter");
                  this["SkillTab" + SkillsUtils.SOCIAL].gotoAndPlay("OpenRight");
            }
            this.InitializedLastCategory = true;
         }
      }
      
      private function onExitMenu() : *
      {
         if(this.InspectPopup_mc.visible == true)
         {
            this.SetPopupVisibility(false);
         }
         else
         {
            this.CloseMenu(false);
         }
      }
      
      private function onClosing() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         if(this.bClosing)
         {
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               _loc2_ = this["SkillTab" + _loc1_.toString()];
               _loc2_.x = this.ClosingTabPostions[_loc1_ - 1].x;
               _loc2_.y = this.ClosingTabPostions[_loc1_ - 1].y;
               _loc1_++;
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.bClosing)
         {
            return _loc3_;
         }
         if(!param2)
         {
            switch(param1)
            {
               case "LShoulder":
                  if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE && this.InspectPopup_mc.visible != true)
                  {
                     this.onTabLeft();
                     _loc3_ = true;
                  }
                  break;
               case "RShoulder":
                  if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE && this.InspectPopup_mc.visible != true)
                  {
                     this.onTabRight();
                     _loc3_ = true;
                  }
                  break;
               case "Left":
                  if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE && this.InspectPopup_mc.visible != true)
                  {
                     this.onTabLeft();
                     _loc3_ = true;
                  }
                  break;
               case "Right":
                  if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE && this.InspectPopup_mc.visible != true)
                  {
                     this.onTabRight();
                     _loc3_ = true;
                  }
                  break;
               case "Skills":
                  if(this.InspectPopup_mc.visible != true)
                  {
                     this.CloseMenu(true);
                     _loc3_ = true;
                  }
                  break;
               case "Accept":
                  if(this.OverLeftTabCatcher)
                  {
                     this.onTabLeft();
                     _loc3_ = true;
                  }
                  else if(this.OverRightTabCatcher)
                  {
                     this.onTabRight();
                     _loc3_ = true;
                  }
            }
         }
         if(!_loc3_)
         {
            if(this.InspectPopup_mc.visible)
            {
               _loc3_ = this.InspectPopup_mc.ProcessUserEvent(param1,param2);
            }
            else
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         if(param4)
         {
            if(param2 >= 0.25)
            {
               this.InspectPopup_mc.ProcessUserEvent("Down",true);
            }
            else if(param2 <= -0.25)
            {
               this.InspectPopup_mc.ProcessUserEvent("Up",true);
            }
         }
      }
      
      private function onTabLeft() : *
      {
         if(this.CurrentCategory != previousCategory && !this.bClosing)
         {
            this.CurrentCategory = previousCategory;
            gotoAndPlay("RightTo" + this.CurrentCategory.toString());
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         }
      }
      
      private function onTabRight() : *
      {
         if(this.CurrentCategory != nextCategory && !this.bClosing)
         {
            this.CurrentCategory = nextCategory;
            gotoAndPlay("LeftTo" + this.CurrentCategory.toString());
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         }
      }
      
      public function onTimelineSetCategory(param1:CustomEvent) : *
      {
         if(!this.bClosing)
         {
            this.CurrentCategory = param1.params.category;
            this.Tab_mc.SetCurrentTab(this.CurrentCategory);
         }
      }
      
      public function onTimelineCloseScreen() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("SkillsMenu_SaveLastCategory",{"uLastCategory":this.CurrentCategory}));
         if(this.bReturningToGame)
         {
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event(this.ON_CLOSE_MENU,true));
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.Tab_mc.OnControlMapChanged(param1);
      }
      
      private function onSetCategory(param1:CustomEvent) : *
      {
         this.CurrentCategory = param1.params.category;
         switch(param1.params.category)
         {
            case SkillsUtils.COMBAT:
               this.gotoAndStop("CombatStopFrame");
               break;
            case SkillsUtils.SCIENCE:
               this.gotoAndStop("ScienceStopFrame");
               break;
            case SkillsUtils.TECH:
               this.gotoAndStop("TechStopFrame");
               break;
            case SkillsUtils.PHYSICAL:
               this.gotoAndStop("PhysicalStopFrame");
               break;
            case SkillsUtils.SOCIAL:
               this.gotoAndStop("SocialStopFrame");
         }
         this.Tab_mc.SetCurrentTab(this.CurrentCategory);
      }
      
      private function onTabLeftRollover() : *
      {
         this.OverLeftTabCatcher = true;
      }
      
      private function onTabLeftRollout() : *
      {
         this.OverLeftTabCatcher = false;
      }
      
      private function onTabRightRollover() : *
      {
         this.OverRightTabCatcher = true;
      }
      
      private function onTabRightRollout() : *
      {
         this.OverRightTabCatcher = false;
      }
      
      private function onConstantTabLeftRollover() : void
      {
         if(!this.GetPopupVisible() && !this.bClosing)
         {
            this.onTabLeft();
            OverConstantLeftTab = true;
         }
      }
      
      private function onConstantTabLeftRollout() : void
      {
         OverConstantLeftTab = false;
      }
      
      private function onConstantTabRightRollover() : void
      {
         if(!this.GetPopupVisible() && !this.bClosing)
         {
            this.onTabRight();
            OverConstantRightTab = true;
         }
      }
      
      private function onConstantTabRightRollout() : void
      {
         OverConstantRightTab = false;
      }
      
      private function onCloseSubMenuToGame() : *
      {
         if(this.InspectPopup_mc.visible)
         {
            this.InspectPopup_mc.gotoAndPlay("Close");
         }
         this.CloseMenu(true);
      }
      
      private function CloseMenu(param1:Boolean) : *
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         if(!this.bClosing)
         {
            this.bClosing = true;
            this.bReturningToGame = param1;
            GlobalFunc.PlayMenuSound("UIMenuSkillsMenuClose");
            if(param1)
            {
               GlobalFunc.StartGameRender();
               BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
               gotoAndPlay("Close");
            }
            else
            {
               _loc2_ = 1;
               while(_loc2_ <= 5)
               {
                  _loc3_ = this["SkillTab" + _loc2_.toString()];
                  this.ClosingTabPostions[_loc2_ - 1] = new Point(_loc3_.x,_loc3_.y);
                  _loc2_++;
               }
               addEventListener(Event.ENTER_FRAME,this.onClosing);
               gotoAndPlay("Close");
               this.onClosing();
            }
         }
      }
   }
}

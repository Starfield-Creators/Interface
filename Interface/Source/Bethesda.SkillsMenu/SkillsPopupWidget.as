package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.SkillsUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SkillsPopupWidget extends BSDisplayObject
   {
      
      public static const VISIBILITY_CHANGE:String = "VISIBILITY_CHANGE";
      
      public static const CLOSE_ALL_MENUS:String = "CLOSE_ALL_MENUS";
      
      public static const SKILL_ADDED:String = "SKILL_ADDED";
      
      public static const ON_UPGRADE_ANIMATION_TIMELINE_COMPLETE:String = "OnUpgradeAnimationTimelineComplete";
      
      public static var LargeTextMode:Boolean = false;
       
      
      public var Rank1_mc:MovieClip;
      
      public var Rank2_mc:MovieClip;
      
      public var Rank3_mc:MovieClip;
      
      public var Rank4_mc:MovieClip;
      
      public var Rank5_mc:MovieClip;
      
      public var SkillName_mc:MovieClip;
      
      public var SkillDescription_mc:MovieClip;
      
      public var ProgressHeader_mc:MovieClip;
      
      public var ProgressDescription_mc:MovieClip;
      
      public var ProgressAmount_mc:MovieClip;
      
      public var ProgressBar_mc:MovieClip;
      
      public var SkillImage_mc:MovieClip;
      
      public var RankLockedIcon_mc:MovieClip;
      
      public var LockedText_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var InputCatcher_mc:MovieClip;
      
      private var UpgradeAnimationClip:MovieClip = null;
      
      private var ProgressMeterWidth:Number = 0;
      
      private var UnlockButtonData:* = null;
      
      private var RankUpButtonData:* = null;
      
      private var PlayerData:String = "PlayerData";
      
      private const SkillsMenu_AddPatch:String = "SkillsMenu_AddPatch";
      
      private var PerkID:uint = 0;
      
      private var NextPerkRank:uint = 0;
      
      private var Category:uint = 0;
      
      private var RankCountData:uint = 0;
      
      private var CurrentPerkRank:uint = 0;
      
      private var ArtName:String = "";
      
      private var SelectedIndex:int = -1;
      
      private var SkillData:Object = null;
      
      private const RANK_COUNT:uint = 5;
      
      private var PointsAvailable:Boolean = true;
      
      protected var bUpgradeAnimationIsPlaying:Boolean = false;
      
      private const UPGRADE_ANIMATION_SCALE:Number = 1;
      
      private const SKILL_IMAGE_UPGRADE_LABEL:String = "upgrade";
      
      private const RANK_HIGHLIGHT_START:String = "start";
      
      private const RANK_HIGHLIGHT_UPGRADE_ANIMATION:String = "upgrade";
      
      private const RANK_HIGHLIGHT_HIGHLIGHTED:String = "highlighted";
      
      private const RANK_TEXT_AVAILABLE:String = "Available";
      
      private const RANK_TEXT_LOCKED:String = "Locked";
      
      private const RANK_TEXT_HIGHLIGHT:String = "Highlight";
      
      public function SkillsPopupWidget()
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         Extensions.enabled = true;
         this.UnlockButtonData = new ButtonBaseData("$UNLOCK_BUTTON",new UserEventData("Accept",this.onConfirmSkill,""));
         this.RankUpButtonData = new ButtonBaseData("$RANK_UP",new UserEventData("Accept",this.onConfirmSkill,""));
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.ConfirmButton_mc,this.UnlockButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.CancelButton_mc,new ReleaseHoldComboButtonData("$BACK",LargeTextMode ? "$EXIT HOLD_LRG" : "$EXIT HOLD",[new UserEventData("Cancel",this.onExitPopup),new UserEventData("",this.onCloseAllPopups)]));
         BSUIDataManager.Subscribe(this.PlayerData,this.onPlayerDataUpdate);
         this.InputCatcher_mc.addEventListener(MouseEvent.CLICK,this.onClickOff);
         this.ButtonBar_mc.RefreshButtons();
         this.ProgressMeterWidth = this.Meter_mc.width;
         this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.centerClip = true;
         this.SkillImage_mc.Wrapper_mc.NextRank_mc.centerClip = true;
         this.SkillImage_mc.Wrapper_mc.NextRank_mc.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < this.RANK_COUNT)
         {
            _loc2_ = uint(_loc1_ + 1);
            _loc3_ = this["Rank" + _loc2_ + "_mc"];
            _loc3_.ClickRect_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc3_.ClickRect_mc.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            _loc1_++;
         }
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         LargeTextMode = param1;
      }
      
      public function get IsUpgradeAnimationPlaying() : Boolean
      {
         return this.bUpgradeAnimationIsPlaying;
      }
      
      protected function get Meter_mc() : MovieClip
      {
         return this.ProgressBar_mc.Meter_mc;
      }
      
      public function GetPerkID() : uint
      {
         return this.PerkID;
      }
      
      private function onMouseClick() : *
      {
         if(visible)
         {
            if(this.ButtonBar_mc.ConfirmButton_mc.Enabled)
            {
               this.onConfirmSkill();
            }
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : *
      {
         if(visible && uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            switch(param1.target.parent)
            {
               case this.Rank1_mc:
                  this.SetSelectedIndex(1);
                  break;
               case this.Rank2_mc:
                  this.SetSelectedIndex(2);
                  break;
               case this.Rank3_mc:
                  this.SetSelectedIndex(3);
                  break;
               case this.Rank4_mc:
                  this.SetSelectedIndex(4);
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(visible)
         {
            if(!param2 && param1 == "Accept")
            {
               this.onConfirmSkill();
            }
            else if(param2 && param1 == "Up")
            {
               this.SetSelectedIndex(this.SelectedIndex - 1);
            }
            else if(param2 && param1 == "Down")
            {
               this.SetSelectedIndex(this.SelectedIndex + 1);
            }
            else
            {
               this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
         }
         return false;
      }
      
      private function SetSelectedIndex(param1:int) : *
      {
         var _loc3_:MovieClip = null;
         if(this.SelectedIndex != param1)
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
         }
         if(this.SelectedIndex != -1)
         {
            _loc3_ = this["Rank" + this.SelectedIndex + "_mc"];
            if(_loc3_)
            {
               _loc3_.RankHighlight_mc.visible = false;
            }
         }
         this.SelectedIndex = param1;
         if(this.SelectedIndex < 1)
         {
            this.SelectedIndex = this.RANK_COUNT - 1;
         }
         if(this.SelectedIndex >= this.RANK_COUNT)
         {
            this.SelectedIndex = 1;
         }
         var _loc2_:MovieClip = this["Rank" + this.SelectedIndex + "_mc"];
         if(_loc2_)
         {
            _loc2_.RankHighlight_mc.visible = true;
            if(_loc2_.RankHighlight_mc.currentFrameLabel == this.RANK_HIGHLIGHT_START)
            {
               _loc2_.RankHighlight_mc.gotoAndStop(this.RANK_HIGHLIGHT_HIGHLIGHTED);
            }
         }
         if(this.SkillData)
         {
            if(this.SkillData.uRank == 0 && this.SelectedIndex == 1 || this.SelectedIndex == this.SkillData.uRank + 1 || this.SelectedIndex == this.SkillData.uRank)
            {
               if(this.SkillData.uRequiredPurchasesToUnlock || this.SkillData.uRank == this.SkillData.uRankCount || !this.SkillData.RankDataA[this.SkillData.uRank].bLocked && !this.PointsAvailable)
               {
                  this.ButtonBar_mc.ConfirmButton_mc.Enabled = false;
               }
               else
               {
                  this.ButtonBar_mc.ConfirmButton_mc.Enabled = !this.SkillData.RankDataA[this.SkillData.uRank].bLocked;
               }
            }
            else
            {
               this.ButtonBar_mc.ConfirmButton_mc.Enabled = false;
            }
            if(this.SkillData.uRank == this.SkillData.uRankCount)
            {
               this.ProgressAmount_mc.visible = false;
               this.LockedText_mc.visible = false;
               this.RankLockedIcon_mc.visible = false;
               this.ProgressBar_mc.visible = true;
               this.Meter_mc.width = this.ProgressMeterWidth;
               this.ProgressHeader_mc.gotoAndStop("Unlocked");
               this.ProgressHeader_mc.visible = true;
               this.ProgressDescription_mc.visible = true;
               GlobalFunc.SetText(this.ProgressHeader_mc.Text_mc.Text_tf,"$MAXIMUM_RANK");
               GlobalFunc.SetText(this.ProgressDescription_mc.Text_tf,"$Mastered_Skill");
            }
            else if(this.ButtonBar_mc.ConfirmButton_mc.Enabled)
            {
               this.ProgressAmount_mc.visible = false;
               this.LockedText_mc.visible = false;
               this.RankLockedIcon_mc.visible = false;
               this.ProgressBar_mc.visible = true;
               this.Meter_mc.width = this.ProgressMeterWidth;
               this.ProgressHeader_mc.visible = true;
               this.ProgressHeader_mc.gotoAndStop("Unlocked");
               this.ProgressDescription_mc.visible = true;
               GlobalFunc.SetText(this.ProgressHeader_mc.Text_mc.Text_tf,"$RANK_AVAILABLE");
               GlobalFunc.SetText(this.ProgressDescription_mc.Text_tf,"$Unlock_Rank");
            }
            else if(this.SelectedIndex == this.SkillData.uRank && this.SkillData.uRank != 0)
            {
               this.LockedText_mc.visible = false;
               this.RankLockedIcon_mc.visible = false;
               if(this.SkillData.RequirementsA.length > 0)
               {
                  this.ProgressHeader_mc.visible = true;
                  this.ProgressDescription_mc.visible = true;
                  this.ProgressAmount_mc.visible = true;
                  this.ProgressBar_mc.visible = true;
                  this.ProgressHeader_mc.gotoAndStop("Normal");
                  GlobalFunc.SetText(this.ProgressHeader_mc.Text_mc.Text_tf,"$CHALLENGE PROGRESS");
                  GlobalFunc.SetText(this.ProgressAmount_mc.Text_tf,"(" + this.SkillData.RequirementsA[0].uCurrentRepetitions + "/" + this.SkillData.RequirementsA[0].uMaxRepetitions + ")");
                  this.Meter_mc.width = this.SkillData.RequirementsA[0].uMaxRepetitions != 0 ? Math.min(this.ProgressMeterWidth,this.ProgressMeterWidth * (Number(this.SkillData.RequirementsA[0].uCurrentRepetitions) / Number(this.SkillData.RequirementsA[0].uMaxRepetitions))) : 0;
                  GlobalFunc.SetText(this.ProgressDescription_mc.Text_tf,this.SkillData.RequirementsA[0].text);
               }
               else
               {
                  this.ProgressHeader_mc.visible = false;
                  this.ProgressDescription_mc.visible = false;
                  this.ProgressAmount_mc.visible = false;
                  this.ProgressBar_mc.visible = false;
               }
            }
            else if(this.SelectedIndex <= this.SkillData.uRank)
            {
               this.ProgressHeader_mc.visible = false;
               this.ProgressDescription_mc.visible = false;
               this.ProgressAmount_mc.visible = false;
               this.ProgressBar_mc.visible = false;
               this.LockedText_mc.visible = false;
               this.RankLockedIcon_mc.visible = false;
            }
            else
            {
               this.ProgressAmount_mc.visible = false;
               this.ProgressHeader_mc.visible = false;
               this.ProgressBar_mc.visible = true;
               this.Meter_mc.width = this.ProgressMeterWidth;
               this.RankLockedIcon_mc.visible = true;
               this.LockedText_mc.visible = true;
               this.ProgressDescription_mc.visible = true;
               GlobalFunc.SetText(this.ProgressDescription_mc.Text_tf,this.SkillData.uRank == 0 ? "" : "$Complete_Previous_Rank");
            }
            this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.Unload();
            this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.LoadInternal(SkillsUtils.GetFullSkillPatchImageName(this.SkillData.sArtName,this.SelectedIndex == 1 && this.SkillData.uRank == 0 ? 0 : uint(this.SelectedIndex)),"SkillPatchTextureBuffer");
         }
      }
      
      private function onConfirmSkill() : *
      {
         var _loc1_:Class = null;
         var _loc2_:MovieClip = null;
         if(Boolean(this.ButtonBar_mc.ConfirmButton_mc.Enabled) && !this.bUpgradeAnimationIsPlaying)
         {
            if(this.SelectedIndex == 1 && this.SkillData.uRank == 0)
            {
               this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.Unload();
               this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.LoadInternal(SkillsUtils.GetFullSkillPatchImageName(this.SkillData.sArtName,1),"SkillPatchTextureBuffer");
            }
            if(this.SelectedIndex != this.SkillData.uRank + 1)
            {
               this.SetSelectedIndex(this.SkillData.uRank + 1);
            }
            if(this.SelectedIndex < this.RANK_COUNT)
            {
               if(this.SelectedIndex <= this.RankCountData)
               {
                  _loc2_ = this["Rank" + this.SelectedIndex + "_mc"];
                  _loc2_.RankHighlight_mc.visible = true;
                  _loc2_.RankHighlight_mc.gotoAndPlay(this.RANK_HIGHLIGHT_UPGRADE_ANIMATION);
               }
            }
            stage.dispatchEvent(new CustomEvent(SKILL_ADDED,{"FormID":this.PerkID}));
            BSUIDataManager.dispatchEvent(new CustomEvent(this.SkillsMenu_AddPatch,{
               "FormID":this.PerkID,
               "NextRank":this.NextPerkRank
            }));
            if(this.UpgradeAnimationClip)
            {
               removeChild(this.UpgradeAnimationClip);
               this.UpgradeAnimationClip = null;
            }
            this.SkillImage_mc.gotoAndPlay(this.SKILL_IMAGE_UPGRADE_LABEL);
            this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.visible = true;
            this.SkillImage_mc.Wrapper_mc.NextRank_mc.visible = false;
            this.bUpgradeAnimationIsPlaying = true;
            _loc1_ = null;
            switch(this.Category)
            {
               case SkillsUtils.COMBAT:
                  _loc1_ = getDefinitionByName("Combat_UpgradeAnimation") as Class;
                  break;
               case SkillsUtils.PHYSICAL:
                  _loc1_ = getDefinitionByName("Physical_UpgradeAnimation") as Class;
                  break;
               case SkillsUtils.SCIENCE:
                  _loc1_ = getDefinitionByName("Science_UpgradeAnimation") as Class;
                  break;
               case SkillsUtils.SOCIAL:
                  _loc1_ = getDefinitionByName("Social_UpgradeAnimation") as Class;
                  break;
               case SkillsUtils.TECH:
                  _loc1_ = getDefinitionByName("Tech_UpgradeAnimation") as Class;
                  break;
               default:
                  this.bUpgradeAnimationIsPlaying = false;
            }
            if(this.bUpgradeAnimationIsPlaying)
            {
               this.UpgradeAnimationClip = new _loc1_();
               addChild(this.UpgradeAnimationClip);
               this.UpgradeAnimationClip.x = this.SkillImage_mc.x;
               this.UpgradeAnimationClip.y = this.SkillImage_mc.y;
               this.UpgradeAnimationClip.scaleX = this.UPGRADE_ANIMATION_SCALE;
               this.UpgradeAnimationClip.scaleY = this.UPGRADE_ANIMATION_SCALE;
               this.UpgradeAnimationClip.addEventListener(ON_UPGRADE_ANIMATION_TIMELINE_COMPLETE,this.HandleOnUpgradeAnimationTimelineComplete);
               this.UpgradeAnimationClip.gotoAndPlay("Play");
            }
            GlobalFunc.PlayMenuSound("UIMenuSkillsPopUpConfirm");
         }
      }
      
      public function CloseDownPopup() : *
      {
         var _loc1_:MovieClip = null;
         if(this.bUpgradeAnimationIsPlaying)
         {
            this.bUpgradeAnimationIsPlaying = false;
            if(this.UpgradeAnimationClip)
            {
               this.UpgradeAnimationClip.visible = false;
               removeChild(this.UpgradeAnimationClip);
               this.UpgradeAnimationClip = null;
            }
         }
         this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.Unload();
         this.SkillImage_mc.Wrapper_mc.NextRank_mc.Unload();
         if(this.SelectedIndex != -1)
         {
            _loc1_ = this["Rank" + this.SelectedIndex + "_mc"];
            if(_loc1_)
            {
               _loc1_.RankHighlight_mc.visible = false;
            }
         }
         this.SelectedIndex = -1;
      }
      
      private function onExitPopup() : *
      {
         this.CloseDownPopup();
         dispatchEvent(new CustomEvent(VISIBILITY_CHANGE,{
            "visible":false,
            "playSound":true
         }));
      }
      
      private function onCloseAllPopups() : *
      {
         dispatchEvent(new Event(CLOSE_ALL_MENUS));
      }
      
      private function onClickOff() : *
      {
         this.onExitPopup();
      }
      
      private function GetConfirmButtonData(param1:Object) : ButtonBaseData
      {
         var _loc2_:* = this.RankUpButtonData;
         if(param1.uRank == 0)
         {
            _loc2_ = this.UnlockButtonData;
         }
         return _loc2_;
      }
      
      public function GetPatchLevelFrame(param1:uint) : String
      {
         switch(param1)
         {
            case 0:
               return "Rank_0";
            case 1:
               return "Rank_1";
            case 2:
               return "Rank_2";
            case 3:
               return "Rank_3";
            case 4:
               return "Rank_4";
            default:
               return "Rank_0";
         }
      }
      
      public function PopulateData(param1:Object) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         if(param1 == null)
         {
            GlobalFunc.SetText(this.SkillName_mc.SkillNameText_mc.Text_tf,"Null data");
            return;
         }
         this.SkillData = param1;
         this.PerkID = param1.uPerkID;
         this.NextPerkRank = param1.uRank + 1;
         this.Category = param1.uCategory;
         this.RankCountData = param1.uRankCount;
         this.ArtName = param1.sArtName;
         this.CurrentPerkRank = param1.uRank;
         this.ButtonBar_mc.ConfirmButton_mc.SetButtonData(this.GetConfirmButtonData(param1));
         if(param1.uRequiredPurchasesToUnlock || param1.uRank == param1.uRankCount || !param1.RankDataA[param1.uRank].bLocked && !this.PointsAvailable)
         {
            this.ButtonBar_mc.ConfirmButton_mc.Enabled = false;
         }
         else
         {
            this.ButtonBar_mc.ConfirmButton_mc.Enabled = !param1.RankDataA[param1.uRank].bLocked;
         }
         var _loc2_:String = SkillsUtils.GetFullDefaultSkillPatchName(param1.uCategory);
         this.SkillImage_mc.Wrapper_mc.CurrentRank_mc.errorClassName = _loc2_;
         this.SkillImage_mc.Wrapper_mc.NextRank_mc.errorClassName = _loc2_;
         this.SkillName_mc.gotoAndStop("Cat" + param1.uCategory);
         GlobalFunc.SetText(this.SkillName_mc.SkillNameText_mc.text_tf,param1.sName,true);
         GlobalFunc.SetText(this.SkillDescription_mc.Text_tf,param1.sDescription,true);
         var _loc3_:uint = 0;
         while(_loc3_ < this.RANK_COUNT)
         {
            _loc4_ = uint(_loc3_ + 1);
            _loc5_ = this["Rank" + _loc4_ + "_mc"];
            if(_loc3_ < param1.uRankCount)
            {
               _loc5_.alpha = 1;
               if(_loc3_ < param1.uRank && !param1.RankDataA[_loc3_].bLocked)
               {
                  _loc5_.RankText_mc.gotoAndStop(this.RANK_TEXT_AVAILABLE);
               }
               else if(_loc3_ == param1.uRank && !param1.RankDataA[_loc3_].bLocked)
               {
                  _loc5_.RankText_mc.gotoAndStop(this.RANK_TEXT_HIGHLIGHT);
                  _loc5_.RankHighlight_mc.visible = false;
               }
               else
               {
                  _loc5_.RankText_mc.gotoAndStop(!!param1.RankDataA[_loc3_].bLocked ? this.RANK_TEXT_LOCKED : this.RANK_TEXT_AVAILABLE);
                  _loc5_.RankHighlight_mc.visible = false;
               }
               _loc5_.RankDesc_mc.gotoAndStop(!!param1.RankDataA[_loc3_].bLocked ? this.RANK_TEXT_LOCKED : this.RANK_TEXT_AVAILABLE);
               TextFieldEx.setTextAutoSize(_loc5_.RankDesc_mc.Desc_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               GlobalFunc.SetText(_loc5_.RankDesc_mc.Desc_mc.text_tf,param1.RankDataA[_loc3_].sDescription);
               _loc5_.RankLockedIcon_mc.visible = param1.RankDataA[_loc3_].bLocked;
               GlobalFunc.SetText(_loc5_.RankText_mc.RankNum_mc.text_tf,_loc3_ == param1.uRank && !param1.RankDataA[_loc3_].bLocked ? "$Rank {0} Available" : "$Rank {0}",true,true,0,false,0,[_loc4_]);
               _loc5_.gotoAndStop("Rank" + _loc4_);
            }
            else
            {
               _loc5_.alpha = 0;
            }
            _loc3_++;
         }
         if(this.SelectedIndex == -1)
         {
            _loc6_ = 1;
            if(this.SkillData.uRank == 0)
            {
               _loc6_ = 1;
            }
            else if(this.SkillData.uRank == this.SkillData.uRankCount)
            {
               _loc6_ = int(this.RANK_COUNT - 1);
            }
            else if(!(Boolean(this.SkillData.uRequiredPurchasesToUnlock) || this.SkillData.uRank == this.SkillData.uRankCount || !this.SkillData.RankDataA[this.SkillData.uRank].bLocked && !this.PointsAvailable) && !this.SkillData.RankDataA[this.SkillData.uRank].bLocked)
            {
               _loc6_ = this.SkillData.uRank + 1;
            }
            else
            {
               _loc6_ = int(this.SkillData.uRank);
            }
            this.SetSelectedIndex(_loc6_);
         }
         else
         {
            this.SetSelectedIndex(this.SelectedIndex);
         }
      }
      
      private function onPlayerDataUpdate(param1:FromClientDataEvent) : void
      {
         this.PointsAvailable = param1.data.uSkillPoints;
      }
      
      protected function HandleOnUpgradeAnimationTimelineComplete() : *
      {
         this.bUpgradeAnimationIsPlaying = false;
         if(this.UpgradeAnimationClip)
         {
            removeChild(this.UpgradeAnimationClip);
            this.UpgradeAnimationClip = null;
         }
      }
   }
}

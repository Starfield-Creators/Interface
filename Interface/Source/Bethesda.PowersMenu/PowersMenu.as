package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.GlobalFunc;
   import Shared.PowerTypes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class PowersMenu extends IMenu
   {
      
      public static const POWER_ENABLED_SOUND:String = "UIMenuArtifactPowersSelectEnable";
      
      public static const POWER_DISABLED_SOUND:String = "UIMenuArtifactPowersSelectDisable";
       
      
      public var SelectionInfo_mc:MovieClip;
      
      public var UndiscoveredText_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var EssenceButton_mc:MovieClip;
      
      public var AlienRean_mc:Power;
      
      public var AntiGravity_mc:Power;
      
      public var CreateVacuum_mc:Power;
      
      public var CreatorsPeace_mc:Power;
      
      public var Earthbound_mc:Power;
      
      public var ElementBlast_mc:Power;
      
      public var EternalHarv_mc:Power;
      
      public var GravDash_mc:Power;
      
      public var GravityWave_mc:Power;
      
      public var GravityWell_mc:Power;
      
      public var InnerDemon_mc:Power;
      
      public var LifeForced_mc:Power;
      
      public var MoonForm_mc:Power;
      
      public var ParallelSelf_mc:Power;
      
      public var ParticleBeam_mc:Power;
      
      public var PersonalAtm_mc:Power;
      
      public var PhasedTime_mc:Power;
      
      public var Precognition_mc:Power;
      
      public var ReactiveShield_mc:Power;
      
      public var SenseStarStuff_mc:Power;
      
      public var SolarFlare_mc:Power;
      
      public var SunlessSpace_mc:Power;
      
      public var Supernova_mc:Power;
      
      public var VoidForm_mc:Power;
      
      private var PowerClips:Array;
      
      private const PowerToAnimationSoundMap:Dictionary = new Dictionary();
      
      private const ACTIVATE_ESSENCE_EVENT:String = "PowersMenu_ActivateEssence";
      
      private var SelectedPower:Power;
      
      private var PlayerStarPower:uint = 0;
      
      private var HasEssence:Boolean = false;
      
      private var NamesVisible:Boolean = false;
      
      private var ReturningToGameplay:Boolean = false;
      
      private var MyButtonManager:ButtonManager;
      
      public function PowersMenu()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.UndiscoveredText_mc.Undiscovered_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.SelectionInfo_mc.Name_mc.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.SelectionInfo_mc.Description_mc.Description_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setVerticalAlign(this.SelectionInfo_mc.Name_mc.Name_tf,TextFieldEx.VALIGN_BOTTOM);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.FavoriteButton,new ButtonBaseData("$FAVORITE",[new UserEventData("YButton",this.onSetFavorite)],false));
         this.ButtonBar_mc.AddButtonWithData(this.ViewNamesButton,new ButtonBaseData("$POWER NAMES",[new UserEventData("LShoulder",null)],false));
         var _loc1_:String = "$EXIT HOLD";
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.onExitMenu),new UserEventData("",this.onReturnToGameplay)]));
         this.EssenceButton_mc.QuantumEssenceButtonBar_mc.AddButtonWithData(this.QuantumEssenceButton,new ButtonBaseData("",[new UserEventData("XButton",this.handleEssenceButtonClick)]));
         this.QuantumEssenceButton.justification = IButtonUtils.ICON_FIRST;
         this.MyButtonManager.AddButton(this.QuantumEssenceButton);
         this.ViewNamesButton.Enabled = true;
         this.ButtonBar_mc.RefreshButtons();
         this.InitializePowersDictionary();
         this.FillPowerClipArray();
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get FavoriteButton() : IButton
      {
         return this.ButtonBar_mc.FavoriteButton_mc;
      }
      
      private function get ViewNamesButton() : IButton
      {
         return this.ButtonBar_mc.ViewNamesButton_mc;
      }
      
      private function get QuantumEssenceButton() : ButtonBase
      {
         return this.EssenceButton_mc.QuantumEssenceButtonBar_mc.QuantumEssenceButton_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(Power.POWER_SELECTION_CHANGE,this.onSelectionChange);
         BSUIDataManager.Subscribe("PowersMenuData",this.onPowersDataUpdate);
         BSUIDataManager.Subscribe("PlayerFrequentData",this.onPlayerFrequentDataUpdate);
      }
      
      private function onSelectionChange(param1:CustomEvent) : void
      {
         this.SelectedPower = this.getPowerClip(param1.params.sKeyName);
         if(this.SelectedPower)
         {
            this.FavoriteButton.Enabled = true;
            this.ShowSelectedPowerName(this.SelectedPower);
            this.SelectionInfo_mc.SelectedPower_mc.Unload();
            this.SelectionInfo_mc.SelectedPower_mc.centerClip = true;
            this.SelectionInfo_mc.SelectedPower_mc.clipScale = 0.5;
            this.SelectionInfo_mc.SelectedPower_mc.LoadSymbol(this.getAnimationSymbolName(this.SelectedPower.key));
            GlobalFunc.SetText(this.SelectionInfo_mc.Cost_mc.PowerCost_mc.Text_tf,String(this.SelectedPower.cost) + " $$STARBORNPOWER");
            GlobalFunc.SetText(this.SelectionInfo_mc.Total_mc.PowerCost_mc.Text_tf,String(this.PlayerStarPower) + " $$STARBORNPOWER");
            GlobalFunc.SetText(this.SelectionInfo_mc.Description_mc.Description_tf,this.SelectedPower.description);
            if(this.PowerToAnimationSoundMap[param1.params.sKeyName] != null)
            {
               GlobalFunc.PlayMenuSound(this.PowerToAnimationSoundMap[param1.params.sKeyName]);
            }
         }
         else
         {
            this.FavoriteButton.Enabled = false;
            this.SelectionInfo_mc.gotoAndStop("off");
            this.SelectionInfo_mc.SelectedPower_mc.Unload();
         }
      }
      
      private function ShowSelectedPowerName(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(this.SelectedPower.isEquipped)
         {
            _loc2_ = this.SelectedPower.powerName + " " + "<font color=\"#39ABC2\">" + "$POWERS_HOVER" + "</font>";
            GlobalFunc.SetText(this.SelectionInfo_mc.Name_mc.Name_tf,_loc2_,true);
         }
         else
         {
            GlobalFunc.SetText(this.SelectionInfo_mc.Name_mc.Name_tf,this.SelectedPower.powerName);
         }
         this.SelectionInfo_mc.gotoAndStop(this.SelectedPower.isEquipped ? "onActive" : "on");
      }
      
      private function onPowersDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc4_:Power = null;
         var _loc5_:* = undefined;
         GlobalFunc.SetText(this.EssenceButton_mc.QuantumEssenceTooltip_mc.Text_tf,param1.data.sQuantumEssenceDescription);
         GlobalFunc.SetText(this.UndiscoveredText_mc.Undiscovered_tf,"$POWERS_UNDISCOVERED",false,false,0,false,0,[param1.data.uUndiscoveredPowers]);
         this.HasEssence = param1.data.uEssence > 0;
         if(this.HasEssence)
         {
            this.QuantumEssenceButton.SetButtonData(new ButtonBaseData("$$POWERS_ACTIVATEESSENCE (" + String(param1.data.uEssence) + ")",[new UserEventData("XButton",this.handleEssenceButtonClick)]));
            this.EssenceButton_mc.gotoAndStop("idle");
         }
         else
         {
            this.EssenceButton_mc.gotoAndStop("off");
         }
         var _loc2_:Array = param1.data.aPowers;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc4_ = this.getPowerClip(_loc2_[_loc3_].sKey)) != null)
            {
               _loc5_ = this.SelectedPower && _loc4_.powerID == this.SelectedPower.powerID && _loc4_.isEquipped != _loc2_[_loc3_].isEquipped;
               _loc4_.setData(_loc2_[_loc3_]);
               if(_loc5_)
               {
                  this.ShowSelectedPowerName(_loc2_[_loc3_]);
               }
            }
            _loc3_++;
         }
         if(!param1.data.bFavoritingPower && Power.bFavoriting && Boolean(this.SelectedPower))
         {
            this.SelectedPower.SetReturningFromFavoritesMenu();
         }
      }
      
      private function onPlayerFrequentDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.PlayerStarPower = uint(_loc2_.fMaxStarPower);
         GlobalFunc.SetText(this.SelectionInfo_mc.Total_mc.PowerCost_mc.Text_tf,String(this.PlayerStarPower) + " $$POWER");
      }
      
      private function SetNamesVisible(param1:Boolean) : void
      {
         this.NamesVisible = param1;
         var _loc2_:* = 0;
         while(_loc2_ < this.PowerClips.length)
         {
            if(this.PowerClips[_loc2_] != null)
            {
               this.PowerClips[_loc2_].setNameVisible(param1);
            }
            _loc2_++;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            switch(param1)
            {
               case "Accept":
                  if(this.SelectedPower)
                  {
                     this.SelectedPower.setActive();
                  }
                  _loc3_ = true;
                  break;
               case "XButton":
                  this.MyButtonManager.ProcessUserEvent(param1,param2);
                  break;
               case "LShoulder":
                  this.SetNamesVisible(!this.NamesVisible);
                  _loc3_ = true;
            }
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !param2)
         {
            if(param1 == "Powers")
            {
               this.onReturnToGameplay();
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onSetFavorite() : void
      {
         if(this.SelectedPower)
         {
            this.SelectedPower.setFavorite();
         }
      }
      
      private function onExitMenu() : void
      {
         gotoAndPlay("Close");
      }
      
      private function onReturnToGameplay() : void
      {
         this.ReturningToGameplay = true;
         GlobalFunc.StartGameRender();
         gotoAndPlay("Close");
      }
      
      private function OnCloseMenuFadeOutComplete() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryMenuClose");
         if(this.ReturningToGameplay)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            GlobalFunc.CloseMenu("PowersMenu");
         }
      }
      
      private function handleEssenceButtonClick() : void
      {
         if(this.HasEssence)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.EssenceButton_mc.gotoAndPlay("click");
            BSUIDataManager.dispatchEvent(new Event(this.ACTIVATE_ESSENCE_EVENT));
         }
      }
      
      private function getPowerClip(param1:String) : Power
      {
         var _loc2_:Power = null;
         switch(param1)
         {
            case PowerTypes.ARTIFACT_POWER_ALIEN_REANIM:
               _loc2_ = this.AlienRean_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_ANTI_GRAVITY_FIELD:
               _loc2_ = this.AntiGravity_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_CREATE_VACUUM:
               _loc2_ = this.CreateVacuum_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_CREATORS_PEACE:
               _loc2_ = this.CreatorsPeace_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_EARTH_BOUND:
               _loc2_ = this.Earthbound_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_ELEMENTAL_BLAST:
               _loc2_ = this.ElementBlast_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_ETERNAL_HARVEST:
               _loc2_ = this.EternalHarv_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_DASH:
               _loc2_ = this.GravDash_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_WAVE:
               _loc2_ = this.GravityWave_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_WELL:
               _loc2_ = this.GravityWell_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_INNER_DEMON:
               _loc2_ = this.InnerDemon_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_LIFE_FORCED:
               _loc2_ = this.LifeForced_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_MOON_FORM:
               _loc2_ = this.MoonForm_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_PARALLEL_SELF:
               _loc2_ = this.ParallelSelf_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_PARTICLE_BEAM:
               _loc2_ = this.ParticleBeam_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_PERSONAL_ATMO:
               _loc2_ = this.PersonalAtm_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_PHASED_TIME:
               _loc2_ = this.PhasedTime_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_PRECOGNITION:
               _loc2_ = this.Precognition_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_REACTIVE_SHIELD:
               _loc2_ = this.ReactiveShield_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_SENSE_STAR_STUFF:
               _loc2_ = this.SenseStarStuff_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_SOLAR_FLARE:
               _loc2_ = this.SolarFlare_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_SUNLESS_SPACE:
               _loc2_ = this.SunlessSpace_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_SUPER_NOVA:
               _loc2_ = this.Supernova_mc;
               break;
            case PowerTypes.ARTIFACT_POWER_VOID_FORM:
               _loc2_ = this.VoidForm_mc;
         }
         return _loc2_;
      }
      
      private function getAnimationSymbolName(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case PowerTypes.ARTIFACT_POWER_ALIEN_REANIM:
               _loc2_ = "P_AlienReanimation";
               break;
            case PowerTypes.ARTIFACT_POWER_ANTI_GRAVITY_FIELD:
               _loc2_ = "P_AntiGravityField";
               break;
            case PowerTypes.ARTIFACT_POWER_CREATE_VACUUM:
               _loc2_ = "P_CreateVacuum";
               break;
            case PowerTypes.ARTIFACT_POWER_CREATORS_PEACE:
               _loc2_ = "P_CreatorsPeace";
               break;
            case PowerTypes.ARTIFACT_POWER_EARTH_BOUND:
               _loc2_ = "P_Earthbound";
               break;
            case PowerTypes.ARTIFACT_POWER_ELEMENTAL_BLAST:
               _loc2_ = "P_ElementalBlast";
               break;
            case PowerTypes.ARTIFACT_POWER_ETERNAL_HARVEST:
               _loc2_ = "P_EternalHarvest";
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_DASH:
               _loc2_ = "P_GravDash";
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_WAVE:
               _loc2_ = "P_GravityWave";
               break;
            case PowerTypes.ARTIFACT_POWER_GRAV_WELL:
               _loc2_ = "P_GravityWell";
               break;
            case PowerTypes.ARTIFACT_POWER_INNER_DEMON:
               _loc2_ = "P_InnerDemon";
               break;
            case PowerTypes.ARTIFACT_POWER_LIFE_FORCED:
               _loc2_ = "P_LifeForced";
               break;
            case PowerTypes.ARTIFACT_POWER_MOON_FORM:
               _loc2_ = "P_MoonForm";
               break;
            case PowerTypes.ARTIFACT_POWER_PARALLEL_SELF:
               _loc2_ = "P_ParallelSelf";
               break;
            case PowerTypes.ARTIFACT_POWER_PARTICLE_BEAM:
               _loc2_ = "P_ParticleBeam";
               break;
            case PowerTypes.ARTIFACT_POWER_PERSONAL_ATMO:
               _loc2_ = "P_PersonalAtmosphere";
               break;
            case PowerTypes.ARTIFACT_POWER_PHASED_TIME:
               _loc2_ = "P_PhasedTime";
               break;
            case PowerTypes.ARTIFACT_POWER_PRECOGNITION:
               _loc2_ = "P_Precognition";
               break;
            case PowerTypes.ARTIFACT_POWER_REACTIVE_SHIELD:
               _loc2_ = "P_ReactiveShield";
               break;
            case PowerTypes.ARTIFACT_POWER_SENSE_STAR_STUFF:
               _loc2_ = "P_SenseStarStuff";
               break;
            case PowerTypes.ARTIFACT_POWER_SOLAR_FLARE:
               _loc2_ = "P_SolarFlare";
               break;
            case PowerTypes.ARTIFACT_POWER_SUNLESS_SPACE:
               _loc2_ = "P_SunlessSpace";
               break;
            case PowerTypes.ARTIFACT_POWER_SUPER_NOVA:
               _loc2_ = "P_Supernova";
               break;
            case PowerTypes.ARTIFACT_POWER_VOID_FORM:
               _loc2_ = "P_VoidForm";
         }
         return _loc2_;
      }
      
      private function InitializePowersDictionary() : *
      {
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_ALIEN_REANIM] = "UIMenuArtifactPowersAnimation_AlienReAnimation";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_ANTI_GRAVITY_FIELD] = "UIMenuArtifactPowersAnimation_AntiGravityField";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_CREATE_VACUUM] = "UIMenuArtifactPowersAnimation_CreateVacuum";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_CREATORS_PEACE] = "UIMenuArtifactPowersAnimation_CreatorsPeace";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_EARTH_BOUND] = "UIMenuArtifactPowersAnimation_Earthbound";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_ELEMENTAL_BLAST] = "UIMenuArtifactPowersAnimation_ElementalBlast";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_ETERNAL_HARVEST] = "UIMenuArtifactPowersAnimation_EternalHarvest";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_GRAV_DASH] = "UIMenuArtifactPowersAnimation_GravDash";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_GRAV_WAVE] = "UIMenuArtifactPowersAnimation_GravityWave";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_GRAV_WELL] = "UIMenuArtifactPowersAnimation_GravityWell";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_INNER_DEMON] = "UIMenuArtifactPowersAnimation_InnerDemon";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_LIFE_FORCED] = "UIMenuArtifactPowersAnimation_Lifeforced";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_MOON_FORM] = "UIMenuArtifactPowersAnimation_Moonform";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_PARALLEL_SELF] = "UIMenuArtifactPowersAnimation_ParallelSelf";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_PARTICLE_BEAM] = "UIMenuArtifactPowersAnimation_ParticleBeam";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_PERSONAL_ATMO] = "UIMenuArtifactPowersAnimation_PersonalAtmosphere";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_PHASED_TIME] = "UIMenuArtifactPowersAnimation_PhasedTime";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_PRECOGNITION] = "UIMenuArtifactPowersAnimation_Precognition";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_REACTIVE_SHIELD] = "UIMenuArtifactPowersAnimation_ReactiveShield";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_SENSE_STAR_STUFF] = "UIMenuArtifactPowersAnimation_SenseStarStuff";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_SOLAR_FLARE] = "UIMenuArtifactPowersAnimation_SolarFlare";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_SUNLESS_SPACE] = "UIMenuArtifactPowersAnimation_SunlessSpace";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_SUPER_NOVA] = "UIMenuArtifactPowersAnimation_Supernova";
         this.PowerToAnimationSoundMap[PowerTypes.ARTIFACT_POWER_VOID_FORM] = "UIMenuArtifactPowersAnimation_VoidForm";
      }
      
      private function FillPowerClipArray() : *
      {
         this.PowerClips = new Array(this.AlienRean_mc,this.AntiGravity_mc,this.CreateVacuum_mc,this.CreatorsPeace_mc,this.Earthbound_mc,this.ElementBlast_mc,this.EternalHarv_mc,this.GravDash_mc,this.GravityWave_mc,this.GravityWell_mc,this.InnerDemon_mc,this.LifeForced_mc,this.MoonForm_mc,this.ParallelSelf_mc,this.ParticleBeam_mc,this.PersonalAtm_mc,this.PhasedTime_mc,this.Precognition_mc,this.ReactiveShield_mc,this.SenseStarStuff_mc,this.SolarFlare_mc,this.SunlessSpace_mc,this.Supernova_mc,this.VoidForm_mc);
      }
   }
}

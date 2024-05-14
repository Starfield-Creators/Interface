package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LevelUpWidget extends BSDisplayObject
   {
      
      public static const LEVEL_UP_ANIM_FINISHED:String = "LevelUp_AnimFinished";
       
      
      public var ShowSkillsMenuButton_mc:MovieClip;
      
      public var LevelUpText_mc:MovieClip;
      
      public var Skill0_mc:MovieClip;
      
      public var Skill1_mc:MovieClip;
      
      public var Skill2_mc:MovieClip;
      
      public var Skill3_mc:MovieClip;
      
      public var Skill4_mc:MovieClip;
      
      public var onesMC:MovieClip;
      
      public var tensMC:MovieClip;
      
      public var hundredsMC:MovieClip;
      
      private const SHOW_LEVEL_UP:String = "ShowLevelUp";
      
      private const SHOW_SKILLS_MENU:String = "LevelUp_ShowSkills";
      
      private const OPEN_DATA_MENU:String = "LevelUp_OpenDataMenu";
      
      private const CATEGORY_COUNT:uint = 5;
      
      private var MyButtonManager:ButtonManager;
      
      private var SkillsMenuButtonData:ReleaseHoldComboButtonData;
      
      private var SkillsMenuButtonDataKBM:ReleaseHoldComboButtonData;
      
      private var bShown:Boolean = false;
      
      public function LevelUpWidget()
      {
         this.MyButtonManager = new ButtonManager();
         this.SkillsMenuButtonData = new ReleaseHoldComboButtonData("","$LEVEL UP",[new UserEventData("ShowSkillsMenu",null,this.OPEN_DATA_MENU),new UserEventData("",null,this.SHOW_SKILLS_MENU)]);
         this.SkillsMenuButtonDataKBM = new ReleaseHoldComboButtonData("$LEVEL UP","",[new UserEventData("ShowSkillsMenu",null,this.SHOW_SKILLS_MENU),new UserEventData("",null,"",false)]);
         super();
         this.SkillsMenuButtonData.bPressAndReleaseVisible = false;
         BSUIDataManager.Subscribe("XPData",this.onDataChange);
         this.addEventListener(LEVEL_UP_ANIM_FINISHED,this.onAnimFinished);
         BSUIDataManager.Subscribe("FireForgetEventData",function(param1:FromClientDataEvent):*
         {
            if(ShowSkillsMenuButton_mc != null && ShowSkillsMenuButton_mc is IButton)
            {
               if(GlobalFunc.HasFireForgetEvent(param1.data,"MonocleMenu_Opened") || GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnMonocleToggle_Opened"))
               {
                  SkillsMenuButtonDataKBM.bVisible = false;
                  SkillsMenuButtonData.bVisible = false;
                  SkillsMenuButtonDataKBM.bEnabled = false;
                  SkillsMenuButtonData.bEnabled = false;
                  RefreshButtonData();
               }
               else if(GlobalFunc.HasFireForgetEvent(param1.data,"MonocleMenu_Closed") || GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnMonocleToggle_Closed"))
               {
                  SkillsMenuButtonDataKBM.bVisible = true;
                  SkillsMenuButtonData.bVisible = true;
                  SkillsMenuButtonDataKBM.bEnabled = true;
                  SkillsMenuButtonData.bEnabled = true;
                  RefreshButtonData();
               }
            }
         });
      }
      
      public function get shown() : *
      {
         return this.bShown;
      }
      
      override public function onAddedToStage() : void
      {
         if(this.ShowSkillsMenuButton_mc != null && this.ShowSkillsMenuButton_mc is IButton)
         {
            this.ShowSkillsMenuButton_mc.SetButtonData(this.SkillsMenuButtonData);
            this.MyButtonManager.AddButton(this.ShowSkillsMenuButton_mc as IButton);
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.RefreshButtonData();
      }
      
      private function RefreshButtonData() : void
      {
         if(this.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.ShowSkillsMenuButton_mc.SetButtonData(this.SkillsMenuButtonDataKBM);
         }
         else
         {
            this.ShowSkillsMenuButton_mc.SetButtonData(this.SkillsMenuButtonData);
         }
      }
      
      private function onAnimFinished() : *
      {
         this.bShown = false;
      }
      
      public function onDataChange(param1:FromClientDataEvent) : *
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:Boolean = false;
         var _loc3_:uint = uint.MAX_VALUE;
         var _loc4_:uint = 0;
         while(!_loc2_ && param1.data.XPUpdatesA != null && _loc4_ < param1.data.XPUpdatesA.length)
         {
            _loc2_ = Boolean(param1.data.XPUpdatesA[_loc4_].bShowLevelUp);
            _loc3_ = _loc4_;
            _loc4_++;
         }
         if(_loc2_)
         {
            gotoAndPlay(this.SHOW_LEVEL_UP);
            BSUIDataManager.dispatchEvent(new Event("LevelUp_OnWidgetShown"));
            this.bShown = true;
            GlobalFunc.SetText(this.LevelUpText_mc.LevelUpText_tf,"$LEVEL");
            GlobalFunc.SetText(this.LevelUpText_mc.LevelUpText_tf,this.LevelUpText_mc.LevelUpText_tf.text + " " + param1.data.XPUpdatesA[_loc3_].uiNewLevel);
            _loc5_ = uint(param1.data.XPUpdatesA[_loc3_].uiNewLevel);
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc6_ = _loc5_ % 10;
            _loc5_ /= 10;
            if(_loc6_ == 0)
            {
               _loc6_ = 10;
            }
            this.onesMC.gotoAndStop(_loc6_);
            _loc7_ = _loc5_ % 10;
            _loc5_ /= 10;
            _loc7_ += 1;
            this.tensMC.gotoAndStop(_loc7_);
            _loc8_ = _loc5_;
            _loc8_ = Math.min(_loc8_ + 1,20);
            this.hundredsMC.gotoAndStop(_loc8_);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      public function onNewSkillsAvailableShown() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuSkillsAvailableMessage");
      }
      
      public function onPerkShown() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuSkillsAvailableSkill");
      }
   }
}

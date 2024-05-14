package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.AnchoredButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ComponentCostPanel extends AnimatedModClip
   {
       
      
      public var ComponentCostLabel_mc:MovieClip;
      
      public var HiddenContent_mc:MovieClip;
      
      public var CostList_mc:CostList;
      
      public var ConditionsHeader_mc:MovieClip;
      
      public var Condition1_mc:MovieClip;
      
      public var SkillsHeader_mc:MovieClip;
      
      public var RequiredSkill1_mc:SkillRequirement;
      
      public var RequiredSkill2_mc:SkillRequirement;
      
      public var CreateButton_mc:AnchoredButton;
      
      private const MAX_CONDITIONS:uint = 1;
      
      private const MAX_SKILLS:uint = 2;
      
      private const MAX_REQ_NAME_LENGTH:uint = 16;
      
      private var MyButtonManager:ButtonManager;
      
      private var _skillLibrary:SharedLibraryOwner = null;
      
      private var _buttonText:String;
      
      public function ComponentCostPanel()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         this._skillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,SkillRequirement.SET_LOADER);
         GlobalFunc.SetText(this.ConditionsHeader_mc.Text_tf,"$RequiredResearch");
         GlobalFunc.SetText(this.SkillsHeader_mc.Text_tf,"$RequiredSkills");
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc1_.EntryClassName = "ComponentsList_Entry";
         this.CostList_mc.Configure(_loc1_);
         this.CostList_mc.disableInput = true;
         this.CreateButton_mc.SetAnchorData(AnchoredButton.RIGHT,AnchoredButton.ANCHOR_BUTTON);
         this.MyButtonManager.AddButton(this.CreateButton_mc);
      }
      
      public function set buttonText(param1:String) : void
      {
         this._buttonText = param1;
         this.CreateButton_mc.SetButtonData(new ButtonBaseData(this._buttonText,new UserEventData("Accept",this.OnAccept),false,true,GlobalFunc.OK_SOUND,"UIMenuGeneralActivateFailure"));
      }
      
      public function RemovedFromStage() : void
      {
         this._skillLibrary.RemoveEventListener();
      }
      
      public function PopulatePanel(param1:Object) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:* = false;
         var _loc9_:SkillRequirement = null;
         this.SetHeader(param1.sDisplayName);
         ComponentsList_Entry.nameCutOffLength = this.MAX_REQ_NAME_LENGTH;
         this.CostList_mc.InitializeEntries(param1.aCostRequirements);
         var _loc2_:uint = 0;
         var _loc3_:* = param1.aAdditionalConditions.length > 0;
         this.ConditionsHeader_mc.visible = _loc3_;
         this.Condition1_mc.visible = _loc3_;
         while(_loc2_ < param1.aAdditionalConditions.length && _loc2_ < this.MAX_CONDITIONS)
         {
            _loc5_ = this["Condition" + (_loc2_ + 1) + "_mc"];
            _loc6_ = param1.aAdditionalConditions[_loc2_];
            _loc7_ = GlobalFunc.RoundDecimal(_loc6_.fValue * 100,0);
            _loc5_.Icon_mc.gotoAndStop(_loc6_.sIconName);
            GlobalFunc.SetText(_loc5_.Value_mc.Text_tf,_loc7_ + "%");
            GlobalFunc.SetText(_loc5_.Name_mc.Text_tf,_loc6_.sName);
            _loc8_ = _loc7_ < 100;
            _loc5_.Icon_mc.alpha = _loc8_ ? CraftingUtils.FADED_SKILL : 1;
            _loc5_.Name_mc.alpha = _loc8_ ? CraftingUtils.FADED_SKILL : 1;
            _loc5_.Value_mc.alpha = _loc8_ ? CraftingUtils.FADED_SKILL : 1;
            _loc5_.visible = true;
            _loc2_++;
         }
         this.RequiredSkill1_mc.visible = false;
         this.RequiredSkill2_mc.visible = false;
         var _loc4_:* = param1.aSkillRequirements.length > 0;
         this.SkillsHeader_mc.visible = _loc4_;
         _loc2_ = 0;
         while(_loc2_ < param1.aSkillRequirements.length && _loc2_ < this.MAX_SKILLS)
         {
            (_loc9_ = this["RequiredSkill" + (_loc2_ + 1) + "_mc"]).LoadClip(param1.aSkillRequirements[_loc2_]);
            _loc9_.visible = true;
            _loc2_++;
         }
         this.EnableCreateButton(param1.bRequirementsMet);
      }
      
      public function SetHeader(param1:String) : void
      {
         GlobalFunc.SetText(this.ComponentCostLabel_mc.Text_tf,param1);
      }
      
      public function EnableCreateButton(param1:Boolean) : void
      {
         this.CreateButton_mc.Enabled = param1;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      private function OnAccept() : void
      {
         dispatchEvent(new Event(CraftingUtils.CREATE_BUTTON_HIT,true,true));
      }
   }
}

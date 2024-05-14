package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.AnchoredButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class RequirementsPanel extends MovieClip
   {
      
      public static const SELECT_BUTTON_HIT:String = "SelectButton_Hit";
       
      
      public var ComponentCostLabel_mc:MovieClip;
      
      public var CostList_mc:BSScrollingContainer;
      
      public var CreateButton_mc:AnchoredButton;
      
      private var MyButtonManager:ButtonManager;
      
      private var _showWarning:Boolean = false;
      
      public function RequirementsPanel()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "RequirementsList_Entry";
         this.CostList_mc.Configure(_loc1_);
         this.CostList_mc.disableInput = true;
         this.CreateButton_mc.SetAnchorData(AnchoredButton.RIGHT,AnchoredButton.ANCHOR_BUTTON);
         this.CreateButton_mc.SetButtonData(new ButtonBaseData("$SELECT",new UserEventData("Accept",this.OnAccept),true,true,GlobalFunc.OK_SOUND,"UIMenuGeneralActivateFailure"));
         this.MyButtonManager.AddButton(this.CreateButton_mc);
      }
      
      public function get showWarning() : Boolean
      {
         return this._showWarning;
      }
      
      public function set showWarning(param1:Boolean) : void
      {
         this._showWarning = param1;
      }
      
      public function EnableCreateButton(param1:Boolean) : void
      {
         this.CreateButton_mc.Enabled = param1;
      }
      
      public function PopulatePanel(param1:Object) : void
      {
         GlobalFunc.SetText(this.ComponentCostLabel_mc.Text_tf,param1.sDisplayName);
         this.showWarning = param1.bBreaksAnyLinks;
         this.CostList_mc.InitializeEntries(param1.aRequirements);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      private function OnAccept() : void
      {
         dispatchEvent(new Event(SELECT_BUTTON_HIT,true,true));
      }
   }
}

package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   
   public class WeaponGroupAssignmentMenu extends IMenu
   {
      
      public static const WeaponGroupAssignmentMenu_OnHintButtonActivated:String = "WeaponGroupAssignmentMenu_OnHintButtonActivated";
       
      
      public var WeaponGroupWidget_mc:WeaponGroupWidget;
      
      public var ButtonBar_mc:ButtonBar;
      
      public function WeaponGroupAssignmentMenu()
      {
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.BackButton_mc,new ButtonBaseData("$BACK",new UserEventData("Cancel",this.onBackButtonPressed)));
         this.ButtonBar_mc.RefreshButtons();
         stage.focus = this.WeaponGroupWidget_mc;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function onBackButtonPressed() : void
      {
         if(!this.WeaponGroupWidget_mc.SetPopupActive(false))
         {
            BSUIDataManager.dispatchCustomEvent(WeaponGroupAssignmentMenu_OnHintButtonActivated,{"buttonAction":"Cancel"});
            GlobalFunc.PlayMenuSound("UIMenuGeneralCancel");
         }
      }
   }
}

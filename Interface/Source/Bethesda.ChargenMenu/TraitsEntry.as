package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class TraitsEntry extends BSContainerEntry
   {
       
      
      public var Check_mc:MovieClip;
      
      internal var TraitID:uint = 0;
      
      public function TraitsEntry()
      {
         super();
         this.Check_mc.visible = false;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(baseTextField,param1.sName,true);
         GlobalFunc.TruncateSingleLineText(baseTextField);
         this.TraitID = param1.ID;
         var _loc2_:Boolean = this.Check_mc.visible;
         var _loc3_:* = this.Check_mc.currentFrameLabel == "X";
         this.Check_mc.visible = param1.bSelected == true || param1.bBlocked == true;
         this.Check_mc.gotoAndStop(param1.bBlocked == true ? "X" : "Check");
         if(_loc2_ && !this.Check_mc.visible && !_loc3_)
         {
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CHECK_REMOVE);
         }
      }
      
      public function onClick() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetTrait",{"ID":this.TraitID}));
         if(!this.Check_mc.visible || this.Check_mc.currentFrameLabel == "X")
         {
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CHECK_APPLY);
         }
      }
   }
}

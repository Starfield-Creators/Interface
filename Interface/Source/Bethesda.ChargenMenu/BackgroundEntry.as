package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class BackgroundEntry extends BSContainerEntry
   {
       
      
      public var Check_mc:MovieClip;
      
      internal var BackgroundID:uint = 0;
      
      public function BackgroundEntry()
      {
         super();
         this.Check_mc.visible = false;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(baseTextField,param1.Perk.sName,true);
         GlobalFunc.TruncateSingleLineText(baseTextField);
         this.BackgroundID = param1.Perk.ID;
         var _loc2_:Boolean = this.Check_mc.visible;
         this.Check_mc.visible = param1.Perk.bSelected == true;
         if(this.Check_mc.visible != _loc2_)
         {
            if(this.Check_mc.visible)
            {
               GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CHECK_APPLY);
            }
            else
            {
               GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CHECK_REMOVE);
            }
         }
      }
      
      public function onClick() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetBackground",{"ID":this.BackgroundID}));
      }
   }
}

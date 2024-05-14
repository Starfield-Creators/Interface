package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class MarkingsEntry extends BSContainerEntry
   {
       
      
      public var Check_mc:MovieClip;
      
      internal var MarkingID:uint = 0;
      
      public function MarkingsEntry()
      {
         super();
         this.Check_mc.visible = false;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(baseTextField,param1.Name,true);
         this.MarkingID = param1.ID;
         this.Check_mc.visible = param1.bSet == true;
      }
      
      public function onClick() : *
      {
         this.Check_mc.visible = !this.Check_mc.visible;
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_ToggleMarking",{"uID":this.MarkingID}));
      }
   }
}

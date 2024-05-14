package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   
   public class WorkshopModeList_Entry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public function WorkshopModeList_Entry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_mc.Text_tf,WorkshopUtils.GetInteractModeText(param1 as int));
      }
   }
}

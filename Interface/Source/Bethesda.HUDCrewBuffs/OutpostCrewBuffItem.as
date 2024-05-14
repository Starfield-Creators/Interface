package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class OutpostCrewBuffItem extends MovieClip
   {
       
      
      public var AssignmentBonus_mc:MovieClip;
      
      public function OutpostCrewBuffItem()
      {
         super();
      }
      
      public function SetName(param1:String) : void
      {
         GlobalFunc.SetText(this.AssignmentBonus_mc.Text_tf,param1);
      }
   }
}

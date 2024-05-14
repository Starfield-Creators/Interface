package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class AssignmentListEntry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var Location_mc:MovieClip;
      
      public var Type_mc:MovieClip;
      
      public var CrewCount_mc:MovieClip;
      
      public function AssignmentListEntry()
      {
         super();
         onRollout();
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function get Location_tf() : TextField
      {
         return this.Location_mc.Text_tf;
      }
      
      public function get Type_tf() : TextField
      {
         return this.Type_mc.Text_tf;
      }
      
      public function get CrewCount_tf() : TextField
      {
         return this.CrewCount_mc.Text_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_tf,param1.sName);
         GlobalFunc.SetText(this.Type_tf,ShipCrewUtils.AssignmentTypeToLocString(param1.uType));
         GlobalFunc.SetText(this.CrewCount_tf,"(" + param1.uOccupiedCrewSlots + "/" + param1.uTotalCrewSlots + ")");
         var _loc2_:String = "$Unknown Location";
         if(param1.sParentStarName != "")
         {
            if(param1.sParentBodyName != "" && param1.sParentBodyName != param1.sParentStarName)
            {
               _loc2_ = param1.sParentBodyName + ", " + param1.sParentStarName;
            }
            else
            {
               _loc2_ = String(param1.sParentStarName);
            }
         }
         GlobalFunc.SetText(this.Location_tf,_loc2_);
      }
      
      override public function onRollover() : void
      {
         super.onRollover();
         GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
      }
   }
}

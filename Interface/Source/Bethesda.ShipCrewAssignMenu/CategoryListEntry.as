package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CategoryListEntry extends BSContainerEntry
   {
       
      
      public var Type_mc:MovieClip;
      
      public var Description_mc:MovieClip;
      
      public function CategoryListEntry()
      {
         super();
         onRollout();
      }
      
      public function get Type_tf() : TextField
      {
         return this.Type_mc.Text_tf;
      }
      
      public function get Description_tf() : TextField
      {
         return this.Description_mc.Text_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1.AssignmentInfoA)
         {
            if(_loc3_.uOccupiedCrewSlots < _loc3_.uAvailableCrewSlots)
            {
               _loc2_ = true;
               break;
            }
         }
         GlobalFunc.SetText(this.Type_tf,param1.sName);
         if(_loc2_)
         {
            GlobalFunc.SetText(this.Description_tf,param1.sDescription);
         }
         else
         {
            GlobalFunc.SetText(this.Description_tf,param1.sName);
            _loc4_ = this.Description_tf.text;
            GlobalFunc.SetText(this.Description_tf,"$ShipCrewNoSpace");
            _loc5_ = this.Description_tf.text;
            GlobalFunc.SetText(this.Description_tf,GlobalFunc.DoSubstitutions(_loc5_,[_loc4_]));
         }
      }
   }
}

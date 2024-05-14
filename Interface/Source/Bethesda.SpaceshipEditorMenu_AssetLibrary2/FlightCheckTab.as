package
{
   import Shared.AS3.BSTabbedSelectionEntry;
   import flash.display.MovieClip;
   
   public class FlightCheckTab extends BSTabbedSelectionEntry
   {
       
      
      public var Highlight_mc:MovieClip;
      
      public var Border_mc:MovieClip;
      
      public function FlightCheckTab()
      {
         super();
      }
      
      override public function Update(param1:Object, param2:Boolean, param3:String) : *
      {
         var _loc4_:String = String(param1.sName);
         super.UpdateBaseData(_loc4_,param2,param3);
      }
   }
}

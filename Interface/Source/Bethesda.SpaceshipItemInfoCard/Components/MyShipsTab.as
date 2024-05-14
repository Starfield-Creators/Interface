package Components
{
   import Shared.AS3.BSTabbedSelectionEntry;
   import flash.display.MovieClip;
   
   public class MyShipsTab extends BSTabbedSelectionEntry
   {
       
      
      public var Highlight_mc:MovieClip;
      
      public var Border_mc:MovieClip;
      
      public function MyShipsTab()
      {
         super();
      }
      
      override public function Update(param1:Object, param2:Boolean, param3:String) : *
      {
         super.Update(param1,param2,param3);
         var _loc4_:String = String(param1.sName);
         UpdateBaseData(_loc4_,param2,param3);
      }
   }
}

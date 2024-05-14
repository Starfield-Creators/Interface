package
{
   import Shared.AS3.BSTabbedSelectionEntry;
   import flash.display.MovieClip;
   
   public class CategoryTab extends BSTabbedSelectionEntry
   {
       
      
      public var Highlight_mc:MovieClip;
      
      public var Border_mc:MovieClip;
      
      public function CategoryTab()
      {
         super();
      }
      
      override protected function UpdateBaseData(param1:String, param2:Boolean, param3:String) : *
      {
         super.UpdateBaseData(param1,param2,param3);
         this.Highlight_mc.visible = param2;
      }
   }
}

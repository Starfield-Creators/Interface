package
{
   import Shared.AS3.BSScrollingTreeEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TreeEntry extends BSScrollingTreeEntry
   {
       
      
      public var Entry_tf:MovieClip;
      
      public function TreeEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Entry_tf.textField;
      }
   }
}

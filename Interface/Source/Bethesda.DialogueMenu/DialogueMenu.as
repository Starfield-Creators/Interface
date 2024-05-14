package
{
   import Shared.AS3.BSScrollingConfigParams;
   
   public final class DialogueMenu extends DialogueMenuBase
   {
       
      
      public function DialogueMenu()
      {
         super();
      }
      
      override protected function GetDialogListParams() : BSScrollingConfigParams
      {
         var _loc1_:BSScrollingConfigParams = null;
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 4;
         _loc1_.EntryClassName = "DialogueScrollingListEntry";
         _loc1_.MultiLine = true;
         return _loc1_;
      }
   }
}

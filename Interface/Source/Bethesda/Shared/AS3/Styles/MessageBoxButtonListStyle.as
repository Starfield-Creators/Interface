package Shared.AS3.Styles
{
   import Shared.AS3.BSScrollingList;
   
   public class MessageBoxButtonListStyle
   {
      
      public static var listEntryClass_Inspectable:String = "MessageBoxButtonEntry";
      
      public static var numListItems_Inspectable:uint = 10;
      
      public static var textOption_Inspectable:String = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
      
      public static var verticalSpacing_Inspectable:Number = 7.5;
      
      public static var restoreListIndex_Inspectable:Boolean = false;
       
      
      public function MessageBoxButtonListStyle()
      {
         super();
      }
   }
}

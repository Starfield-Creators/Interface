package Shared.AS3
{
   import scaleform.gfx.TextFieldEx;
   
   public class BSScrollingConfigParams
   {
       
      
      public var VerticalSpacing:Number = 0;
      
      public var EntryClassName:String = "BSContainerEntry";
      
      public var TextOption:String;
      
      public var MultiLine:Boolean = false;
      
      public var RestoreIndex:Boolean = false;
      
      public var DisableInput:Boolean = false;
      
      public var DisableSelection:Boolean = false;
      
      public var WrapAround:Boolean = true;
      
      public var StageScroll:Boolean = false;
      
      public var TruncateToFit:Boolean = false;
      
      public function BSScrollingConfigParams()
      {
         this.TextOption = TextFieldEx.TEXTAUTOSZ_NONE;
         super();
      }
   }
}

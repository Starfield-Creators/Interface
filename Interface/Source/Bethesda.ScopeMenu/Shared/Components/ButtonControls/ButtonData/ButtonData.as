package Shared.Components.ButtonControls.ButtonData
{
   public class ButtonData
   {
       
      
      public var UserEvents:UserEventManager = null;
      
      public var sClickSound:String = "";
      
      public var sClickFailedSound:String = "UIMenuGeneralCancel";
      
      public var sRolloverSound:String = "UIMenuGeneralFocus";
      
      public var bEnabled:Boolean = true;
      
      public var bVisible:Boolean = true;
      
      public var bUsePCKeyOutline:Boolean = true;
      
      public function ButtonData()
      {
         super();
      }
   }
}

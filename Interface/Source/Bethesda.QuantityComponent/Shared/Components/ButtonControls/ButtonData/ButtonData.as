package Shared.Components.ButtonControls.ButtonData
{
   import Shared.GlobalFunc;
   
   public class ButtonData
   {
       
      
      public var UserEvents:UserEventManager = null;
      
      public var sClickSound:String = "";
      
      public var sClickFailedSound:String;
      
      public var sRolloverSound:String;
      
      public var bEnabled:Boolean = true;
      
      public var bVisible:Boolean = true;
      
      public var bUsePCKeyOutline:Boolean = true;
      
      public function ButtonData()
      {
         this.sClickFailedSound = GlobalFunc.CANCEL_SOUND;
         this.sRolloverSound = GlobalFunc.FOCUS_SOUND;
         super();
      }
   }
}

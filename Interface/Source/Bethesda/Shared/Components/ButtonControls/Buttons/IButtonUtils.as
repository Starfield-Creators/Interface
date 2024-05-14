package Shared.Components.ButtonControls.Buttons
{
   import Shared.EnumHelper;
   
   public class IButtonUtils
   {
      
      public static const BUTTON_PRIORITY_NONE:int = EnumHelper.GetEnum(0);
      
      public static const BUTTON_PRIORITY_PRESS:int = EnumHelper.GetEnum();
      
      public static const BUTTON_PRIORITY_HOLD:int = EnumHelper.GetEnum();
      
      public static const ICON_FIRST:int = EnumHelper.GetEnum(0);
      
      public static const LABEL_FIRST:int = EnumHelper.GetEnum();
      
      public static const CENTER_BOTH:int = EnumHelper.GetEnum();
      
      public static const DEFAULT_HOLD_START_DELAY_TIME_MS:Number = 200;
      
      public static const DEFAULT_HOLD_TIME_SECS:Number = 0.3;
      
      public static const INVALID_VISIBILITY:String = "visibility";
      
      public static const INVALID_STATE:String = "state";
      
      public static const INVALID_COLOR:String = "color";
      
      public static const INVALID_LABEL_TEXT:String = "label";
      
      public static const INVALID_BINDING_TEXT:String = "binding";
      
      public static const INVALID_ALIGNMENT:String = "alignment";
      
      public static const INVALID_BACKGROUND:String = "background";
       
      
      public function IButtonUtils()
      {
         super();
      }
   }
}

package
{
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   public class TargetIconFrameContainer extends MovieClip
   {
      
      public static const TT_ACTIVATOR:uint = EnumHelper.GetEnum(0);
      
      public static const TT_STAR:uint = EnumHelper.GetEnum();
      
      public static const TT_HAILING:uint = EnumHelper.GetEnum();
      
      public static const TT_LOOT:uint = EnumHelper.GetEnum();
      
      public static const TT_POI:uint = EnumHelper.GetEnum();
      
      public static const TT_SHIP:uint = EnumHelper.GetEnum();
      
      public static const TT_STATION:uint = EnumHelper.GetEnum();
      
      public static const TT_PLANET:uint = EnumHelper.GetEnum();
      
      public static const TT_DESTRUCTIBLE:uint = EnumHelper.GetEnum();
      
      public static const TT_QUEST:uint = EnumHelper.GetEnum();
      
      public static const TT_LANDING_MARKER:uint = EnumHelper.GetEnum();
      
      public static const TT_COUNT:uint = EnumHelper.GetEnum();
       
      
      private var IsInitialized:Boolean = false;
      
      private var LastUpdateFrame:uint = 0;
      
      public function TargetIconFrameContainer()
      {
         super();
         stop();
      }
      
      public function get Initialized() : Boolean
      {
         return this.IsInitialized;
      }
      
      public function ResetInitialized() : *
      {
         this.IsInitialized = false;
      }
      
      public function SetCombatValues(param1:Object) : *
      {
      }
      
      public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         this.IsInitialized = true;
      }
      
      public function SetTargetHighInfo(param1:Object) : *
      {
      }
      
      public function SetUpdateFrame(param1:uint) : *
      {
         this.LastUpdateFrame = param1;
      }
      
      public function UpdatedThisFrame(param1:uint) : Boolean
      {
         return this.LastUpdateFrame == param1;
      }
   }
}

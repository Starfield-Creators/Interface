package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   
   public class SystemNameHeader extends BSDisplayObject
   {
      
      public static const CHALLENGE_TRIVIAL:int = EnumHelper.GetEnum(0);
      
      public static const CHALLENGE_EASY:int = EnumHelper.GetEnum();
      
      public static const CHALLENGE_AVERAGE:int = EnumHelper.GetEnum();
      
      public static const CHALLENGE_CHALLENGING:int = EnumHelper.GetEnum();
      
      public static const CHALLENGE_DEADLY:int = EnumHelper.GetEnum();
       
      
      public var SubHeader_mc:MovieClip;
      
      public var SubHeaderLevel_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var HeaderLevel_mc:MovieClip;
      
      public var HeaderLevelShadow_mc:MovieClip;
      
      public var ChallengeIndicator_mc:MovieClip;
      
      public function SystemNameHeader()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         GlobalFunc.SetText(this.SubHeader_mc.text_tf,"$Designation");
         GlobalFunc.SetText(this.SubHeaderLevel_mc.text_tf,"$LEVEL");
         this.ChallengeIndicator_mc.visible = false;
      }
      
      public function SetSystemInfo(param1:Object) : *
      {
         GlobalFunc.SetText(this.Header_mc.text_tf,param1.focusedCelestialBodyName);
         GlobalFunc.SetText(this.HeaderLevel_mc.text_tf,param1.systemMinLevel);
         GlobalFunc.SetText(this.HeaderLevelShadow_mc.text_tf,param1.systemMinLevel);
         var _loc2_:TextFormat = new TextFormat();
         if(param1.systemMinLevel < 10)
         {
            _loc2_.rightMargin = 3;
            this.ChallengeIndicator_mc.DoubleDigits_mc.visible = false;
            this.ChallengeIndicator_mc.SingleDigit_mc.visible = true;
         }
         else
         {
            _loc2_.rightMargin = 0;
            this.ChallengeIndicator_mc.DoubleDigits_mc.visible = true;
            this.ChallengeIndicator_mc.SingleDigit_mc.visible = false;
         }
         this.HeaderLevel_mc.text_tf.setTextFormat(_loc2_);
         this.HeaderLevelShadow_mc.text_tf.setTextFormat(_loc2_);
         this.SetChallengeIndicatorColor(param1.systemChallengeLevel);
      }
      
      private function SetChallengeIndicatorColor(param1:int) : *
      {
         this.ChallengeIndicator_mc.visible = true;
         switch(param1)
         {
            case CHALLENGE_TRIVIAL:
               this.ChallengeIndicator_mc.gotoAndStop("Trivial");
               break;
            case CHALLENGE_EASY:
               this.ChallengeIndicator_mc.gotoAndStop("Easy");
               break;
            case CHALLENGE_AVERAGE:
               this.ChallengeIndicator_mc.gotoAndStop("Average");
               break;
            case CHALLENGE_CHALLENGING:
               this.ChallengeIndicator_mc.gotoAndStop("Challenging");
               break;
            case CHALLENGE_DEADLY:
               this.ChallengeIndicator_mc.gotoAndStop("Deadly");
         }
      }
   }
}

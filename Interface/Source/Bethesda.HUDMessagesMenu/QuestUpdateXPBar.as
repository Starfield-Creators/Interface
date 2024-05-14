package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class QuestUpdateXPBar extends MovieClip
   {
      
      private static const SLIDER_FRAME_MIN:Number = 1;
      
      private static const SLIDER_FRAME_MAX:Number = 60;
       
      
      public var MaxLevelXP_tf:TextField;
      
      public var EarnedXP_tf:TextField;
      
      public var LevelUpBar_mc:MovieClip;
      
      public var CurrentTotalSlider_mc:MovieClip;
      
      public var EarnedXPSlider_mc:MovieClip;
      
      public function QuestUpdateXPBar()
      {
         super();
      }
      
      public function set uimaxXPForLevel(param1:uint) : *
      {
         GlobalFunc.SetText(this.MaxLevelXP_tf,param1.toString());
      }
      
      public function set uiearnedXP(param1:uint) : *
      {
         GlobalFunc.SetText(this.EarnedXP_tf,param1.toString());
      }
      
      public function set dbXPBase(param1:Number) : *
      {
         this.CurrentTotalSlider_mc.gotoAndStop(Math.ceil(GlobalFunc.Lerp(SLIDER_FRAME_MIN,SLIDER_FRAME_MAX,GlobalFunc.Clamp(param1,0,1))));
      }
      
      public function set dbearnedXP(param1:Number) : *
      {
         this.EarnedXPSlider_mc.gotoAndStop(Math.ceil(GlobalFunc.Lerp(SLIDER_FRAME_MIN,SLIDER_FRAME_MAX,GlobalFunc.Clamp(param1,0,1))));
      }
   }
}

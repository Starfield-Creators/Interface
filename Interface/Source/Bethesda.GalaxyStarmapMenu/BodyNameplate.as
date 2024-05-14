package
{
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class BodyNameplate extends INameplate
   {
      
      private static const STATE_SUN:int = 0;
      
      private static const STATE_NORMAL:int = 1;
      
      private static const NAMEPLATE_MARKER_OFFSET:int = 25;
      
      private static var NumBeingShown:int = 0;
       
      
      public var SunNameplate_mc:MovieClip;
      
      private var iState:int = -1;
      
      private var bVisible:Boolean;
      
      private var bFocused:Boolean;
      
      private var bHighlight:Boolean;
      
      public function BodyNameplate()
      {
         super();
      }
      
      public static function PreUpdate() : void
      {
         NumBeingShown = 0;
      }
      
      private static function RequestShowDelay() : Number
      {
         ++NumBeingShown;
         return MarkerConsts.BODYNAMEPLATE_SHOW_STAGGER_BASE + MarkerConsts.BODYNAMEPLATE_SHOW_STAGGER_MULTIPLIER * (NumBeingShown - 1);
      }
      
      override public function Reset() : void
      {
         super.Reset();
         Nameplate_mc.visible = false;
         this.SunNameplate_mc.visible = false;
         GlobalFunc.SetText(this.SunNameplate_mc.NameplateText_tf.text_tf,"");
         this.iState = -1;
         this.bHighlight = false;
         this.bVisible = false;
         this.bFocused = false;
      }
      
      override protected function UpdateImpl(param1:Object) : void
      {
         Nameplate_mc.x = param1.fMarkerWidth + MarkerConsts.BODY_NAMEPLATE_PADDING;
         Nameplate_mc.y = 0;
         var _loc2_:int = -1;
         if(param1.bMarkerVisible)
         {
            if(param1.uBodyType == BSGalaxyTypes.BT_STAR)
            {
               _loc2_ = STATE_SUN;
            }
            else
            {
               _loc2_ = STATE_NORMAL;
            }
         }
         if(_loc2_ != this.iState)
         {
            this.ExecuteExitState(this.iState,param1);
            this.ExecuteEnterState(_loc2_,param1);
            this.iState = _loc2_;
         }
         this.ExecuteUpdateState(this.iState,param1);
      }
      
      private function ExecuteEnterState(param1:int, param2:Object) : void
      {
         var _loc3_:Function = null;
         switch(param1)
         {
            case STATE_SUN:
               _loc3_ = this.EnterSunState;
               break;
            case STATE_NORMAL:
               _loc3_ = this.EnterNormalState;
         }
         if(_loc3_ != null)
         {
            _loc3_(param2);
         }
      }
      
      private function ExecuteUpdateState(param1:int, param2:Object) : void
      {
         var _loc3_:Function = null;
         switch(param1)
         {
            case STATE_SUN:
               _loc3_ = this.UpdateSunState;
               break;
            case STATE_NORMAL:
               _loc3_ = this.UpdateNormalState;
         }
         if(_loc3_ != null)
         {
            _loc3_(param2);
         }
      }
      
      private function ExecuteExitState(param1:int, param2:Object) : void
      {
         var _loc3_:Function = null;
         switch(param1)
         {
            case STATE_SUN:
               _loc3_ = this.ExitSunState;
               break;
            case STATE_NORMAL:
               _loc3_ = this.ExitNormalState;
         }
         if(_loc3_ != null)
         {
            _loc3_(param2);
         }
      }
      
      private function EnterSunState(param1:Object) : void
      {
         this.SunNameplate_mc.visible = true;
         this.SunNameplate_mc.gotoAndPlay("Open");
      }
      
      private function UpdateSunState(param1:Object) : void
      {
         this.SunNameplate_mc.x = param1.fMarkerWidth * Math.cos(MarkerConsts.BODY_MARKER_ANGLE);
         this.SunNameplate_mc.y = -(param1.fMarkerHeight * Math.sin(MarkerConsts.BODY_MARKER_ANGLE));
      }
      
      private function ExitSunState(param1:Object) : void
      {
         this.SunNameplate_mc.gotoAndPlay("Close");
      }
      
      private function EnterNormalState(param1:Object) : void
      {
         Nameplate_mc.visible = true;
         Nameplate_mc.gotoAndPlay("body_unselected");
         SetBackgroundWidth();
         this.bHighlight = false;
      }
      
      private function UpdateNormalState(param1:Object) : void
      {
         if(this.bHighlight != param1.bIsInHighlightRadius)
         {
            this.bHighlight = param1.bIsInHighlightRadius;
            if(this.bHighlight)
            {
               Nameplate_mc.gotoAndPlay("body_selected");
            }
            else
            {
               Nameplate_mc.gotoAndPlay("body_unselected");
            }
            SetBackgroundWidth();
         }
      }
      
      private function ExitNormalState(param1:Object) : void
      {
         Nameplate_mc.gotoAndPlay("body_close");
      }
      
      override protected function SetText(param1:String) : void
      {
         super.SetText(param1);
         GlobalFunc.SetText(this.SunNameplate_mc.NameplateText_tf.text_tf,param1);
      }
   }
}

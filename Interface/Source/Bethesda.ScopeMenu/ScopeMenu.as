package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class ScopeMenu extends IMenu
   {
      
      public static const TIMELINE_SCOPE_ANIMATION_DONE:String = "Timeline_Scope_Animation_Done";
       
      
      public var StandardScopeCircle_mc:MovieClip;
      
      public var HoldBreathButton_mc:ButtonBase;
      
      public var ButtonBackground_mc:MovieClip;
      
      private const BUTTON_BACKGROUND_LEFT_BUFFER:uint = 8;
      
      private const BUTTON_BACKGROUND_RIGHT_BUFFER:uint = 13;
      
      private const ZOOM_LEVEL_x2:* = EnumHelper.GetEnum(0);
      
      private const ZOOM_LEVEL_x4:* = EnumHelper.GetEnum();
      
      private const ZOOM_LEVEL_x8:* = EnumHelper.GetEnum();
      
      private const ZOOM_LEVEL_x40:* = EnumHelper.GetEnum();
      
      private var CurrentZoomLevel:int;
      
      private var TargetZoomLevel:int;
      
      private var bIsAnimating:Boolean = false;
      
      public function ScopeMenu()
      {
         this.CurrentZoomLevel = this.ZOOM_LEVEL_x2;
         this.TargetZoomLevel = this.CurrentZoomLevel;
         super();
         this.HoldBreathButton_mc.addEventListener(ButtonBase.BUTTON_REDRAWN_EVENT,this.UpdateBackground);
         this.HoldBreathButton_mc.SetButtonData(new ButtonBaseData("$Hold Breath",new UserEventData("Steady",null)));
      }
      
      public function get ZoomLevel() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(this.StandardScopeCircle_mc != null)
         {
            _loc1_ = this.StandardScopeCircle_mc.ZoomLevel_mc;
         }
         return _loc1_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ZoomLevelData",this.onZoomLevelDataChange);
         BSUIDataManager.Subscribe("ScopeScalingData",this.onScopeScalingDataChange);
      }
      
      private function UpdateBackground() : *
      {
         var _loc1_:Rectangle = this.HoldBreathButton_mc.getBounds(this);
         this.ButtonBackground_mc.width = _loc1_.width + this.BUTTON_BACKGROUND_LEFT_BUFFER + this.BUTTON_BACKGROUND_RIGHT_BUFFER;
         this.ButtonBackground_mc.x = _loc1_.left - this.BUTTON_BACKGROUND_LEFT_BUFFER;
      }
      
      public function SetOverlay(param1:uint) : *
      {
         this.gotoAndStop(param1 + 1);
         this.SetZoomLevel(this.CurrentZoomLevel,true);
      }
      
      protected function onZoomLevelDataChange(param1:FromClientDataEvent) : *
      {
         this.SetZoomLevel(param1.data.iZoomLevel);
      }
      
      protected function onScopeScalingDataChange(param1:FromClientDataEvent) : *
      {
         scaleX = param1.data.fScaleX;
         scaleY = param1.data.fScaleY;
         this.HoldBreathButton_mc.scaleX = 1 / scaleX;
         this.HoldBreathButton_mc.scaleY = 1 / scaleY;
      }
      
      private function SetZoomLevel(param1:int, param2:Boolean = false) : *
      {
         if(this.ZoomLevel != null)
         {
            if(param2)
            {
               this.ZoomLevel.gotoAndPlay(this.GetUpAnimationName(param1));
               this.CurrentZoomLevel = param1;
            }
            else
            {
               this.TargetZoomLevel = param1;
               this.ProcessPendingZoomLevel();
            }
         }
         else
         {
            this.CurrentZoomLevel = param1;
         }
      }
      
      private function ProcessPendingZoomLevel() : *
      {
         if(this.ZoomLevel != null)
         {
            if(!this.bIsAnimating)
            {
               if(this.CurrentZoomLevel != this.TargetZoomLevel)
               {
                  this.bIsAnimating = true;
                  if(!this.ZoomLevel.hasEventListener(TIMELINE_SCOPE_ANIMATION_DONE))
                  {
                     this.ZoomLevel.addEventListener(TIMELINE_SCOPE_ANIMATION_DONE,this.onTimelineScopeAnimationDone);
                  }
                  if(this.CurrentZoomLevel < this.TargetZoomLevel)
                  {
                     ++this.CurrentZoomLevel;
                     this.ZoomLevel.gotoAndPlay(this.GetUpAnimationName(this.CurrentZoomLevel));
                  }
                  else
                  {
                     --this.CurrentZoomLevel;
                     this.ZoomLevel.gotoAndPlay(this.GetDownAnimationName(this.CurrentZoomLevel));
                  }
               }
            }
         }
      }
      
      private function onTimelineScopeAnimationDone(param1:Event) : *
      {
         this.bIsAnimating = false;
         this.ProcessPendingZoomLevel();
      }
      
      private function GetNumberFromZoomLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case this.ZOOM_LEVEL_x2:
               _loc2_ = 2;
               break;
            case this.ZOOM_LEVEL_x4:
               _loc2_ = 4;
               break;
            case this.ZOOM_LEVEL_x8:
               _loc2_ = 8;
               break;
            case this.ZOOM_LEVEL_x40:
               _loc2_ = 40;
         }
         return _loc2_;
      }
      
      private function GetUpAnimationName(param1:int) : String
      {
         var _loc2_:* = "Idle";
         if(param1 != this.ZOOM_LEVEL_x2)
         {
            _loc2_ = "up_" + this.GetNumberFromZoomLevel(param1).toString() + "x";
         }
         return _loc2_;
      }
      
      private function GetDownAnimationName(param1:int) : String
      {
         var _loc2_:* = "up_40x";
         if(param1 != this.ZOOM_LEVEL_x40)
         {
            _loc2_ = "down_" + this.GetNumberFromZoomLevel(param1).toString() + "x";
         }
         return _loc2_;
      }
   }
}

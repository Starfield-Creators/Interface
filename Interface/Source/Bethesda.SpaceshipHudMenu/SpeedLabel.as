package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class SpeedLabel extends MovieClip
   {
      
      private static const SPEED_TEXT:String = "$SPEED";
      
      private static const REV_TEXT:String = "$REV";
       
      
      public var Button_mc:WeaponButton;
      
      public var ReverseBG_mc:MovieClip;
      
      private var ThrottleButtonDataPC:ButtonBaseData;
      
      private var ThrottleButtonDataConsoleMove:ButtonBaseData;
      
      private var ThrottleButtonDataConsoleLook:ButtonBaseData;
      
      private var CurrentButtonData:ButtonBaseData;
      
      private var KBM:Boolean = false;
      
      private var LastStickSwap:* = false;
      
      private var RevBounds:Rectangle = null;
      
      private var UpdateRevBounds:Boolean = true;
      
      public function SpeedLabel()
      {
         this.ThrottleButtonDataPC = new ButtonBaseData(SPEED_TEXT,[new UserEventData("Forward",null),new UserEventData("Back",null)],true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,true,true);
         this.ThrottleButtonDataConsoleMove = new ButtonBaseData(SPEED_TEXT,new UserEventData("Move",null),true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,true,true);
         this.ThrottleButtonDataConsoleLook = new ButtonBaseData(SPEED_TEXT,new UserEventData("Look",null),true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,true,true);
         super();
         this.ReverseBG_mc.visible = true;
         this.Button_mc.addEventListener(WeaponButton.REDRAW_EVENT,this.UpdateReverseButtonBounds);
      }
      
      private function UpdateReverseButtonBounds() : *
      {
         var _loc1_:TextField = null;
         if(this.UpdateRevBounds)
         {
            _loc1_ = this.Button_mc.Label_mc.LabelInstance_mc.Label_tf;
            this.RevBounds = _loc1_.getBounds(this);
            this.ReverseBG_mc.x = this.RevBounds.x;
            this.ReverseBG_mc.y = this.RevBounds.y;
            this.ReverseBG_mc.width = this.RevBounds.width;
            this.ReverseBG_mc.height = this.RevBounds.height;
            this.UpdateRevBounds = false;
         }
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = false;
         if(this.ReverseBG_mc.visible != param1.bReverse || this.LastStickSwap != param1.bStickSwap)
         {
            this.LastStickSwap = param1.bStickSwap;
            this.ThrottleButtonDataPC.bEnabled = !param1.bReverse;
            this.ThrottleButtonDataConsoleMove.bEnabled = !param1.bReverse;
            this.ThrottleButtonDataConsoleLook.bEnabled = !param1.bReverse;
            this.CurrentButtonData = this.KBM ? this.ThrottleButtonDataPC : (!!this.LastStickSwap ? this.ThrottleButtonDataConsoleLook : this.ThrottleButtonDataConsoleMove);
            this.ReverseBG_mc.visible = param1.bReverse;
            _loc2_ = true;
         }
         var _loc3_:* = this.Button_mc.UpdateCount(param1.speed);
         this.UpdateRevBounds = this.UpdateRevBounds || _loc3_;
         _loc2_ = _loc3_ || _loc2_;
         if(_loc2_)
         {
            this.Button_mc.StoreButtonData(this.CurrentButtonData);
            this.Button_mc.UpdateName(!!param1.bReverse ? REV_TEXT : SPEED_TEXT);
            _loc4_ = this.Button_mc.GetButtonText();
            this.ThrottleButtonDataPC.sButtonText = _loc4_;
            this.ThrottleButtonDataConsoleMove.sButtonText = _loc4_;
            this.ThrottleButtonDataConsoleLook.sButtonText = _loc4_;
            this.Button_mc.SetButtonData(this.CurrentButtonData);
         }
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
         if(this.KBM != (param1.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE))
         {
            this.KBM = param1.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
            this.CurrentButtonData = this.KBM ? this.ThrottleButtonDataPC : (!!this.LastStickSwap ? this.ThrottleButtonDataConsoleLook : this.ThrottleButtonDataConsoleMove);
            this.Button_mc.StoreButtonData(this.CurrentButtonData);
            this.Button_mc.SetButtonData(this.CurrentButtonData);
            if(param1.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
            {
               this.Button_mc.x = -this.Button_mc.PCButton_mc.width;
            }
            else
            {
               this.Button_mc.x = -this.Button_mc.ConsoleButton_mc.width;
            }
         }
         this.UpdateRevBounds = true;
      }
   }
}

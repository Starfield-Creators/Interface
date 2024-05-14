package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TabBar extends MovieClip
   {
      
      public static const TAB_LEFT:String = "TabLeft";
      
      public static const TAB_RIGHT:String = "TabRight";
      
      public static const SET_CATEGORY:String = "SetCategory";
       
      
      public var Combat_mc:MovieClip;
      
      public var Science_mc:MovieClip;
      
      public var Tech_mc:MovieClip;
      
      public var Physical_mc:MovieClip;
      
      public var Social_mc:MovieClip;
      
      public var TabLeftButton_mc:MovieClip;
      
      public var TabRightButton_mc:MovieClip;
      
      private var OverCombatCatcher:Boolean = false;
      
      private var OverScienceCatcher:Boolean = false;
      
      private var OverTechCatcher:Boolean = false;
      
      private var OverPhysicalCatcher:Boolean = false;
      
      private var OverSocialCatcher:Boolean = false;
      
      private var OverTabLeftButtonCatcher:Boolean = false;
      
      private var OverTabRightButtonCatcher:Boolean = false;
      
      public var Clips:Array;
      
      private var TabLeftButtonDataKBM:ButtonBaseData;
      
      private var TabRightButtonDataKBM:ButtonBaseData;
      
      private var TabLeftButtonDataController:ButtonBaseData;
      
      private var TabRightButtonDataController:ButtonBaseData;
      
      public function TabBar()
      {
         this.Clips = new Array();
         super();
         this.Clips.push(this.Combat_mc);
         this.Clips.push(this.Science_mc);
         this.Clips.push(this.Tech_mc);
         this.Clips.push(this.Physical_mc);
         this.Clips.push(this.Social_mc);
         this.Combat_mc.addEventListener(MouseEvent.CLICK,this.onCombatClick);
         this.Science_mc.addEventListener(MouseEvent.CLICK,this.onScienceClick);
         this.Tech_mc.addEventListener(MouseEvent.CLICK,this.onTechClick);
         this.Physical_mc.addEventListener(MouseEvent.CLICK,this.onPhysicalClick);
         this.Social_mc.addEventListener(MouseEvent.CLICK,this.onSocialClick);
         this.Combat_mc.addEventListener(MouseEvent.ROLL_OVER,this.onCombatRollover);
         this.Combat_mc.addEventListener(MouseEvent.ROLL_OUT,this.onCombatRollout);
         this.Science_mc.addEventListener(MouseEvent.ROLL_OVER,this.onScienceRollover);
         this.Science_mc.addEventListener(MouseEvent.ROLL_OUT,this.onScienceRollout);
         this.Tech_mc.addEventListener(MouseEvent.ROLL_OVER,this.onTechRollover);
         this.Tech_mc.addEventListener(MouseEvent.ROLL_OUT,this.onTechRollout);
         this.Physical_mc.addEventListener(MouseEvent.ROLL_OVER,this.onPhysicalRollover);
         this.Physical_mc.addEventListener(MouseEvent.ROLL_OUT,this.onPhysicalRollout);
         this.Social_mc.addEventListener(MouseEvent.ROLL_OVER,this.onSocialRollover);
         this.Social_mc.addEventListener(MouseEvent.ROLL_OUT,this.onSocialRollout);
         this.TabLeftButton_mc.addEventListener(MouseEvent.ROLL_OVER,this.onTabLeftButtonRollover);
         this.TabLeftButton_mc.addEventListener(MouseEvent.ROLL_OUT,this.onTabLeftButtonRollout);
         this.TabRightButton_mc.addEventListener(MouseEvent.ROLL_OVER,this.onTabRightButtonRollover);
         this.TabRightButton_mc.addEventListener(MouseEvent.ROLL_OUT,this.onTabRightButtonRollout);
         this.TabLeftButtonDataKBM = new ButtonBaseData("",new UserEventData("Left",this.onTabLeft,""));
         this.TabRightButtonDataKBM = new ButtonBaseData("",new UserEventData("Right",this.onTabRight,""));
         this.TabLeftButtonDataController = new ButtonBaseData("",new UserEventData("LShoulder",this.onTabLeft,""));
         this.TabRightButtonDataController = new ButtonBaseData("",new UserEventData("RShoulder",this.onTabRight,""));
         this.TabLeftButton_mc.SetButtonData(this.TabLeftButtonDataKBM);
         this.TabRightButton_mc.SetButtonData(this.TabRightButtonDataKBM);
      }
      
      private function onCombatClick(param1:Event) : *
      {
         dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":1},true,true));
      }
      
      private function onScienceClick(param1:Event) : *
      {
         dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":2},true,true));
      }
      
      private function onTechClick(param1:Event) : *
      {
         dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":3},true,true));
      }
      
      private function onPhysicalClick(param1:Event) : *
      {
         dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":4},true,true));
      }
      
      private function onSocialClick(param1:Event) : *
      {
         dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":5},true,true));
      }
      
      private function onCombatRollover() : void
      {
         this.OverCombatCatcher = true;
      }
      
      private function onCombatRollout() : void
      {
         this.OverCombatCatcher = false;
      }
      
      private function onScienceRollover() : void
      {
         this.OverScienceCatcher = true;
      }
      
      private function onScienceRollout() : void
      {
         this.OverScienceCatcher = false;
      }
      
      private function onTechRollover() : void
      {
         this.OverTechCatcher = true;
      }
      
      private function onTechRollout() : void
      {
         this.OverTechCatcher = false;
      }
      
      private function onPhysicalRollover() : void
      {
         this.OverPhysicalCatcher = true;
      }
      
      private function onPhysicalRollout() : void
      {
         this.OverPhysicalCatcher = false;
      }
      
      private function onSocialRollover() : void
      {
         this.OverSocialCatcher = true;
      }
      
      private function onSocialRollout() : void
      {
         this.OverSocialCatcher = false;
      }
      
      private function onTabLeftButtonRollover() : void
      {
         this.OverTabLeftButtonCatcher = true;
      }
      
      private function onTabLeftButtonRollout() : void
      {
         this.OverTabLeftButtonCatcher = false;
      }
      
      private function onTabRightButtonRollover() : void
      {
         this.OverTabRightButtonCatcher = true;
      }
      
      private function onTabRightButtonRollout() : void
      {
         this.OverTabRightButtonCatcher = false;
      }
      
      public function onAccept() : *
      {
         if(this.OverCombatCatcher)
         {
            dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":1},true,true));
         }
         else if(this.OverScienceCatcher)
         {
            dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":2},true,true));
         }
         else if(this.OverTechCatcher)
         {
            dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":3},true,true));
         }
         else if(this.OverPhysicalCatcher)
         {
            dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":4},true,true));
         }
         else if(this.OverSocialCatcher)
         {
            dispatchEvent(new CustomEvent(SET_CATEGORY,{"category":5},true,true));
         }
         else if(this.OverTabLeftButtonCatcher)
         {
            this.onTabLeft();
         }
         else if(this.OverTabRightButtonCatcher)
         {
            this.onTabRight();
         }
      }
      
      public function SetCurrentTab(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.Clips.length)
         {
            if(param1 - 1 == _loc2_)
            {
               this.Clips[_loc2_].gotoAndStop("Selected");
            }
            else
            {
               this.Clips[_loc2_].gotoAndStop("Unselected");
            }
            _loc2_++;
         }
      }
      
      private function onTabLeft() : *
      {
         dispatchEvent(new Event(TAB_LEFT,true,true));
      }
      
      private function onTabRight() : *
      {
         dispatchEvent(new Event(TAB_RIGHT,true,true));
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
         if(param1.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.TabLeftButton_mc.SetButtonData(this.TabLeftButtonDataKBM);
            this.TabRightButton_mc.SetButtonData(this.TabRightButtonDataKBM);
         }
         else
         {
            this.TabLeftButton_mc.SetButtonData(this.TabLeftButtonDataController);
            this.TabRightButton_mc.SetButtonData(this.TabRightButtonDataController);
         }
      }
   }
}

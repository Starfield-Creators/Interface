package Shared.Components.ButtonControls.Buttons
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Patterns.TimelineStateMachine;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.TabButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class TabTextButton extends MovieClip implements IButton
   {
      
      public static const STATE_SELECTED:String = "Selected";
      
      public static const STATE_UNSELECTED:String = "Unselected";
       
      
      public var Label_mc:MovieClip = null;
      
      public var ButtonBackground_mc:MovieClip;
      
      protected var Label_tf:TextField;
      
      protected var Data:TabButtonData;
      
      protected var PreStageData:ButtonData;
      
      protected var bEnabled:Boolean = true;
      
      protected var uButtonColor:uint;
      
      protected var buttonStates:TimelineStateMachine;
      
      protected var actualWidth:Number;
      
      public function TabTextButton()
      {
         this.buttonStates = new TimelineStateMachine();
         super();
         if(!this.Label_mc)
         {
            GlobalFunc.TraceWarning("TabTextButton requires a \'Label_mc\' clip on the timeline");
         }
         if(this.Label_mc.Label_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Label_mc.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.buttonStates.addState(STATE_UNSELECTED,["*"],{"enter":this.onClickEnter});
         this.buttonStates.addState(STATE_SELECTED,["*"],{"enter":this.onClickEnter});
         this.buttonStates.startingState(STATE_UNSELECTED);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function SetSelected(param1:Boolean) : void
      {
         this.buttonStates.changeState(param1 ? STATE_SELECTED : STATE_UNSELECTED);
      }
      
      public function GetData() : TabButtonData
      {
         return this.Data;
      }
      
      public function GetPayloadData() : Object
      {
         var _loc1_:Object = {};
         if(Boolean(this.Data) && this.Data.hasOwnProperty("Payload"))
         {
            _loc1_ = this.Data.Payload;
         }
         return _loc1_;
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         this.SetButtonData(this.PreStageData);
      }
      
      protected function SendEvent(param1:UserEventData) : *
      {
         BSUIDataManager.dispatchEvent(new Event(param1.sCodeCallback,true));
      }
      
      protected function SetButtonText() : *
      {
         if(this.Data != null)
         {
            if(this.Label_mc.Label_tf != null)
            {
               GlobalFunc.SetText(this.Label_mc.Label_tf,this.Data.sButtonText,false,false,0,false);
            }
         }
      }
      
      protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = this.Enabled;
         if(param2 == null && this.Data.UserEvents.NumUserEvents == 1)
         {
            param2 = this.Data.UserEvents.GetUserEventByIndex(0);
         }
         if(param2 != null)
         {
            if(this.Enabled && param2.bEnabled)
            {
               if(param2.funcCallback != null)
               {
                  param2.funcCallback(this.Data);
               }
               _loc3_ &&= param2.bEnabled;
            }
         }
         return _loc3_;
      }
      
      public function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean
      {
         var asEventName:String = param1;
         var abPressed:Boolean = param2;
         var abHandled:Boolean = param3;
         var handled:Boolean = abHandled;
         if(!handled)
         {
            this.Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
            {
               if(!abPressed)
               {
                  handled = OnMouseClick(null,param1);
               }
            });
         }
         return handled;
      }
      
      protected function onClickEnter(param1:Object) : void
      {
         var _loc2_:String = String(param1.currentState);
         var _loc3_:String = String(param1.fromState);
         if(this.Data && _loc2_ === STATE_SELECTED && _loc2_ !== _loc3_)
         {
            GlobalFunc.PlayMenuSound(this.Data.sClickSound);
         }
         gotoAndStop(_loc2_);
      }
      
      public function SetButtonData(param1:ButtonData) : void
      {
         if(stage != null)
         {
            if(this.Data != param1)
            {
               this.Data = param1 as TabButtonData;
               if(this.Data != null)
               {
                  this.SetButtonText();
                  this.Visible = this.Data.bVisible;
                  this.Enabled = this.Data.bEnabled;
               }
               else
               {
                  this.Visible = false;
                  this.Enabled = false;
               }
            }
            else if(this.Data != null)
            {
               if(this.Visible != this.Data.bVisible)
               {
                  this.Visible = this.Data.bVisible;
               }
               if(this.Enabled != this.Data.bEnabled)
               {
                  this.Enabled = this.Data.bEnabled;
               }
            }
         }
         else
         {
            this.PreStageData = param1;
         }
      }
      
      public function set Width(param1:Number) : void
      {
         this.actualWidth = param1;
         if(this.ButtonBackground_mc)
         {
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.width = this.actualWidth;
         }
         this.Label_mc.Label_tf.width = this.actualWidth - 2 * this.Label_mc.x;
      }
      
      public function set Height(param1:Number) : void
      {
         if(this.ButtonBackground_mc)
         {
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.height = param1;
         }
      }
      
      public function set ButtonColor(param1:uint) : void
      {
         this.uButtonColor = param1;
         if(this.Label_mc.Label_tf != null)
         {
            this.Label_mc.Label_tf.textColor = this.uButtonColor;
         }
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.visible = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.visible;
      }
      
      public function get Enabled() : Boolean
      {
         return this.bEnabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this.bEnabled = param1;
      }
      
      public function get Width() : Number
      {
         return this.width;
      }
      
      public function get Height() : Number
      {
         return this.height;
      }
      
      public function get HandlePriority() : int
      {
         return IButtonUtils.BUTTON_PRIORITY_PRESS;
      }
   }
}

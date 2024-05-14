package Shared.Components.ButtonControls.Buttons
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Utils.ButtonKeyHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class MinimalButton extends BSDisplayObject implements IButton
   {
      
      public static const BUTTON_DATA_CHANGE:String = "ButtonDataChange";
      
      protected static const BACKGROUND_SPACING:Number = 4;
       
      
      public var PCButton_mc:MovieClip = null;
      
      public var ConsoleButton_mc:MovieClip = null;
      
      public var Label_mc:MovieClip = null;
      
      protected var KeyHelper:ButtonKeyHelper = null;
      
      protected var Data:Object;
      
      protected var PreStageData:ButtonData;
      
      protected var bEnabled:Boolean = true;
      
      protected var bMouseOverButton:* = false;
      
      protected var uButtonColor:uint;
      
      protected var bCustomColor:Boolean = false;
      
      protected var LastLabelText:String = "";
      
      protected var VisibleFlag:Boolean = true;
      
      protected var _invalidHash:Object;
      
      public function MinimalButton()
      {
         super();
         this._invalidHash = {};
         this.KeyHelper = new ButtonKeyHelper();
      }
      
      protected function get LabelInstance_mc() : ButtonLabel
      {
         return this.Label_mc != null && this.Label_mc.LabelInstance_mc != null ? this.Label_mc.LabelInstance_mc as ButtonLabel : null;
      }
      
      protected function get PCButtonInstance_mc() : PCButton
      {
         return this.PCButton_mc != null && this.PCButton_mc.ButtonInstance_mc != null ? this.PCButton_mc.ButtonInstance_mc as PCButton : null;
      }
      
      protected function get ConsoleButtonInstance_mc() : ConsoleButton
      {
         return this.ConsoleButton_mc != null && this.ConsoleButton_mc.ButtonInstance_mc != null ? this.ConsoleButton_mc.ButtonInstance_mc as ConsoleButton : null;
      }
      
      protected function get Label_tf() : TextField
      {
         return this.Label_mc != null ? this.Label_mc.Label_tf : null;
      }
      
      protected function get ConsoleButton_tf() : TextField
      {
         return this.ConsoleButton_mc != null ? this.ConsoleButton_mc.ConsoleButton_tf : null;
      }
      
      protected function get PCButton_tf() : TextField
      {
         return this.PCButton_mc != null ? this.PCButton_mc.PCButton_tf : null;
      }
      
      public function get IsMouseOver() : Boolean
      {
         return this.bMouseOverButton;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         this.SetButtonData(this.PreStageData);
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         if(this.KeyHelper != null)
         {
            this.KeyHelper.OnControlMapChanged(param1);
         }
         this.SetButtonText();
         super.OnControlMapChanged(param1);
      }
      
      override public function redrawDisplayObject() : void
      {
         super.redrawDisplayObject();
         if(this.isInvalid(IButtonUtils.INVALID_STATE))
         {
            this.UpdateButtonEnabledStateInfo();
         }
         if(this.isInvalid(IButtonUtils.INVALID_VISIBILITY))
         {
            this.UpdateVisibility();
         }
         if(this.isInvalid(IButtonUtils.INVALID_COLOR))
         {
            this.UpdateColor();
         }
         if(this.isInvalid(IButtonUtils.INVALID_LABEL_TEXT))
         {
            this.UpdateLabelText();
         }
         if(this.isInvalid(IButtonUtils.INVALID_BINDING_TEXT))
         {
            this.UpdateButtonText();
         }
      }
      
      protected function invalidate(param1:String) : void
      {
         this._invalidHash[param1] = true;
         SetIsDirty();
      }
      
      protected function clearInvalidation(param1:String) : void
      {
         this._invalidHash[param1] = false;
      }
      
      protected function isInvalid(param1:String) : Boolean
      {
         if(this._invalidHash[param1])
         {
            return true;
         }
         return false;
      }
      
      public function SetButtonData(param1:ButtonData) : void
      {
         if(stage != null)
         {
            if(this.Data != param1)
            {
               this.Data = param1;
               if(this.Data != null)
               {
                  this.LabelText = this.Data.sButtonText;
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
               if(this.LastLabelText != this.Data.sButtonText)
               {
                  this.LabelText = this.Data.sButtonText;
               }
            }
         }
         else
         {
            this.PreStageData = param1;
         }
      }
      
      public function RefreshButtonData() : *
      {
         this.SetButtonData(stage != null ? this.Data as ButtonData : this.PreStageData);
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.VisibleFlag = param1;
         if(this.VisibleFlag)
         {
            this.invalidate(IButtonUtils.INVALID_VISIBILITY);
         }
         else
         {
            this.visible = this.VisibleFlag;
         }
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this.bEnabled = param1;
         this.invalidate(IButtonUtils.INVALID_STATE);
      }
      
      public function set ButtonColor(param1:uint) : void
      {
         this.bCustomColor = true;
         this.uButtonColor = param1;
         this.invalidate(IButtonUtils.INVALID_COLOR);
      }
      
      protected function set LabelText(param1:String) : void
      {
         this.LastLabelText = param1;
         this.invalidate(IButtonUtils.INVALID_LABEL_TEXT);
      }
      
      protected function SetButtonText() : void
      {
         this.invalidate(IButtonUtils.INVALID_BINDING_TEXT);
      }
      
      protected function UpdateButtonEnabledStateInfo() : void
      {
         this.clearInvalidation(IButtonUtils.INVALID_STATE);
      }
      
      protected function UpdateVisibility() : void
      {
         this.visible = this.VisibleFlag;
         this.clearInvalidation(IButtonUtils.INVALID_VISIBILITY);
      }
      
      protected function UpdateLabelText() : void
      {
         if(this.LabelInstance_mc != null)
         {
            this.LabelInstance_mc.SetText(this.LastLabelText,this.Data.SubstitutionsA,this.Data.UseHTML);
         }
         else if(this.Label_tf != null)
         {
            GlobalFunc.SetText(this.Label_tf,this.LastLabelText,this.Data.UseHTML,false,0,false,0,this.Data.SubstitutionsA);
         }
         this.clearInvalidation(IButtonUtils.INVALID_LABEL_TEXT);
      }
      
      protected function UpdateButtonText() : void
      {
         var _loc1_:String = null;
         if(this.KeyHelper != null && this.Data != null && (this.ConsoleButton_tf != null || this.PCButton_tf != null || this.PCButtonInstance_mc != null || this.ConsoleButtonInstance_mc != null))
         {
            _loc1_ = this.KeyHelper.GetButtonNameForEvent(this.Data.UserEvents.UserEventKey,this.Data.UserEvents.ContextName);
            if(_loc1_.length == 0)
            {
               _loc1_ = this.KeyHelper.GetButtonStringForEvents(this.Data.UserEvents.userEvents);
            }
            if(this.PCButtonInstance_mc != null)
            {
               this.PCButtonInstance_mc.SetText(!this.KeyHelper.usingController ? _loc1_ : "");
               this.PCButtonInstance_mc.visible = !this.KeyHelper.usingController;
            }
            else if(this.PCButton_tf != null)
            {
               GlobalFunc.SetText(this.PCButton_tf,!this.KeyHelper.usingController ? _loc1_ : "");
               this.PCButton_tf.visible = true;
            }
            if(this.ConsoleButtonInstance_mc != null)
            {
               this.ConsoleButtonInstance_mc.SetText(this.KeyHelper.usingController ? _loc1_ : "");
               this.ConsoleButtonInstance_mc.visible = this.KeyHelper.usingController;
            }
            else if(this.ConsoleButton_tf != null)
            {
               GlobalFunc.SetText(this.ConsoleButton_tf,this.KeyHelper.usingController ? _loc1_ : "");
               this.ConsoleButton_tf.visible = true;
            }
            dispatchEvent(new Event(BUTTON_DATA_CHANGE));
         }
         this.clearInvalidation(IButtonUtils.INVALID_BINDING_TEXT);
      }
      
      protected function UpdateColor() : void
      {
         var _loc1_:* = undefined;
         if(this.bCustomColor)
         {
            _loc1_ = new ColorTransform();
            _loc1_.color = this.uButtonColor;
            if(this.LabelInstance_mc != null)
            {
               this.LabelInstance_mc.labelColor = this.uButtonColor;
            }
            else if(this.Label_tf != null)
            {
               this.Label_tf.textColor = this.uButtonColor;
            }
            if(this.PCButtonInstance_mc != null)
            {
               this.PCButtonInstance_mc.transform.colorTransform = _loc1_;
            }
            else if(this.PCButton_tf != null)
            {
               this.PCButton_tf.textColor = this.uButtonColor;
            }
            if(this.ConsoleButtonInstance_mc != null)
            {
               this.ConsoleButtonInstance_mc.transform.colorTransform = _loc1_;
            }
            else if(this.ConsoleButton_tf != null)
            {
               this.ConsoleButton_tf.textColor = this.uButtonColor;
            }
         }
         this.clearInvalidation(IButtonUtils.INVALID_COLOR);
      }
      
      protected function SendEvent(param1:UserEventData) : *
      {
         BSUIDataManager.dispatchEvent(new Event(param1.sCodeCallback,true));
      }
      
      public function get Visible() : Boolean
      {
         return this.VisibleFlag;
      }
      
      public function get Enabled() : Boolean
      {
         return this.bEnabled;
      }
      
      public function set Width(param1:Number) : void
      {
      }
      
      public function set Height(param1:Number) : void
      {
      }
      
      public function get HandlePriority() : int
      {
         return IButtonUtils.BUTTON_PRIORITY_PRESS;
      }
      
      public function get Width() : Number
      {
         return this.width;
      }
      
      public function get Height() : Number
      {
         return this.height;
      }
      
      protected function HandleButtonHit(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == null && this.Data.UserEvents.NumUserEvents == 1)
         {
            param2 = this.Data.UserEvents.GetUserEventByIndex(0);
         }
         if(param2 != null)
         {
            _loc3_ = this.Enabled && param2.bEnabled;
            if(this.Enabled && param2.bEnabled && param2.funcCallback != null)
            {
               param2.funcCallback();
            }
            if(this.Enabled && param2.bEnabled && param2.sCodeCallback.length > 0)
            {
               this.SendEvent(param2);
            }
         }
         return _loc3_;
      }
      
      protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         if(param2 != null)
         {
            if(this.Enabled && param2.bEnabled)
            {
               if(this.Data.sClickSound.length > 0)
               {
                  GlobalFunc.PlayMenuSound(this.Data.sClickSound);
               }
            }
            else if(this.Visible && this.Data.sClickFailedSound.length > 0)
            {
               GlobalFunc.PlayMenuSound(this.Data.sClickFailedSound);
            }
         }
         return this.HandleButtonHit(param1,param2);
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
   }
}

package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ToggleOption extends MovieClip
   {
       
      
      public var ToggleOptions_mc:MovieClip;
      
      public var LabelText_mc:MovieClip;
      
      public var LeftRollover_mc:MovieClip;
      
      public var RightRollover_mc:MovieClip;
      
      public var SelectedTextColor:Number = 15592941;
      
      public var UnselectedTextColor:Number = 2308933;
      
      private const TYPE_1:uint = 0;
      
      private const TYPE_2:uint = 1;
      
      private var CurrentValue:int = 0;
      
      private var bActive:Boolean = false;
      
      private var Callback:String = "";
      
      public function ToggleOption()
      {
         super();
         this.LeftRollover_mc.alpha = 0;
         this.LeftRollover_mc.addEventListener(MouseEvent.ROLL_OVER,this.onRolloverLeftOption);
         this.LeftRollover_mc.addEventListener(MouseEvent.ROLL_OUT,this.onRolloutLeftOption);
         this.LeftRollover_mc.addEventListener(MouseEvent.CLICK,this.onClickLeftOption);
         this.RightRollover_mc.alpha = 0;
         this.RightRollover_mc.addEventListener(MouseEvent.ROLL_OVER,this.onRolloverRightOption);
         this.RightRollover_mc.addEventListener(MouseEvent.ROLL_OUT,this.onRolloutRightOption);
         this.RightRollover_mc.addEventListener(MouseEvent.CLICK,this.onClickRightOption);
      }
      
      public function set callback(param1:String) : *
      {
         this.Callback = param1;
      }
      
      public function onRolloverLeftOption() : *
      {
         this.LeftRollover_mc.alpha = 1;
      }
      
      public function onRolloutLeftOption() : *
      {
         this.LeftRollover_mc.alpha = 0;
      }
      
      public function onClickLeftOption() : *
      {
         if(this.CurrentValue != this.TYPE_1)
         {
            this.SetSelectedValue(this.TYPE_1,false);
         }
      }
      
      public function onRolloverRightOption() : *
      {
         this.RightRollover_mc.alpha = 1;
      }
      
      public function onRolloutRightOption() : *
      {
         this.RightRollover_mc.alpha = 0;
      }
      
      public function onClickRightOption() : *
      {
         if(this.CurrentValue != this.TYPE_2)
         {
            this.SetSelectedValue(this.TYPE_2,false);
         }
      }
      
      public function set labelText(param1:String) : *
      {
         GlobalFunc.SetText(this.LabelText_mc.text_tf,param1);
      }
      
      public function SetSelectedValue(param1:int, param2:Boolean) : *
      {
         if(this.CurrentValue != param1)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.COLUMN_SWITCH_SOUND);
         }
         this.CurrentValue = param1;
         this.ToggleOptions_mc.gotoAndStop(this.CurrentValue == this.TYPE_1 ? "Option1" : "Option2");
         if(this.CurrentValue == this.TYPE_1)
         {
            this.ToggleOptions_mc.Options1Text_tf.textColor = this.SelectedTextColor;
            this.ToggleOptions_mc.Option2Text_tf.textColor = this.UnselectedTextColor;
         }
         else
         {
            this.ToggleOptions_mc.Options1Text_tf.textColor = this.UnselectedTextColor;
            this.ToggleOptions_mc.Option2Text_tf.textColor = this.SelectedTextColor;
         }
         if(this.Callback != "" && !param2)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.Callback,{"iType":this.CurrentValue}));
         }
      }
      
      public function GetSelectedValue() : int
      {
         return this.CurrentValue;
      }
      
      public function SetActive(param1:Boolean) : *
      {
         if(this.bActive != param1)
         {
            if(param1)
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
               stage.focus = this;
               gotoAndStop("Selected");
               addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
            }
            else
            {
               gotoAndStop("Unselected");
               removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
            }
         }
         this.bActive = param1;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT && this.CurrentValue != this.TYPE_1)
         {
            this.SetSelectedValue(this.TYPE_1,false);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT && this.CurrentValue != this.TYPE_2)
         {
            this.SetSelectedValue(this.TYPE_2,false);
            param1.stopPropagation();
         }
      }
      
      protected function GetValueIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = int(this.TYPE_1);
               break;
            case 1:
               _loc2_ = int(this.TYPE_2);
         }
         return _loc2_;
      }
   }
}

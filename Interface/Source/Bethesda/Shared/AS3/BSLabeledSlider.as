package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class BSLabeledSlider extends BSSlider
   {
       
      
      public var Label_tf:TextField;
      
      public var Max_tf:TextField;
      
      public var Current_mc:MovieClip;
      
      private var _maxTextLabel:String = "";
      
      private var _showCurrentOverMax:Boolean = false;
      
      public function BSLabeledSlider()
      {
         super();
      }
      
      public function SetSliderLabel(param1:String) : *
      {
         GlobalFunc.SetText(this.Label_tf,param1);
      }
      
      private function UpdateMaxText() : *
      {
         var _loc1_:String = this._maxTextLabel + (this._showCurrentOverMax ? value + "/" : "") + maxValue;
         GlobalFunc.SetText(this.Max_tf,_loc1_);
      }
      
      public function set maxTextLabel(param1:String) : *
      {
         if(this._maxTextLabel != param1)
         {
            this._maxTextLabel = param1;
            this.UpdateMaxText();
         }
      }
      
      public function set showCurrentOverMax(param1:Boolean) : *
      {
         if(this._showCurrentOverMax != param1)
         {
            this._showCurrentOverMax = param1;
            this.UpdateMaxText();
         }
      }
      
      override public function redrawDisplayObject() : void
      {
         this.UpdateMaxText();
         GlobalFunc.SetText(this.Current_mc.Text_tf,value.toString());
         super.redrawDisplayObject();
      }
   }
}

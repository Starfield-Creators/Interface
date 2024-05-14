package Shared.Components.ButtonControls.Buttons
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ProgressButton extends ButtonBase
   {
      
      protected static const SHOW:String = "Show";
      
      protected static const HIDE:String = "Hide";
      
      protected static const IDLE:String = "Idle";
      
      protected static const FILL_START:String = "FillStart";
      
      protected static const FILL_COMPLETE:String = "FillComplete";
       
      
      public var ConsoleFill_mc:MovieClip;
      
      public var PCFill_mc:MovieClip;
      
      private var _fillPercent:Number;
      
      private var _fillFrames:int;
      
      private var _fillStartFrame:uint;
      
      private const PC_FILL_WIDTH_OFFSET:Number = 2;
      
      public function ProgressButton()
      {
         var _loc1_:* = undefined;
         super();
         GlobalFunc.BSASSERT(this.consoleFill != null,"ProgressButton " + this.name + " -- missing ConsoleFill clip!");
         GlobalFunc.BSASSERT(this.pcFill != null,"ProgressButton " + this.name + " -- missing PCFill clip!");
         for each(_loc1_ in this.consoleFill.currentLabels)
         {
            if(_loc1_.name == FILL_START)
            {
               this._fillStartFrame = _loc1_.frame;
            }
            if(_loc1_.name == FILL_COMPLETE)
            {
               this._fillFrames = _loc1_.frame - this._fillStartFrame;
            }
         }
      }
      
      private function get consoleFill() : MovieClip
      {
         return this.ConsoleFill_mc;
      }
      
      private function get pcFill() : MovieClip
      {
         return this.PCFill_mc.Anim_mc;
      }
      
      override protected function UpdateButtonText() : void
      {
         super.UpdateButtonText();
         this.consoleFill.visible = KeyHelper.usingController;
         this.pcFill.visible = !KeyHelper.usingController;
         this.pcFill.width = PCButtonInstance_mc.width + this.PC_FILL_WIDTH_OFFSET;
      }
      
      public function get FillPercent() : Number
      {
         return this._fillPercent;
      }
      
      public function set FillPercent(param1:Number) : *
      {
         var _loc2_:uint = 0;
         if(param1 != this._fillPercent)
         {
            this._fillPercent = param1;
            if(this._fillPercent >= 1)
            {
               this.consoleFill.gotoAndPlay(FILL_COMPLETE);
               this.pcFill.gotoAndPlay(FILL_COMPLETE);
            }
            else if(this._fillPercent > 0)
            {
               _loc2_ = this._fillStartFrame + this._fillFrames * this._fillPercent;
               this.consoleFill.gotoAndStop(_loc2_);
               this.pcFill.gotoAndStop(_loc2_);
            }
            else
            {
               this.consoleFill.gotoAndStop(IDLE);
               this.pcFill.gotoAndStop(IDLE);
            }
         }
      }
   }
}

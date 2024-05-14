package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ExtremeWarningBox extends MovieClip
   {
       
      
      public var Message_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private var ShowingResourceHeatmap:Boolean = false;
      
      private var IsExtreme:Boolean = false;
      
      public function ExtremeWarningBox()
      {
         super();
         var _loc1_:Number = this.Icon_mc.getBounds(this).left - getBounds(this).left;
         this.BackgroundInternal_mc.width = _loc1_ + _loc1_ + this.Icon_mc.width + this.Message_tf.textWidth;
         this.BackgroundInternalBox_mc.width = this.BackgroundInternal_mc.width;
         x = (stage.stageWidth - this.BackgroundInternal_mc.width) / 2;
      }
      
      public function get Message_tf() : TextField
      {
         return this.Message_mc.Text_tf;
      }
      
      public function get BackgroundInternal_mc() : MovieClip
      {
         return this.Background_mc.Internal_mc;
      }
      
      public function get BackgroundInternalBox_mc() : MovieClip
      {
         return this.Background_mc.InternalBox_mc;
      }
      
      public function Update(param1:Object) : *
      {
         this.IsExtreme = Boolean(param1.bCanLand) && !param1.bCanSupportOutpost;
         this.UpdateVisibility();
      }
      
      public function SetShowingResourceHeatmap(param1:Boolean) : *
      {
         this.ShowingResourceHeatmap = param1;
         this.UpdateVisibility();
      }
      
      private function UpdateVisibility() : *
      {
         var _loc1_:Boolean = this.IsExtreme && this.ShowingResourceHeatmap;
         var _loc2_:String = _loc1_ ? "On" : "Off";
         if(currentLabel != _loc2_)
         {
            gotoAndStop(_loc2_);
         }
      }
   }
}

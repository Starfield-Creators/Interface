package Components.StarMapWidgets
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class Body extends MovieClip
   {
       
      
      public var Filled_mc:MovieClip;
      
      public var Stroke_mc:MovieClip;
      
      public var Highlight_mc:MovieClip;
      
      public function Body()
      {
         super();
      }
      
      public function SetColor(param1:uint) : *
      {
         var _loc2_:* = new ColorTransform();
         _loc2_.color = param1;
         this.Filled_mc.transform.colorTransform = _loc2_;
      }
      
      public function ShowHighlight(param1:Boolean) : void
      {
         if(param1)
         {
            this.Highlight_mc.gotoAndPlay("rollOver");
         }
         else
         {
            this.Highlight_mc.gotoAndStop("off");
         }
      }
   }
}

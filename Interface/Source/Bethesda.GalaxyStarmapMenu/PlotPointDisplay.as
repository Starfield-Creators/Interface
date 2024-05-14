package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlotPointDisplay extends MovieClip
   {
       
      
      public var bodyName_tf:TextField;
      
      public var systemName_tf:TextField;
      
      public function PlotPointDisplay()
      {
         super();
      }
      
      public function SetText(param1:String, param2:String) : *
      {
         this.bodyName_tf.text = param2;
         this.systemName_tf.text = param1;
      }
   }
}

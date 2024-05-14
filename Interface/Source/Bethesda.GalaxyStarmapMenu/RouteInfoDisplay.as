package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class RouteInfoDisplay extends MovieClip
   {
      
      public static const maxCount:String = "99+";
       
      
      public var bodyCount_tf:TextField;
      
      public function RouteInfoDisplay()
      {
         super();
      }
      
      public function Update(param1:Number) : *
      {
         if(param1 > 99)
         {
            this.bodyCount_tf.text = maxCount;
         }
         else
         {
            this.bodyCount_tf.text = param1.toString();
         }
      }
   }
}

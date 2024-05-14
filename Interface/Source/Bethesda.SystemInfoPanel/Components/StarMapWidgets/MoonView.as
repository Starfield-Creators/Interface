package Components.StarMapWidgets
{
   public class MoonView extends BodyView
   {
      
      public static const MOON_SIZE:Number = 7;
       
      
      public function MoonView()
      {
         super();
      }
      
      override protected function GetMinChildSize() : Number
      {
         return MOON_SIZE;
      }
      
      override protected function GetMaxChildSize() : Number
      {
         return MOON_SIZE;
      }
   }
}

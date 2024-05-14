package
{
   import Components.BSButton;
   import flash.display.MovieClip;
   
   public class WeaponGroupButton extends BSButton
   {
       
      
      public var ButtonText_tf:MovieClip;
      
      public function WeaponGroupButton()
      {
         super();
      }
      
      public function Select() : *
      {
         gotoAndPlay("idle_to_over");
      }
      
      public function Deselect() : *
      {
         gotoAndPlay("over_to_idle");
      }
   }
}

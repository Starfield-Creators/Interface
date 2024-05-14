package
{
   import flash.display.MovieClip;
   
   public class CrewTab extends MovieClip
   {
       
      
      public var Arrows_mc:MovieClip;
      
      public var TabIndex:uint;
      
      public function CrewTab()
      {
         super();
      }
      
      public function Select() : *
      {
         gotoAndStop("rollOn");
      }
      
      public function Deselect() : *
      {
         gotoAndStop("rollOff");
      }
      
      public function SetSortUp() : *
      {
         this.Arrows_mc.gotoAndStop("sortUp");
      }
      
      public function SetSortDown() : *
      {
         this.Arrows_mc.gotoAndStop("sortDown");
      }
      
      public function SetNoSort() : *
      {
         this.Arrows_mc.gotoAndStop("none");
      }
   }
}

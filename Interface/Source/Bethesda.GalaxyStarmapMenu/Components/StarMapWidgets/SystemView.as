package Components.StarMapWidgets
{
   public class SystemView extends BodyView
   {
       
      
      public function SystemView()
      {
         super();
      }
      
      override protected function GetChildBodyClass() : Class
      {
         return PlanetView;
      }
      
      override protected function onExpansionComplete(param1:BodyView) : *
      {
         var _loc2_:PlanetView = param1 as PlanetView;
         _loc2_.ExpandMoons();
         super.onExpansionComplete(param1);
      }
      
      override public function ContractChildBodies() : *
      {
      }
   }
}

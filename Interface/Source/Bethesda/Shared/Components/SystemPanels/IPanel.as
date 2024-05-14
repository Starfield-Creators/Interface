package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingContainer;
   
   public interface IPanel
   {
       
      
      function Open() : void;
      
      function Close() : void;
      
      function OnConfirmDataUpdate(param1:Boolean) : void;
      
      function PopulateButtonBar(param1:uint, param2:int) : void;
      
      function ProcessUserEvent(param1:String, param2:Boolean) : Boolean;
      
      function get activeList() : BSScrollingContainer;
   }
}

package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   
   public interface IButton
   {
       
      
      function SetButtonData(param1:ButtonData) : void;
      
      function set Visible(param1:Boolean) : void;
      
      function get Visible() : Boolean;
      
      function set Enabled(param1:Boolean) : void;
      
      function get Enabled() : Boolean;
      
      function set Width(param1:Number) : void;
      
      function get Width() : Number;
      
      function set Height(param1:Number) : void;
      
      function get Height() : Number;
      
      function get HandlePriority() : int;
      
      function set ButtonColor(param1:uint) : void;
      
      function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean;
   }
}

package
{
   public interface IChargenPage
   {
       
      
      function UpdateData(param1:Object) : *;
      
      function ProcessUserEvent(param1:String, param2:Boolean) : Boolean;
      
      function onEnterPage() : *;
      
      function onExitPage() : *;
      
      function OnControlMapChanged(param1:Object) : void;
      
      function InitFocus() : *;
   }
}

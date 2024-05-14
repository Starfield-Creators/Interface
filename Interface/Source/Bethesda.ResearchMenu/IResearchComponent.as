package
{
   public interface IResearchComponent
   {
       
      
      function Open() : void;
      
      function Close() : void;
      
      function ProcessUserEvent(param1:String, param2:Boolean) : Boolean;
   }
}

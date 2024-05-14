package Shared.AS3.Patterns
{
   import flash.display.MovieClip;
   
   public interface IState
   {
       
      
      function getId() : Object;
      
      function enter(param1:Object = null, param2:MovieClip = null) : void;
      
      function exit(param1:Object = null, param2:MovieClip = null) : void;
      
      function update(param1:Object = null, param2:MovieClip = null) : void;
      
      function processEvent(param1:Object) : Object;
   }
}

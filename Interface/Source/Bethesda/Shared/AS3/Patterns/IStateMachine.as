package Shared.AS3.Patterns
{
   public interface IStateMachine
   {
       
      
      function getCurrentState() : IState;
      
      function getCurrentStateId() : Object;
      
      function processEvent(param1:Object) : void;
      
      function changeState(param1:IState, param2:Object = null) : void;
      
      function changeStateById(param1:Object, param2:Object = null) : void;
      
      function update(param1:Object = null) : void;
   }
}

package HUD.QuestUpdateStates
{
   import Shared.AS3.Patterns.IState;
   import Shared.AS3.Patterns.IStateMachine;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class QuestStateMachine implements IStateMachine
   {
       
      
      protected var States:Dictionary;
      
      protected var CurrentStateId:Object;
      
      protected var PreviousStateId:Object;
      
      protected var NextStateId:Object;
      
      protected var Context:MovieClip;
      
      public function QuestStateMachine(param1:MovieClip)
      {
         super();
         this.States = new Dictionary();
         this.Context = param1;
      }
      
      public function addState(param1:IState) : void
      {
         this.States[param1.getId()] = param1;
      }
      
      public function getCurrentState() : IState
      {
         return this.States[this.CurrentStateId] as QuestState;
      }
      
      public function getCurrentStateId() : Object
      {
         return this.CurrentStateId;
      }
      
      public function processEvent(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:QuestState = this.States[this.CurrentStateId];
         if(_loc2_ !== null)
         {
            _loc3_ = _loc2_.processEvent(param1);
            this.changeStateById(_loc3_,param1);
         }
         else
         {
            GlobalFunc.TraceWarning("QuestStateMachine::processEvent has no active state!");
         }
      }
      
      public function changeState(param1:IState, param2:Object = null) : void
      {
         if(this.States[param1.getId()] !== null)
         {
            this.NextStateId = param1.getId();
            this.update(param2);
         }
         else
         {
            GlobalFunc.TraceWarning("QuestStateMachine trying to change to a state " + param1.getId().toString() + " that doesn\'t exist");
         }
      }
      
      public function changeStateById(param1:Object, param2:Object = null) : void
      {
         if(this.States[param1] !== null)
         {
            this.NextStateId = param1;
            this.update(param2);
         }
         else
         {
            GlobalFunc.TraceWarning("QuestStateMachine trying to change to a state " + param1 + " that doesn\'t exist");
         }
      }
      
      public function update(param1:Object = null) : void
      {
         var _loc2_:QuestState = this.States[this.CurrentStateId];
         param1 ||= {};
         if(_loc2_ !== null)
         {
            _loc2_.update(param1,this.Context);
         }
         switch(_loc2_)
         {
            default:
               _loc2_.exit(param1,this.Context);
            case null:
               this.PreviousStateId = this.CurrentStateId;
               this.CurrentStateId = this.NextStateId;
               this.NextStateId = null;
               _loc2_ = this.States[this.CurrentStateId];
               if(_loc2_ !== null)
               {
                  _loc2_.enter(param1,this.Context);
                  _loc2_.update(param1,this.Context);
               }
               break;
            case null:
         }
      }
      
      public function destroy() : void
      {
         this.States = new Dictionary();
         this.CurrentStateId = null;
         this.PreviousStateId = null;
         this.NextStateId = null;
         this.Context = null;
      }
   }
}

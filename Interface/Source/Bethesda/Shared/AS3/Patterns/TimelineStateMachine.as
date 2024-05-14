package Shared.AS3.Patterns
{
   import Shared.GlobalFunc;
   import flash.utils.Dictionary;
   
   public class TimelineStateMachine extends BaseStateMachine
   {
       
      
      public function TimelineStateMachine()
      {
         super();
      }
      
      override public function startingState(param1:Object) : void
      {
         var _loc2_:BaseStateObject = null;
         var _loc3_:Object = null;
         if(!CurrentStateId && Boolean(States[param1]))
         {
            CurrentStateId = param1;
            _loc2_ = States[param1];
            if(_loc2_.Enter is Function)
            {
               _loc3_ = {"currentState":CurrentStateId};
               if(Boolean(Transitions["start"]) && Boolean(Transitions["start"][CurrentStateId]))
               {
                  _loc3_.label = Transitions["start"][CurrentStateId];
               }
               else if(Boolean(Transitions["*"]) && Boolean(Transitions["*"][CurrentStateId]))
               {
                  _loc3_.label = Transitions["*"][CurrentStateId];
               }
               _loc2_.Enter(_loc3_);
            }
         }
      }
      
      override public function changeState(param1:Object, param2:Object = null) : void
      {
         var _loc4_:BaseStateObject = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc3_:BaseStateObject = States[CurrentStateId];
         if((Boolean(_loc4_ = States[param1])) && this.canTransitionTo(param1) !== null)
         {
            if(_loc3_.Exit is Function)
            {
               _loc3_.Exit({
                  "currentState":CurrentStateId,
                  "toState":param1,
                  "data":param2
               });
            }
            _loc5_ = CurrentStateId;
            CurrentStateId = param1;
            if(_loc4_.Enter is Function)
            {
               _loc6_ = {
                  "currentState":CurrentStateId,
                  "fromState":_loc5_,
                  "data":param2
               };
               if((_loc7_ = Transitions[_loc5_] || Transitions["*"]) && Boolean(_loc7_[CurrentStateId]))
               {
                  _loc8_ = _loc7_[CurrentStateId];
                  _loc6_.label = !!_loc8_.hasOwnProperty("label") ? _loc8_.label : _loc8_;
               }
               _loc4_.Enter(_loc6_);
            }
         }
         else
         {
            if(_loc3_ == _loc4_ && _loc3_.Update is Function)
            {
               _loc3_.Update({"data":param2});
            }
            if(CurrentStateId !== param1)
            {
               GlobalFunc.TraceWarning("TimelineStateMachine Unable to transition from " + CurrentStateId + " to " + param1);
            }
         }
      }
      
      override protected function parseFromStates(param1:Array, param2:Object) : Array
      {
         var _loc6_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc6_ = param1[_loc3_]).hasOwnProperty("state"))
            {
               _loc5_.push(_loc6_.state);
               if(!Transitions[_loc6_.state])
               {
                  Transitions[_loc6_.state] = new Dictionary();
               }
               Transitions[_loc6_.state][param2] = _loc6_.label;
            }
            else
            {
               _loc5_.push(_loc6_);
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      override protected function canTransitionTo(param1:Object, param2:Object = null) : Object
      {
         var _loc3_:BaseStateObject = States[param1];
         var _loc4_:* = null;
         if(_loc3_ != getCurrentState())
         {
            _loc4_ = super.canTransitionTo(param1,param2);
         }
         return _loc4_;
      }
   }
}

package Shared.AS3.Patterns
{
   import Shared.GlobalFunc;
   import flash.utils.Dictionary;
   
   public class BaseStateMachine
   {
       
      
      protected var CurrentStateId:Object;
      
      protected var PreviousStateId:Object;
      
      protected var States:Dictionary;
      
      protected var Transitions:Dictionary;
      
      protected var Triggers:Dictionary;
      
      public function BaseStateMachine()
      {
         super();
         this.Transitions = new Dictionary();
         this.Triggers = new Dictionary();
      }
      
      public function addState(param1:Object, param2:Array = null, param3:Object = null, param4:Array = null) : void
      {
         if(!this.States)
         {
            this.States = new Dictionary();
         }
         param2 ||= ["*"];
         param3 ||= {};
         var _loc5_:Array = this.parseFromStates(param2,param1);
         this.parseTriggers(param4,param1);
         if(this.States[param1])
         {
            GlobalFunc.TraceWarning("Overwriting existing state " + param1);
         }
         this.States[param1] = new BaseStateObject(param1,_loc5_,param3.enter,param3.update,param3.exit);
      }
      
      public function getCurrentStateId() : Object
      {
         return this.CurrentStateId;
      }
      
      public function getPreviosuStateId() : Object
      {
         return this.PreviousStateId;
      }
      
      public function startingState(param1:Object) : void
      {
         var _loc2_:BaseStateObject = null;
         var _loc3_:Object = null;
         if(!this.CurrentStateId && Boolean(this.States[param1]))
         {
            this.CurrentStateId = param1;
            _loc2_ = this.States[param1];
            if(_loc2_.Enter is Function)
            {
               _loc3_ = {"currentState":this.CurrentStateId};
               _loc2_.Enter(_loc3_);
            }
         }
      }
      
      public function changeState(param1:Object, param2:Object = null) : void
      {
         var _loc6_:Object = null;
         var _loc3_:BaseStateObject = this.States[this.CurrentStateId];
         var _loc4_:* = this.canTransitionTo(param1,param2);
         var _loc5_:BaseStateObject;
         if((_loc5_ = this.States[_loc4_]) !== null)
         {
            if(_loc3_.Exit is Function)
            {
               _loc3_.Exit({
                  "currentState":this.CurrentStateId,
                  "toState":param1,
                  "data":param2
               });
            }
            this.PreviousStateId = this.CurrentStateId;
            this.CurrentStateId = param1;
            if(_loc5_.Enter is Function)
            {
               _loc6_ = {
                  "currentState":this.CurrentStateId,
                  "fromState":this.PreviousStateId,
                  "data":param2
               };
               _loc5_.Enter(_loc6_);
            }
         }
         else if(this.CurrentStateId !== param1)
         {
            GlobalFunc.TraceWarning("BaseStateMachine Unable to transition from " + this.CurrentStateId + " to " + param1);
         }
      }
      
      public function processEvent(param1:String, param2:Object = null) : void
      {
         if(this.Triggers[param1])
         {
            this.changeState(this.Triggers[param1],param2);
         }
         else
         {
            GlobalFunc.TraceWarning("trigger " + param1 + " not registered for " + this.CurrentStateId);
         }
      }
      
      public function destroy() : void
      {
         this.States = new Dictionary();
         this.Transitions = new Dictionary();
         this.Triggers = new Dictionary();
      }
      
      protected function getCurrentState() : BaseStateObject
      {
         return this.States[this.CurrentStateId];
      }
      
      protected function canTransitionTo(param1:Object, param2:Object = null) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc3_:BaseStateObject = this.States[param1];
         if(_loc3_ && (_loc3_.From.length && _loc3_.From[0] === "*") || _loc3_.From.indexOf(this.CurrentStateId) !== -1)
         {
            _loc4_ = param1;
            if(this.Transitions[this.CurrentStateId])
            {
               if((Boolean(_loc5_ = this.Transitions[this.CurrentStateId][_loc4_])) && _loc5_.hasOwnProperty("guard"))
               {
                  _loc4_ = null;
                  if(_loc5_.guard is Function)
                  {
                     _loc4_ = !!_loc5_.guard(param2) ? param1 : _loc5_.fail;
                  }
                  else if(Boolean(param2) && param2[_loc5_.guard] !== true)
                  {
                     _loc4_ = _loc5_.fail;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      protected function parseFromStates(param1:Array, param2:Object) : Array
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
               if(!this.Transitions[_loc6_.state])
               {
                  this.Transitions[_loc6_.state] = new Dictionary();
               }
               this.Transitions[_loc6_.state][param2] = _loc6_;
            }
            else
            {
               _loc5_.push(_loc6_);
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      protected function parseTriggers(param1:Array, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         if(param1)
         {
            _loc3_ = 0;
            _loc4_ = int(param1.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = param1[_loc3_];
               if(!this.Triggers[_loc5_])
               {
                  this.Triggers[_loc5_] = param2;
               }
               else
               {
                  GlobalFunc.TraceWarning("Trigger " + _loc5_ + " already exists and points to " + this.Triggers[_loc5_]);
               }
               _loc3_++;
            }
         }
      }
   }
}

package HUD.QuestUpdateStates
{
   import Shared.AS3.Patterns.IState;
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class QuestState implements IState
   {
      
      public static const STATE_HIDDEN:uint = EnumHelper.GetEnum(0);
      
      public static const STATE_ALWAYS_UP:uint = EnumHelper.GetEnum();
      
      public static const STATE_ANIMATING:uint = EnumHelper.GetEnum();
       
      
      protected var Id:Object;
      
      protected var Transitions:Dictionary;
      
      protected var OnEnter:Function;
      
      protected var OnUpdate:Function;
      
      protected var OnExit:Function;
      
      public function QuestState(param1:Object, param2:Dictionary, param3:Object = null)
      {
         super();
         this.Id = param1;
         this.Transitions = param2;
         if(param3)
         {
            this.OnEnter = param3.enter;
            this.OnUpdate = param3.update;
            this.OnExit = param3.exit;
         }
      }
      
      public function getId() : Object
      {
         return this.Id;
      }
      
      public function enter(param1:Object = null, param2:MovieClip = null) : void
      {
         if(this.OnEnter != null)
         {
            this.OnEnter(param2,param1);
         }
      }
      
      public function exit(param1:Object = null, param2:MovieClip = null) : void
      {
         if(this.OnExit != null)
         {
            this.OnExit(param2,param1);
         }
      }
      
      public function update(param1:Object = null, param2:MovieClip = null) : void
      {
         if(this.OnUpdate != null)
         {
            this.OnUpdate(param2,param1);
         }
      }
      
      public function processEvent(param1:Object) : Object
      {
         return this.canTransition(param1.uType,param1);
      }
      
      protected function canTransition(param1:uint, param2:Object = null) : Object
      {
         var _loc3_:Object = this.Transitions[param1];
         if(Boolean(_loc3_) && _loc3_.hasOwnProperty("guard"))
         {
            if(_loc3_.guard is Function)
            {
               return !!_loc3_.guard(param2) ? _loc3_.pass : _loc3_.fail;
            }
            if(Boolean(param2) && param2[_loc3_.guard] === true)
            {
               return _loc3_.pass;
            }
            return _loc3_.fail;
         }
         return _loc3_;
      }
   }
}

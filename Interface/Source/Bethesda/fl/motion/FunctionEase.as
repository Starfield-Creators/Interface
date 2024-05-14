package fl.motion
{
   import flash.utils.*;
   
   public class FunctionEase implements ITween
   {
       
      
      private var _functionName:String = "";
      
      public var easingFunction:Function = null;
      
      public var parameters:Array = null;
      
      private var _target:String = "";
      
      public function FunctionEase(param1:XML = null)
      {
         super();
         this.parseXML(param1);
      }
      
      public function get functionName() : String
      {
         return this._functionName;
      }
      
      public function set functionName(param1:String) : void
      {
         var _loc2_:Array = param1.split(".");
         var _loc3_:String = _loc2_.pop();
         var _loc4_:String = _loc2_.join(".");
         var _loc5_:Class;
         if((_loc5_ = getDefinitionByName(_loc4_) as Class)[_loc3_] is Function)
         {
            this.easingFunction = _loc5_[_loc3_];
            this._functionName = param1;
         }
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(param1:String) : void
      {
         this._target = param1;
      }
      
      private function parseXML(param1:XML = null) : FunctionEase
      {
         if(!param1)
         {
            return this;
         }
         if(param1.@functionName.length())
         {
            this.functionName = param1.@functionName;
         }
         if(param1.@target.length())
         {
            this.target = param1.@target;
         }
         return this;
      }
      
      public function getValue(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Array = null;
         if(this.parameters is Array)
         {
            _loc5_ = [param1,param2,param3,param4].concat(this.parameters);
            return this.easingFunction.apply(null,_loc5_);
         }
         return this.easingFunction(param1,param2,param3,param4);
      }
   }
}

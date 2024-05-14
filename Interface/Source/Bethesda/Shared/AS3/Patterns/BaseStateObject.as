package Shared.AS3.Patterns
{
   public class BaseStateObject
   {
       
      
      public var From:Array;
      
      public var Enter:Function;
      
      public var Update:Function;
      
      public var Exit:Function;
      
      protected var Id:Object;
      
      public function BaseStateObject(param1:Object, param2:Array = null, param3:Function = null, param4:Function = null, param5:Function = null)
      {
         super();
         this.Id = param1;
         this.From = param2 || ["*"];
         this.Enter = param3;
         this.Update = param4;
         this.Exit = param5;
      }
      
      public function getId() : Object
      {
         return this.Id;
      }
   }
}
